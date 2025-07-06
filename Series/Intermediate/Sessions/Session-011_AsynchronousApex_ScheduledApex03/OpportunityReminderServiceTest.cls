@isTest
public with sharing class OpportunityReminderServiceTest {
    @isTest
    static void testRunReminderLogicCreatesTasks() {
        //1. Prepare Data
        User userObj = TestDataFactory.createStandardUser();
        insert userObj;

        // Create test opportunities
        List<Opportunity> testOpps = new List<Opportunity>();
        for (Integer i = 0; i < 3; i++) {
            testOpps.add(new Opportunity(
                Name = 'Test Opp ' + i,
                CloseDate = Date.today().addDays(-2),
                StageName = 'Prospecting',
                Amount = 1000,
                OwnerId = userObj.Id
            ));
        }
        insert testOpps;

        //2. Execute code we want to test
        Test.startTest(); 
            //String jobId = System.schedule('Test Reminder Job', '0 0 2 * * ?', new OpportunityReminderScheduler());
            OpportunityReminderService.runReminderLogic();
        Test.stopTest();

        //3. Assert 
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE Subject = 'Follow up on overdue Opportunity'];
        //System.assertEquals(3, tasks.size(), 'Expected 3 tasks to be created.');
        Assert.areEqual(3, tasks.size(), 'Expected 3 tasks to be created.');
    }
}