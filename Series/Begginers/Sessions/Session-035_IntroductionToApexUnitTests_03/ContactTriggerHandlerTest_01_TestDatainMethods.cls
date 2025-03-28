@isTest
public class ContactTriggerHandlerTest {

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
       Contact contactObj = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john@example.com');
       insert contactObj;
		
       contactObj.Email = null;
       try {
           update contactObj;
           Assert.fail('Expected an error when removing email');
       } catch (Exception e) {
           Assert.isTrue(e.getMessage().contains('Email cannot be removed once set.'), 'Expected validation error for removing Email');
       }
   }
    
    @isTest
   	static void testHandleAfterInsertUpdate() {
       //prepare data
       Account acc = new Account(Name = 'Test Account');
       insert acc;

       Contact con = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id);
       //execute
       insert con;
		
       //assert
       Account updatedAcc = [SELECT Last_Contacted_Date__c FROM Account WHERE Id = :acc.Id];
       Assert.isNotNull(updatedAcc.Last_Contacted_Date__c, 'Last Contacted Date should be updated.');
   }
}