@isTest
public class GovernorLimitsDemoTest {
    
    @isTest
    static void testGovernorLimitsReset() {
        // Arrange: Insert some setup data 
        insert new Contact(FirstName = 'Sally', LastName = 'Adam'); //counter1:1 --> available : 149

        // Debug limits before starting the test logic
        System.debug('Before Test.startTest(): Consumed DML Statement: ' + Limits.getDMLStatements()); //1
        
        Test.startTest(); 
            //Start counter 2 started =0
            // Bad practice to have insert in for loop but i wanted to demonstrate how testStart and stop works 
            for (Integer i = 0; i < 150; i++) {
                insert new Contact(FirstName = 'John' + i, LastName = 'Doe'); //1,2,3,150
            }
            System.debug('During Test.startTest(): Consumed DML Statement: ' + Limits.getDMLStatements()); //150
        Test.stopTest(); //==> end counter 2
        
        insert new Contact(FirstName = 'Sally2', LastName = 'Adam2'); //counter1:2 
        
        // Debug after the test logic
        System.debug('After Test.stopTest(): Consumed DML Statement: ' + Limits.getDMLStatements()); 
    }
}