public class OpportunityCleanupBatch implements Database.Batchable<SObject>, Database.Stateful {

    public Set<Id> processedOpportunityIds = new Set<Id>();

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM Opportunity WHERE IsClosed = TRUE');
    }

    public void execute(Database.BatchableContext context, List<Opportunity> scope) {
        for (Opportunity opp : scope) {
            opp.Description = null;
        }

        // Perform partial upsert with error handling
        List<Database.SaveResult> results = Database.update(scope, false);

        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                processedOpportunityIds.add(scope[i].Id); // Only collect successful records
            } else {
                System.debug('⚠️ Failed to update: ' + scope[i].Id + ' - ' + results[i].getErrors()[0].getMessage());
            }
        }
    }


    public void finish(Database.BatchableContext context) {
        System.debug('✅ Finished cleaning Opportunities. Chaining Task Cleanup.');

        if (!processedOpportunityIds.isEmpty()) {
            Database.executeBatch(new TaskCleanupBatch(processedOpportunityIds));
        }
    }
}

//delete [select id,name from Opportunity];

/*List<Opportunity> opps = new List<Opportunity>();
for (Integer i = 0; i < 20; i++) {
    opps.add(new Opportunity(
        Name = 'Old Deal ' + i,
        StageName = 'Closed Won',
        CloseDate = Date.today().addDays(-60),
        Description = 'Needs cleanup'
    ));
}
insert opps;

// Create Tasks for some of them
List<Task> tasks = new List<Task>();
for (Opportunity o : opps) {
    tasks.add(new Task(
        WhatId = o.Id,
        Subject = 'Follow-up',
        Status = 'Completed',
        Priority = 'Normal'
    ));
}
insert tasks;
*/  

//testing in execute annonymous 
//Database.executeBatch(new OpportunityCleanupBatch());
