import { LightningElement, api } from 'lwc';

// Child section component to avoid bracket [] access in parent template.
// Receives the full items map and the current group name, then derives the list.

export default class TaskManagerSection extends LightningElement {
    @api groupName; // String
    @api items; // Object map: { 'Overdue': [...], 'Today': [...], ... }

    // Lowercase helper for empty message
    get groupNameLower() {
        return (this.groupName || '').toLowerCase();
    }

    // Safely resolve items for this group without bracket syntax in template
    get itemsForGroup() {
        if (!this.items || !this.groupName) return [];
        return Array.isArray(this.items[this.groupName]) ? this.items[this.groupName] : [];
    }

    get isEmpty() {
        return this.itemsForGroup.length === 0;
    }

    handleDeferClick(event) {
        const taskId = event.currentTarget?.dataset?.id;
        // Re-emit with a standard CustomEvent name 'defer'
        this.dispatchEvent(new CustomEvent('defer', { detail: { taskId, groupName: this.groupName } }));
    }

    handleCompleteClick(event) {
        const taskId = event.currentTarget?.dataset?.id;
        // Re-emit with a standard CustomEvent name 'complete'
        this.dispatchEvent(new CustomEvent('complete', { detail: { taskId, groupName: this.groupName } }));
    }
}
