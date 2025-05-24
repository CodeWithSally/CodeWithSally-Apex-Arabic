public class ContactRegionJob implements Queueable {

    private ContactRegionWrapper data;

    public ContactRegionJob(ContactRegionWrapper data) {
        this.data = data;
    }

    public void execute(QueueableContext context) {
        for (Contact c : data.contacts) {
            c.Region__c = data.regionName;
            c.Description = 'Assigned by: ' + data.assignedBy;
        }
        update data.contacts;
    }

    /*

       How to run the job in Execute anonymous 
    
       List<Contact> contacts = [SELECT Id, Region__c, Description FROM Contact WHERE CreatedDate = TODAY];
        ContactRegionWrapper wrapper = new ContactRegionWrapper(contacts, 'APAC', UserInfo.getUserId());
        ID jobId = System.enqueueJob(new ContactRegionJob(wrapper));
        System.debug('Job ID: ' + jobId);
        
        AsyncApexJob job = [
                                SELECT Id, Status, JobType, NumberOfErrors, TotalJobItems, CompletedDate
                                FROM AsyncApexJob
                                WH  ERE Id = :jobId
                            ];
        System.debug('Job Status: ' + job.Status);

    */
}
