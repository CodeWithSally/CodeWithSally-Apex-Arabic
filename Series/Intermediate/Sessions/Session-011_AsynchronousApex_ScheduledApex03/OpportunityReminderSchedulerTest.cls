@isTest
public with sharing class OpportunityReminderSchedulerTest {
    @isTest
    static void testServiceCreatesTasks() {
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

        Test.startTest();
        String jobId = System.schedule('Test Reminder Job', '0 0 2 * * ?', new OpportunityReminderScheduler());
        Test.stopTest();

        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE Subject = 'Follow up on overdue Opportunity'];
        //System.assertEquals(3, tasks.size(), 'Expected 3 tasks to be created.');
        Assert.areEqual(3, tasks.size(), 'Expected 3 tasks to be created.');    }
}

/*
@isTest
public with sharing class OpportunityReminderSchedulerTest {
    @isTest
    static void testSchedulerDoesNotFail() {
        //Prep Data - Not needed 
        
        //Execute code you want to test 
        Test.startTest();
        String jobId = System.schedule(
            'Test Scheduler Only', 
            '0 0 2 * * ?', 
            new OpportunityReminderScheduler()
        );

        Test.stopTest();

        //Asserts
        System.assertNotEquals(null, jobId, 'Scheduler should return a job ID');

        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, State,
                                NextFireTime
                                FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        Assert.areEqual('0 0 2 * * ?', ct.CronExpression,'Cron expression should be equal.');

        // 2️⃣  Job still active (WAITING or ACQUIRED after first run)
        assert.isTrue(           
            ct.State == 'WAITING' || ct.State == 'ACQUIRED',
            'Scheduler should still be active after first fire-time.'
        );

        Assert.areNotEqual(
            'COMPLETE',
            ct.State,
            'Scheduler should not be COMPLETE unless it has no more runs.'
        );
    }
}
*/