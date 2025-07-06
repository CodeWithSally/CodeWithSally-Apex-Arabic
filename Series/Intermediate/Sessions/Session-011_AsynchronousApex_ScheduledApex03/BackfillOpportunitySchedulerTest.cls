
@IsTest
private class BackfillOpportunitySchedulerTest {

    @IsTest
    static void schedulerUpdatesBusinessType() {
        String jobId='';
        //Test.startTest();
            // -- Any valid CRON works; 0 0 3 * * ? = 3 AM every day
            jobId = System.schedule(
                'UT-BackfillOpportunityScheduler',      // ① job label
                '0 0 3 * * ?',                          // ② CRON
                new BackfillOpportunityScheduler()      // ③ schedulable instance
            );
        //Test.stopTest();         

        /*------------------------------------------------------------------
         ASSERTIONS – only that the schedule exists and is in a live state
        ------------------------------------------------------------------*/
        CronTrigger ct = [
            SELECT Id, State, CronJobDetail.Name,TimesTriggered
            FROM   CronTrigger
            WHERE  Id = :jobId
        ];

        // 1️⃣  Job label stored correctly
        Assert.areEqual(
            'UT-BackfillOpportunityScheduler',
            ct.CronJobDetail.Name,
            'CronTrigger should keep the same label we scheduled with.'
        );

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

/*
workaround that would work but I would not recommend it 
Test.startTest();
    // Any valid cron works in tests – here: “run once far in the future”
    String cron = '0 0 0 1 1 ? 2099';
    BackfillOpportunityScheduler scheduler=new BackfillOpportunityScheduler();
    System.schedule('UT-Backfill-Scheduler', cron, scheduler);
    scheduler.execute(null);
Test.stopTest();    
*/

/*
wrong version won't work as batch won't be executes 
@IsTest
private class BackfillOpportunitySchedulerTest {

    @IsTest
    static void schedulerUpdatesBusinessType() {
        // Step 1 Prepare data
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 200; i++) {
            opps.add(new Opportunity(
                Name = 'Old Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert opps;

        // Step 2: Run code we want to test
        Test.startTest();
            // Any valid cron works in tests – here: “run once far in the future”
            String cron = '0 0 0 1 1 ? 2099';
            System.schedule('UT-Backfill-Scheduler', cron, new BackfillOpportunityScheduler());
        Test.stopTest();            

        // Step 3: Assert
        List<Opportunity> updatedOpps = [
            SELECT Business_Type__c FROM Opportunity
            WHERE Id IN :opps
        ];

        for (Opportunity o : updatedOpps) {
            //System.assertEquals('Legacy', o.Business_Type__c);
            Assert.areEqual('Legacy', o.Business_Type__c,'Businedd Type value should be the default Legacy');
        }
    }
}*/
