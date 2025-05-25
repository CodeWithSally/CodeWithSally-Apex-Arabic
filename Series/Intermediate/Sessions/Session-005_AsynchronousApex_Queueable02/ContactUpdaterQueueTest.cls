@isTest
private class ContactUpdaterQueueTest {

    @isTest
    static void testQueueableJob() {
        // Setup test data
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i <= 3; i++) {
            contacts.add(new Contact(FirstName = 'Test', LastName = 'User' + i));
        }
        insert contacts;

        Test.startTest();
        System.enqueueJob(new ContactUpdaterQueue(contacts, 'EMEA'));
        Test.stopTest();

        // Assert contacts were updated
        List<Contact> updated = [SELECT Region__c FROM Contact WHERE Id IN :contacts];
        for (Contact c : updated) {
            Assert.areEqual('EMEA', c.Region__c, 'Region should be updated to EMEA');
        }
    }
}
