public class StatefulOpportunityBatch implements Database.Batchable<SObject>, Database.Stateful {

    private Integer updateCount = 0;
    private decimal totalOppValue =0;

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Business_Type__c ,Amount
            FROM Opportunity 
            WHERE Business_Type__c = 'Legacy'
        ]);
    }

    public void execute(Database.BatchableContext context, List<Opportunity> scope) {
        for (Opportunity o : scope) {
            o.Business_Type__c = 'New Business'; //New Business	

            updateCount++; 
            if(o.Amount!=null){
                totalOppValue=totalOppValue+o.Amount;
            }
        }
        update scope;
    }

    public void finish(Database.BatchableContext context) {
        System.debug('🔥 Total Opportunities Updated: ' + updateCount); //200
        System.debug('🔥 Total Opportunities Amount: ' + totalOppValue); //2000
    }
}

/*
How to run it in Developer Console

ID batchprocessid = Database.executeBatch(new StatefulOpportunityBatch());

AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                    FROM AsyncApexJob WHERE ID =: batchprocessid ];

System.debug('ID: '+batchprocessid);
system.debug('Status: '+aaj.Status);
system.debug('TotalJobItems: '+aaj.TotalJobItems);
*/