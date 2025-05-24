// This class implements the Queueable interface to run background logic in Apex
public class ContactUpdaterQueue implements Queueable {

    // This is a private property to hold the list of contacts we want to update
    private List<Contact> contactsToUpdate;
    private String region;

    // Constructor that accepts the list of contacts and stores it in the class property
    public ContactUpdaterQueue(List<Contact> contacts,String regionValue) {
        this.contactsToUpdate = contacts;
        this.region = regionValue;
    }

    // This is the method that Salesforce will run in the background
    // The QueueableContext context parameter is required, even if we don't use it here
    public void execute(QueueableContext context) {
        // Loop through the contacts and set the Region__c field to "EMEA"
        // Region__c is custom picklist on contact object... You can create your own or just text field if you like
        for (Contact c : contactsToUpdate) {
            c.Region__c = this.region;
        }

        // Perform the update operation
        update contactsToUpdate;
    }

    /*
      How to run in execute anonymous

      List<Contact> contactList = [SELECT Id, Region__c FROM Contact WHERE CreatedDate = TODAY];
        ID jobId = System.enqueueJob(new ContactUpdaterQueue(contactList,'Global'));
        System.debug('Job ID: ' + jobId);
       
        AsyncApexJob job = [
                                SELECT Id, Status, JobType, NumberOfErrors, TotalJobItems, CompletedDate
                                FROM AsyncApexJob
                                WHERE Id = :jobId
                            ];
        System.debug('Job Status: ' + job.Status);
    */
}
