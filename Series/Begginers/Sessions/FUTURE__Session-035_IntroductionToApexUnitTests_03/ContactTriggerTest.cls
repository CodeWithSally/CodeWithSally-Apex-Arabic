@isTest
public class ContactTriggerTest {

   @isTest
   static void testHandleBeforeInsert() {
       Contact con = new Contact(LastName = 'Doe'); // Missing First Name
       Test.startTest();
       try {
           insert con;
           Assert.fail('Expected an error for missing First Name');
       } catch (Exception e) {
           Assert.isTrue(e.getMessage().contains('First Name is required.'), 'Expected validation error for missing First Name');
       }
       Test.stopTest();
   }

   @isTest
   static void testHandleBeforeUpdate() {
       Contact con = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john@example.com');
       insert con;

       con.Email = null;
       Test.startTest();
       try {
           update con;
           Assert.fail('Expected an error when removing email');
       } catch (Exception e) {
           Assert.isTrue(e.getMessage().contains('Email cannot be removed once set.'), 'Expected validation error for removing Email');
       }
       Test.stopTest();
   }

   @isTest
   static void testHandleAfterInsertUpdate() {
       Account acc = new Account(Name = 'Test Account');
       insert acc;

       Contact con = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id);
       insert con;

       Account updatedAcc = [SELECT Last_Contacted_Date__c FROM Account WHERE Id = :acc.Id];
       Assert.isNotNull(updatedAcc.Last_Contacted_Date__c, 'Last Contacted Date should be updated.');
   }
}