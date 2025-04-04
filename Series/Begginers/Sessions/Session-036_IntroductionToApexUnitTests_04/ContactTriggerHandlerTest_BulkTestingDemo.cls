@isTest
public class ContactTriggerHandlerTest {
    
    // Setup reusable test data
    @TestSetup
    static void setupTestData() {
        // Create an Account for test Contacts
        Account acc= TestDataFactory.createTestAccount('Test Account2');
        TestDataFactory.createTestContact(acc.Id,'Sally','ElGhoul','john@example.com');
    }

    @isTest
    static void testHandleBeforeInsert(){
        //prepare data
        Contact contactObj = new Contact(LastName = 'Doe'); // Missing First Name
        
        try{
            //execute 
        	insert contactObj;
            Assert.fail('Expected an error for missing First Name');
        }catch(Exception ex){
         	//assert 
         	Assert.isTrue(ex.getMessage().contains('First Name is required.'), 'Expected validation error for missing First Name');
        }
    }
    
   @isTest
   static void testHandleBeforeUpdate() {
       //prepare
       Contact contactObj = [select email FROM contact limit 1];
       Assert.AreEqual('john@example.com',contactObj.Email);
       
       contactObj.Email = null;
       
       //execute
       try {
           update contactObj;
           Assert.fail('Expected an error when removing email');
       } catch (Exception e) {
           Assert.isTrue(e.getMessage().contains('Email cannot be removed once set.'), 'Expected validation error for removing Email');
       }
   }
    
    @isTest
   	static void testHandleAfterInsertUpdate() {
       //assert
       Account updatedAcc = [SELECT Last_Contacted_Date__c FROM Account Limit 1];
       Assert.isNotNull(updatedAcc.Last_Contacted_Date__c, 'Last Contacted Date should be updated.');
   }
    
    @isTest 
    static void testSingleInsert() { 
        Account acc = new Account(Name = 'Test Account'); 
        insert acc; 
        Contact con = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id); 
        insert con; 
        
        Account updatedAcc = [SELECT Last_Contacted_Date__c FROM Account WHERE Id = :acc.Id]; 
        Assert.isNotNull(updatedAcc.Last_Contacted_Date__c, 'Last Contacted Date should be updated.'); 
    }
    
    @Istest 
    static void testBulkInsert(){
        Account acc=[Select id From Account limit 1];
        TestDataFactory.createMultipleContacts(acc.id,150);
    }
}