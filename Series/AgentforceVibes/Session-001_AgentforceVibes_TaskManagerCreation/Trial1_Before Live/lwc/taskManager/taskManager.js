import { LightningElement, track } from 'lwc';
import getTasks from '@salesforce/apex/TaskManagerApexController.getTasks';
import closeTask from '@salesforce/apex/TaskManagerApexController.closeTask';
import deferTask from '@salesforce/apex/TaskManagerApexController.deferTask';

export default class TaskManager extends LightningElement {
    // Order of groups to render
    groupOrder = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Next Week', 'Later'];

    // Data to hold the actual tasks from Apex
    @track groupedTasks = {
        Overdue: [],
        Today: [],
        Tomorrow: [],
        'This Week': [],
        'Next Week': [],
        Later: []
    };

    // Map priorities to SLDS utility classes (using badge color-classes)
    priorityClassMap = {
        High: 'slds-theme_error',
        Normal: 'slds-theme_default',
        Low: 'slds-theme_success'
    };

    connectedCallback() {
        // Fetch tasks when component is loaded
        this.fetchTasks();
    }

    fetchTasks() {
        getTasks()
            .then(data => {
                console.log('data ', data);
                this.groupedTasks = data;
            })
            .catch(error => {
                console.error('Error fetching tasks:', error);
            });
    }

    // Event handlers for child components
    handleDefer(event) {
        const taskId = event.detail.id;
        deferTask({ taskId })
            .then(result => {
                if (result) {
                    // Refresh the data to reflect the change
                    this.fetchTasks();
                }
            })
            .catch(error => {
                console.error('Error deferring task:', error);
            });
    }

    handleComplete(event) {
        const taskId = event.detail.id;
        closeTask({ taskId })
            .then(result => {
                if (result) {
                    // Remove the task from the UI immediately
                    this.removeTaskFromUI(taskId);
                }
            })
            .catch(error => {
                console.error('Error completing task:', error);
            });
    }

    // Helper to remove a task from the UI immediately
    removeTaskFromUI(taskId) {
        const newData = { ...this.groupedTasks };
        for (const key of Object.keys(newData)) {
            const before = newData[key].length;
            newData[key] = newData[key].filter((t) => t.id !== taskId);
            const after = newData[key].length;
            if (after !== before) {
                this.groupedTasks = newData;
                return true;
            }
        }
        return false;
    }
}
