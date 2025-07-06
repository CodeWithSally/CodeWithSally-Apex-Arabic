@isTest
public class TestDataFactory {
    
    public static user createStandardUser(){
        // Fetch Standard User Profile
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Create Standard User
        User testStandardUser = new User(
            FirstName = 'TestCodeWithSally',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        return testStandardUser;
    }
    
    public static user createAdminUser(){
        // Fetch System Administrator Profile
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        // Create System Administrator User
        User testAdminUser = new User(
            FirstName = 'AdminCodeWithSally',
            LastName = 'User',
            Email = 'adminuser@example.com',
            Username = 'adminuser@example.com' + System.currentTimeMillis(),
            Alias = 'auser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = adminProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        return testAdminUser;
    }
    
    // Create a test Account
    public static Account createTestAccount() {
        Account acc = new Account(Name = 'Test Account'); //add required fields in the future!!
        insert acc;
        return acc;
    }

    public static Contact createTestContact(Id accountId) {
        return createTestContact(accountId,true);
    }
    
    // Create a test Contact
    public static Contact createTestContact(Id accountId, Boolean insertRecord) {
        Contact con = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john@example.com',
            AccountId = accountId
        );
        if (insertRecord) {
            insert con;
        }
        return con;
    }

    // Create multiple Contacts
    public static List<Contact> createMultipleContacts(Id accountId, Integer count) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                FirstName = 'John' + i,
                LastName = 'Doe' + i,
                Email = 'john' + i + '@example.com',
                AccountId = accountId
            ));
        }
        insert contacts;
        return contacts;
    }
}