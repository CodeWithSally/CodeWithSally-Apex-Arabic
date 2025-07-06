public class BackfillOldOpportunities implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext jobId){ //return all records matching your SOQL
        return Database.getQueryLocator(
            'SELECT Id, Business_Type__c FROM Opportunity WHERE Business_Type__c = NULL'
        ); //200 records 
    }

    //chunck 1 :50
    //chunck 2 :50
    //chunck 3 :50
    //chunck 4 :50
    public Void execute(Database.BatchableContext jobId, List<Opportunity> lstOpportunities){ //lstOpportunities not the 1000 records but the 200 for each execute
        //code i want to run to do my logic 
        try{
            for (Opportunity opp : lstOpportunities) {
                opp.Business_Type__c = 'Legacy';
            }
            update lstOpportunities;

            //Best to use Database.update unless you want to fail everything if one fails
            /*
                // Use List<Database.SaveResult> to handle partial DML
                List<Database.SaveResult> lstResult = Database.update(lstOpportunities, false);

                for (Integer i = 0; i < lstResult.size(); i++) {
                    if (!lstResult[i].isSuccess()) {
                        System.debug('❌ Failed to update Opportunity with Id: ' + lstOpportunities[i].Id);
                        for (Database.Error err : lstResult[i].getErrors()) {
                            System.debug('⚠️ Error: ' + err.getMessage());
                        }
                    }
                }
            */
        }Catch(exception ex){
            System.debug('🔥 Exception during batch execution: '+ex.getMessage());
        }
    }

    public Void finish(Database.BatchableContext jobId){
        System.debug('🎉 Done fixing Opportunities!');
    }
}