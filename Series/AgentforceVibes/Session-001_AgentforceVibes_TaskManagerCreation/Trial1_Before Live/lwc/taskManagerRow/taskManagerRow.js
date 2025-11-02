import { LightningElement, api } from 'lwc';

export default class TaskManagerRow extends LightningElement {
    @api task; // Task object from Apex controller

    handleDefer() {
        this.dispatchEvent(new CustomEvent('defer', { detail: { id: this.task?.Id }, bubbles: true, composed: true }));
    }

    handleComplete() {
        this.dispatchEvent(new CustomEvent('complete', { detail: { id: this.task?.Id }, bubbles: true, composed: true }));
    }
}
