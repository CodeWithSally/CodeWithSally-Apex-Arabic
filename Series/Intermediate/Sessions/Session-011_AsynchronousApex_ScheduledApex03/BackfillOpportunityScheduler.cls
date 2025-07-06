// Schedules the BackfillOldOpportunities batch job to run on a recurring schedule
public class BackfillOpportunityScheduler implements Schedulable {

    // This method runs automatically when the job is triggered
    public void execute(SchedulableContext sc) {

        // Start the batch job with a scope size of 200 records per chunk
        Database.executeBatch(new BackfillOldOpportunities(), 200);
    }
}

/*
//schedule it through Apex 
// Schedule the job to run daily at 3 AM (server time in GMT)
String cronExpr = '0 0 3 * * ?';
System.schedule('Nightly Opportunity Backfill', cronExpr, new BackfillOpportunityScheduler());
*/