public class UpdateContactsQueue implements Queueable {
    public void execute(QueueableContext context) {
        List<Contact> contacts = [SELECT Id, Description FROM Contact WHERE CreatedDate = TODAY];
        for (Contact c : contacts) {
            c.Description = '✅ Updated by UpdateContactsQueue';
        }
        update contacts;

        // Log the parent job's ID
        System.debug('🔗 Parent Job ID: ' + context.getJobId());

        // Chain the next job!
        ID jobId = System.enqueueJob(new NotifyUserQueue());
        System.debug('Notify User Job Id: '+jobId);
    }
}

/*
      How to run in execute anonymous

      List<Contact> contactList = [SELECT Id, Region__c FROM Contact WHERE CreatedDate = TODAY];
        ID jobId = System.enqueueJob(new UpdateContactsQueue(contactList,'Global'));
        System.debug('Job ID: ' + jobId);
       
        AsyncApexJob job = [
                                SELECT Id, Status, JobType, NumberOfErrors, TotalJobItems, CompletedDate
                                FROM AsyncApexJob
                                WHERE Id = :jobId
                            ];
        System.debug('Job Status: ' + job.Status);
    */