import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// Phase 5: Wire to Apex (imperative, non-cacheable)
import getTasks from '@salesforce/apex/TaskManagerApexController.getTasks';
import closeTask from '@salesforce/apex/TaskManagerApexController.closeTask';
import deferTask from '@salesforce/apex/TaskManagerApexController.deferTask';

// Client for Task Manager
export default class TaskManager extends LightningElement {
    // Fixed order required by requirements
    groupsOrder = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Next Week', 'Later'];

    // Map-like structure keyed by group name
    @track dataByGroup = {};

    // Simple loading flag
    isLoading = false;

    connectedCallback() {
        this.loadTasks();
    }

    async loadTasks() {
        this.isLoading = true;
        try {
            // Get data from Apex; it returns Map<String, List<Task>>
            const serverMap = await getTasks();
            // Normalize to plain object expected by UI with formatting
            const normalized = {};
            const groupKeys = this.groupsOrder;
            const toIso = (d) => {
                try {
                    return d ? new Date(d).toISOString().slice(0, 10) : null;
                } catch (e) {
                    return null;
                }
            };
            const toFmt = (d) => {
                try {
                    return d ? new Date(d).toLocaleDateString() : '—';
                } catch (e) {
                    return '—';
                }
            };

            groupKeys.forEach((key) => {
                const arr = serverMap[key] || [];
                normalized[key] = arr.map((t) => ({
                    id: t.Id,
                    subject: t.Subject,
                    priority: t.Priority,
                    activityDate: toIso(t.ActivityDate),
                    formattedDue: toFmt(t.ActivityDate)
                }));
            });

            this.dataByGroup = normalized;
        } catch (error) {
            // Log and show toast
            // eslint-disable-next-line no-console
            console.error('loadTasks error', error);
            this.showToast('Error loading tasks', this.getErrorMessage(error), 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // Event from child: { detail: { taskId, groupName } }
    async handleDefer(event) {
        const taskId = event.detail?.taskId;
        if (!taskId) return;

        // Optimistic UI: move task to appropriate group after +1 day
        const snapshot = this.snapshotData();
        const { movedTask, newGroup } = this.optimisticallyDefer(taskId);
        this.showToast('Deferred', 'Task deferred by 1 day.', 'success');

        try {
            const ok = await deferTask({ taskId });
            if (!ok) {
                this.dataByGroup = snapshot; // revert
                this.showToast('Server error', 'Could not defer task. Changes reverted.', 'error');
                return;
            }
            // If server succeeded but our grouping logic differs (edge cases), refresh
            if (!movedTask) {
                await this.loadTasks();
            } else {
                // Ensure correct formatting after move
                // already handled in optimistic function
            }
        } catch (error) {
            this.dataByGroup = snapshot; // revert
            // eslint-disable-next-line no-console
            console.error('defer error', error);
            this.showToast('Error', this.getErrorMessage(error), 'error');
        }
    }

    // Event from child: { detail: { taskId, groupName } }
    async handleComplete(event) {
        const taskId = event.detail?.taskId;
        if (!taskId) return;

        // Optimistic UI: remove from current group
        const snapshot = this.snapshotData();
        const removed = this.optimisticallyComplete(taskId);
        this.showToast('Completed', 'Task marked as completed.', 'success');

        try {
            const ok = await closeTask({ taskId });
            if (!ok) {
                this.dataByGroup = snapshot; // revert
                this.showToast('Server error', 'Could not complete task. Changes reverted.', 'error');
                return;
            }
            if (!removed) {
                await this.loadTasks();
            }
        } catch (error) {
            this.dataByGroup = snapshot; // revert
            // eslint-disable-next-line no-console
            console.error('complete error', error);
            this.showToast('Error', this.getErrorMessage(error), 'error');
        }
    }

    // Helpers

    snapshotData() {
        // Deep clone dataByGroup minimally
        const copy = {};
        for (const key of this.groupsOrder) {
            copy[key] = (this.dataByGroup[key] || []).map((t) => ({ ...t }));
        }
        return copy;
    }

    getGroupForDate(dateIso) {
        // Determine grouping per requirements; relies on client timezone
        const today = new Date();
        const startOfDay = (d) => new Date(d.getFullYear(), d.getMonth(), d.getDate());
        const addDays = (d, days) => new Date(d.getFullYear(), d.getMonth(), d.getDate() + days);
        const start = startOfDay(today);
        const tomorrow = addDays(start, 1);

        const getStartOfWeek = (d) => {
            // Monday as first day of week: compute delta
            const day = d.getDay(); // 0=Sun..6=Sat
            const mondayDelta = (day === 0 ? -6 : 1 - day);
            const monday = new Date(d);
            monday.setDate(d.getDate() + mondayDelta);
            monday.setHours(0, 0, 0, 0);
            return monday;
        };

        const due = dateIso ? new Date(dateIso) : null;
        if (!due) return 'Later';

        const dueStart = startOfDay(due);
        const startThisWeek = getStartOfWeek(start);
        const endThisWeek = addDays(startThisWeek, 6);
        const startNextWeek = addDays(startThisWeek, 7);
        const endNextWeek = addDays(startNextWeek, 6);

        if (dueStart < start) return 'Overdue';
        if (dueStart.getTime() === start.getTime()) return 'Today';
        if (dueStart.getTime() === tomorrow.getTime()) return 'Tomorrow';
        if (dueStart > tomorrow && dueStart >= startThisWeek && dueStart <= endThisWeek) return 'This Week';
        if (dueStart >= startNextWeek && dueStart <= endNextWeek) return 'Next Week';
        return 'Later';
    }

    optimisticallyDefer(taskId) {
        for (const key of this.groupsOrder) {
            const arr = this.dataByGroup[key] || [];
            const idx = arr.findIndex((t) => t.id === taskId);
            if (idx !== -1) {
                const [task] = arr.splice(idx, 1);
                // Update date locally
                const newDate = task.activityDate ? new Date(task.activityDate) : new Date();
                newDate.setDate(newDate.getDate() + 1);
                task.activityDate = newDate.toISOString().slice(0, 10);
                task.formattedDue = newDate.toLocaleDateString();

                // Compute new target group by rules
                const target = this.getGroupForDate(task.activityDate);
                const updated = { ...this.dataByGroup, [key]: [...arr] };
                const targetList = updated[target] || [];
                updated[target] = [...targetList, task];
                this.dataByGroup = updated;

                return { movedTask: task, newGroup: target };
            }
        }
        return { movedTask: null, newGroup: null };
    }

    optimisticallyComplete(taskId) {
        for (const key of this.groupsOrder) {
            const arr = this.dataByGroup[key] || [];
            const idx = arr.findIndex((t) => t.id === taskId);
            if (idx !== -1) {
                arr.splice(idx, 1);
                this.dataByGroup = { ...this.dataByGroup, [key]: [...arr] };
                return true;
            }
        }
        return false;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    getErrorMessage(error) {
        if (!error) return 'Unknown error';
        if (Array.isArray(error.body)) {
            return error.body.map((e) => e.message).join(', ');
        }
        if (typeof error.body?.message === 'string') {
            return error.body.message;
        }
        if (typeof error.message === 'string') {
            return error.message;
        }
        return 'Unknown error';
    }
}
