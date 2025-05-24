public class MyQueueableJob implements Queueable {
    public void execute(QueueableContext context) {
        System.debug('✅ Queueable Job is running in the background!');
    }

    /*
        How to run it in execute anonymous

        ID jobId = System.enqueueJob(new MyQueueableJob());
        System.debug('Job ID: ' + jobId);

        AsyncApexJob job = [
                                SELECT Id, Status, JobType, NumberOfErrors, TotalJobItems, CompletedDate
                                FROM AsyncApexJob
                                WHERE Id = :jobId
                            ];

        System.debug('Job Status: ' + job.Status);
    */
}