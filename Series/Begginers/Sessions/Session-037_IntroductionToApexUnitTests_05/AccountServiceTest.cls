@isTest
private class AccountServiceTest {
    
    @testSetup 
    static void prepareTestData() {
        User testStandardUser =TestDataFactory.createStandardUser();
        // Create System Administrator User
        User testAdminUser = TestDataFactory.createAdminUser();
        insert new List<User>{testStandardUser, testAdminUser}; // Insert both users at once
    }
    
    //positive: run the method with an adam and account will be created
    @isTest
    static void testAdminCanCreateAccount() {
        User adminUser = [SELECT Id,email,firstName,lastName FROM User WHERE Email = 'adminuser@example.com' Limit 1];
		Assert.areEqual('adminuser@example.com',adminUser.email,'Email should match testing admin user');
        
        System.runAs(adminUser) {
            AccountService.createRestrictedAccount('Admin Created Account');
            
            // Query to confirm the account was inserted
            Account insertedAcc = [SELECT Id, Name FROM Account WHERE Name = 'Admin Created Account' LIMIT 1];

            // Assertions
            Assert.isNotNull(insertedAcc, 'Account should be successfully created by System Administrator.');
            Assert.areEqual('Admin Created Account', insertedAcc.Name, 'Account name should match.');
        }
    }
    
	//❌ Negative: run the metod with a non admin user and we should get the exception
	@isTest
    static void testAccountCreationRestriction() {
        User standardUser = [SELECT Id,email,firstName,lastName FROM User WHERE Email = 'testuser@example.com' Limit 1];
        system.debug('Standard User: '+standardUser);
        
        System.runAs(standardUser) {
            Test.startTest();
            try{
                AccountService.createRestrictedAccount('Admin Created Account');
                //fail if we reach this line
                Assert.fail('Expected an error due to profile restriction.');
            } catch (DmlException e) {
                // Assert that an error was thrown
                Assert.areEqual('Only System Administrators can create accounts.',e.getMessage(),'Expected error: Only System Administrators can create accounts.');
            }    
            Test.stopTest();
        }
    } 
}