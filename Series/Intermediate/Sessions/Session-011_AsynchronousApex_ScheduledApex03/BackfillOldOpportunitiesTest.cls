@isTest
private class BackfillOldOpportunitiesTest {

    @isTest static void testBatchUpdatesMissingField() {
        // Step 1: Create 3 old opportunities missing Business_Type__c
        List<Opportunity> opps = new List<Opportunity>();

        //Maximum 200 records otherwise you would get 
        /* System.UnexpectedException: No more than one executeBatch can be called 
           from within a test method.  Please make sure the iterable returned from 
           your start method matches the batch size, resulting in one executeBatch invocation.
        */
        for (Integer i = 0; i < 200; i++) {
            opps.add(new Opportunity(
                Name = 'Old Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert opps;

        // Step 2: Run batch
        Test.startTest();
        Database.executeBatch(new BackfillOldOpportunities()); 
        Test.stopTest();

        // Step 3: Assert that the missing field was filled
        List<Opportunity> updatedOpps = [
            SELECT Id, Business_Type__c FROM Opportunity
            WHERE Id IN :opps
        ];

        for (Opportunity o : updatedOpps) {
            //System.assertEquals('Legacy', o.Business_Type__c);
            Assert.areEqual('Legacy', o.Business_Type__c,'Businedd Type value should be the default Legacy');
        }
    }
}
