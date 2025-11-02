import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTasks from '@salesforce/apex/TaskManagerApexController.getTasks';
import closeTask from '@salesforce/apex/TaskManagerApexController.closeTask';
import deferTask from '@salesforce/apex/TaskManagerApexController.deferTask';

// Phase 1: Mock-only prototype. No server calls yet.
// Follow SLDS-first and clear inline comments per project rules.

const GROUPS_IN_ORDER = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Next Week', 'Later'];

export default class TaskManager extends LightningElement {
    // Public reactive state for template binding
    orderedGroups = GROUPS_IN_ORDER;

    // For template simplicity (no computed access like obj[key] in markup), we maintain
    // per-group arrays and simple boolean/count helpers as plain properties.
    @track groups = {
        overdue: [],
        today: [],
        tomorrow: [],
        thisWeek: [],
        nextWeek: [],
        later: []
    };

    // Count helpers
    countOverdue = 0;
    countToday = 0;
    countTomorrow = 0;
    countThisWeek = 0;
    countNextWeek = 0;
    countLater = 0;

    // Visible sections booleans (to avoid computed property access in template)
    hasOverdue = false;
    hasToday = false;
    hasTomorrow = false;
    hasThisWeek = false;
    hasNextWeek = false;
    hasLater = false;

    // Internal flat store of all tasks loaded from server. Each row: { id, subject, priority, activityDate (Date|null) }
    allTasks = [];

    connectedCallback() {
        // Load tasks from server then build per-group arrays and helpers
        this.loadTasks();
    }

    // Load tasks from Apex and rebuild groups
    async loadTasks() {
        try {
            const grouped = await getTasks();
            // Flatten into allTasks for local regrouping/helpers if needed
            const buckets = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Next Week', 'Later'];
            const rows = [];
            buckets.forEach((key) => {
                const lst = grouped && grouped[key] ? grouped[key] : [];
                lst.forEach((t) => {
                    rows.push({
                        id: t.Id,
                        subject: t.Subject,
                        priority: t.Priority,
                        activityDate: t.ActivityDate ? this.normalizeToDay(new Date(t.ActivityDate)) : null
                    });
                });
            });
            this.allTasks = rows;
            this.regroupAll();
        } catch (e) {
            this.showToast('Error loading tasks', this.reduceError(e), 'error');
        }
    }

    // Handle click: defer using Apex then refresh
    async handleDefer(event) {
        const taskId = event.currentTarget.dataset.id;
        if (!taskId) return;
        try {
            const ok = await deferTask({ taskId });
            if (ok) {
                this.showToast('Task deferred', 'Task was moved to tomorrow.', 'success');
                await this.loadTasks();
            } else {
                this.showToast('Defer failed', 'Unable to defer the task.', 'error');
            }
        } catch (e) {
            this.showToast('Defer failed', this.reduceError(e), 'error');
        }
    }

    // Handle click: complete using Apex then refresh
    async handleComplete(event) {
        const taskId = event.currentTarget.dataset.id;
        if (!taskId) return;
        try {
            const ok = await closeTask({ taskId });
            if (ok) {
                this.showToast('Task completed', 'Task marked as Completed.', 'success');
                await this.loadTasks();
            } else {
                this.showToast('Complete failed', 'Unable to complete the task.', 'error');
            }
        } catch (e) {
            this.showToast('Complete failed', this.reduceError(e), 'error');
        }
    }

    // Rebuild all groups and helper flags/counts
    regroupAll() {
        // Reset groups
        this.groups.overdue = [];
        this.groups.today = [];
        this.groups.tomorrow = [];
        this.groups.thisWeek = [];
        this.groups.nextWeek = [];
        this.groups.later = [];

        const today = this.normalizeToDay(new Date());
        const tomorrow = this.addDays(today, 1);

        const { startOfThisWeek, endOfThisWeek, startOfNextWeek, endOfNextWeek } = this.computeWeekWindows(today);

        // Classify and push
        this.allTasks.forEach((t) => {
            const groupKey = this.computeGroupKey(t.activityDate, today, tomorrow, startOfThisWeek, endOfThisWeek, startOfNextWeek, endOfNextWeek);
            const viewRow = this.toViewRow(t);

            switch (groupKey) {
                case 'Overdue':
                    this.groups.overdue.push(viewRow);
                    break;
                case 'Today':
                    this.groups.today.push(viewRow);
                    break;
                case 'Tomorrow':
                    this.groups.tomorrow.push(viewRow);
                    break;
                case 'This Week':
                    this.groups.thisWeek.push(viewRow);
                    break;
                case 'Next Week':
                    this.groups.nextWeek.push(viewRow);
                    break;
                default:
                    this.groups.later.push(viewRow);
                    break;
            }
        });

        // Counts
        this.countOverdue = this.groups.overdue.length;
        this.countToday = this.groups.today.length;
        this.countTomorrow = this.groups.tomorrow.length;
        this.countThisWeek = this.groups.thisWeek.length;
        this.countNextWeek = this.groups.nextWeek.length;
        this.countLater = this.groups.later.length;

        // Empty flags
        this.hasOverdue = this.countOverdue > 0;
        this.hasToday = this.countToday > 0;
        this.hasTomorrow = this.countTomorrow > 0;
        this.hasThisWeek = this.countThisWeek > 0;
        this.hasNextWeek = this.countNextWeek > 0;
        this.hasLater = this.countLater > 0;
    }

    // Convert model row to view row with display helpers and SLDS classes
    toViewRow(t) {
        return {
            id: t.id,
            subject: t.subject,
            priority: t.priority,
            priorityClass: this.computePriorityClass(t.priority),
            activityDateLabel: this.formatDateLabel(t.activityDate)
        };
    }

    // Group key based on requirements
    computeGroupKey(activityDate, today, tomorrow, startOfThisWeek, endOfThisWeek, startOfNextWeek, endOfNextWeek) {
        if (!activityDate) return 'Later';

        const d = this.normalizeToDay(new Date(activityDate));

        if (d.getTime() < today.getTime()) return 'Overdue';
        if (d.getTime() === today.getTime()) return 'Today';
        if (d.getTime() === tomorrow.getTime()) return 'Tomorrow';

        if (d.getTime() > tomorrow.getTime() && d >= startOfThisWeek && d <= endOfThisWeek) {
            return 'This Week';
        }
        if (d >= startOfNextWeek && d <= endOfNextWeek) {
            return 'Next Week';
        }
        return 'Later';
    }

    // Compute week windows (Mon–Sun) for current and next week
    computeWeekWindows(today) {
        const day = today.getDay(); // 0=Sun,1=Mon,...6=Sat
        // We want Monday as start of week
        const diffToMonday = ((day + 6) % 7); // 0 if Monday, 6 if Sunday
        const startOfThisWeek = this.addDays(today, -diffToMonday);
        const endOfThisWeek = this.addDays(startOfThisWeek, 6);

        const startOfNextWeek = this.addDays(startOfThisWeek, 7);
        const endOfNextWeek = this.addDays(startOfNextWeek, 6);

        return {
            startOfThisWeek,
            endOfThisWeek,
            startOfNextWeek,
            endOfNextWeek
        };
    }

    // Helpers
    addDays(dateObj, days) {
        const d = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate());
        d.setDate(d.getDate() + days);
        return d;
    }

    normalizeToDay(dateObj) {
        return new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate());
    }

    // Basic date formatter for label (Phase 1 simple)
    formatDateLabel(dateObj) {
        if (!dateObj) return 'No due date';
        try {
            return dateObj.toLocaleDateString();
        } catch (e) {
            return 'Invalid date';
        }
    }

    // Priority badge CSS using SLDS utility tokens
    computePriorityClass(priority) {
        // SLDS badge styles via utility classes
        switch ((priority || '').toLowerCase()) {
            case 'high':
                return 'slds-badge slds-theme_error';
            case 'normal':
                return 'slds-badge slds-theme_info';
            case 'low':
                return 'slds-badge slds-theme_success';
            default:
                return 'slds-badge';
        }
    }

    // Getters used by template to map group name label to arrays and helpers
    getGroupArray(groupName) {
        switch (groupName) {
            case 'Overdue':
                return this.groups.overdue;
            case 'Today':
                return this.groups.today;
            case 'Tomorrow':
                return this.groups.tomorrow;
            case 'This Week':
                return this.groups.thisWeek;
            case 'Next Week':
                return this.groups.nextWeek;
            case 'Later':
            default:
                return this.groups.later;
        }
    }
    getGroupCount(groupName) {
        switch (groupName) {
            case 'Overdue':
                return this.countOverdue;
            case 'Today':
                return this.countToday;
            case 'Tomorrow':
                return this.countTomorrow;
            case 'This Week':
                return this.countThisWeek;
            case 'Next Week':
                return this.countNextWeek;
            case 'Later':
            default:
                return this.countLater;
        }
    }
    hasGroupItems(groupName) {
        return this.getGroupCount(groupName) > 0;
    }
}
