import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOpenTasks from '@salesforce/apex/TaskManagerApexController.getOpenTasks';
import completeTask from '@salesforce/apex/TaskManagerApexController.completeTask';
import deferTask from '@salesforce/apex/TaskManagerApexController.deferTask';

export default class TaskManager extends LightningElement {
  // Loading spinner flag
  @track isLoading = false;

  // Buckets local state (real data from Apex)
  @track buckets = {
    overdue: [],
    today: [],
    tomorrow: [],
    thisWeek: [],
    nextWeek: [],
    later: []
  };

  // Computed titles with counts
  get overdueTitle() {
    return `Overdue (${this.buckets.overdue.length})`;
  }
  get todayTitle() {
    return `Today (${this.buckets.today.length})`;
  }
  get tomorrowTitle() {
    return `Tomorrow (${this.buckets.tomorrow.length})`;
  }
  get thisWeekTitle() {
    return `This Week (${this.buckets.thisWeek.length})`;
  }
  get nextWeekTitle() {
    return `Next Week (${this.buckets.nextWeek.length})`;
  }
  get laterTitle() {
    return `Later (${this.buckets.later.length})`;
  }

  // Lifecycle - fetch real data once
  connectedCallback() {
    this.fetchTasks();
  }

  // Fetch tasks from Apex
  async fetchTasks() {
    this.isLoading = true;
    try {
      const result = await getOpenTasks();
      this.buckets = {
        overdue: result.overdue,
        today: result.today,
        tomorrow: result.tomorrow,
        thisWeek: result.thisWeek,
        nextWeek: result.nextWeek,
        later: result.later
      };
    } catch (error) {
      this.showToast('Error', 'Failed to load tasks', 'error');
      console.error('Error fetching tasks:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // Handle task completion
  async handleComplete(event) {
    const taskId = event.currentTarget.dataset.id;
    this.isLoading = true;
    
    try {
      const result = await completeTask({ taskId });
      // Remove from its current bucket to simulate completion
      const { bucketKey, index } = this.findTaskById(taskId);
      
      if (bucketKey) {
        const cloneBucket = [...this.buckets[bucketKey]];
        cloneBucket.splice(index, 1);
        
        this.buckets = {
          ...this.buckets,
          [bucketKey]: cloneBucket
        };
        
        this.showToast('Success', 'Task completed successfully', 'success');
      }
    } catch (error) {
      this.showToast('Error', 'Failed to complete task', 'error');
      console.error('Error completing task:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // Handle task deferral
  async handleDefer(event) {
    const taskId = event.currentTarget.dataset.id;
    const option = event.detail.value;
    
    // Validate option
    const validOptions = ['Tomorrow', 'NextWeek', 'Plus2Weeks', 'CustomDays'];
    if (!validOptions.includes(option)) {
      this.showToast('Error', 'Invalid defer option', 'error');
      return;
    }
    
    this.isLoading = true;
    
    try {
      let result;
      if (option === 'CustomDays') {
        // Prompt for custom days
        const days = prompt('Enter number of days to defer (e.g. 5):');
        const daysNum = parseInt(days, 10);
        if (!Number.isFinite(daysNum) || daysNum < 1) {
          this.showToast('Error', 'Please enter a valid positive number.', 'error');
          this.isLoading = false;
          return;
        }
        result = await deferTask({ taskId, option, customDays: daysNum });
      } else {
        result = await deferTask({ taskId, option });
      }
      
      // Reload all tasks to ensure UI consistency after deferral
      // This avoids potential bucket mismatch issues
      await this.fetchTasks();
      
      this.showToast('Success', 'Task deferred successfully', 'info');
    } catch (error) {
      this.showToast('Error', 'Failed to defer task', 'error');
      console.error('Error deferring task:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // Find a task and its current bucket by id
  findTaskById(taskId) {
    const bucketKeys = Object.keys(this.buckets);
    for (const key of bucketKeys) {
      const idx = this.buckets[key].findIndex((t) => t.id === taskId);
      if (idx !== -1) {
        return { bucketKey: key, index: idx, task: this.buckets[key][idx] };
      }
    }
    return { bucketKey: null, index: -1, task: null };
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title,
      message,
      variant
    });
    this.dispatchEvent(event);
  }
}
