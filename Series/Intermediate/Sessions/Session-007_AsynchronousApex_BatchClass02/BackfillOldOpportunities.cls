public class BackfillOldOpportunities implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) { //return all records matching your SOQL
        return Database.getQueryLocator(
            'SELECT Id, Business_Type__c FROM Opportunity WHERE Business_Type__c = NULL'
        );
    } //1000 record

    //chunck 1 :200
    //chunck 2 :200
    //chunck 3 :200
    //chunck 4 :200
    //chunck 5 :200
    public void execute(Database.BatchableContext bc, List<Opportunity> lstOpportunities) {
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
        }catch(Exception ex){
            System.debug('🔥 Exception during batch execution: '+ex.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('🎉 Done fixing Opportunities!');
    }
}

/*

How to run from developer console

ID batchprocessid = Database.executeBatch(new BackfillOldOpportunities()); // scope Default: 200

AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                    FROM AsyncApexJob WHERE ID =: batchprocessid ];

*/

/*code to creat sample opportunities
List<Opportunity> opps = new List<Opportunity>();
for (Integer i = 0; i < 450; i++) {
    opps.add(new Opportunity(Name='Demo ' + i, StageName='Prospecting', CloseDate=Date.today().addDays(30)));
}
insert opps;
*/