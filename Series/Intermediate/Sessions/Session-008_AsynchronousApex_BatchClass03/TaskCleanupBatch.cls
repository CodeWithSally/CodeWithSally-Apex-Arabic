public class TaskCleanupBatch implements Database.Batchable<SObject> {

    private Set<Id> opportunityIds;

    public TaskCleanupBatch(Set<Id> oppIds) {
        this.opportunityIds = oppIds;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(
            'SELECT Id FROM Task WHERE WhatId IN :opportunityIds AND Status = \'Completed\''
        );
    }

    public void execute(Database.BatchableContext context, List<Task> tasks) {
        delete tasks;
    }

    public void finish(Database.BatchableContext context) {
        System.debug('🧹 Done cleaning related tasks!');
        //    System.enqueueJob(new NotifyAdminQueue());

    }
}
