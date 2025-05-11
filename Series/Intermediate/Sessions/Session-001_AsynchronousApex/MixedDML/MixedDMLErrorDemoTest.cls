
@isTest
private class MixedDMLErrorDemoTest {

    @isTest
    static void testFutureFixForMixedDML() {
        Test.startTest();
            MixedDMLErrorDemo.doMixedDML(); // Method that uses @future
        Test.stopTest();

        // Assert something visible like a setup record update
        User u = [SELECT Alias FROM User WHERE username = 'ss@codeWithSallyTest.com'];
        Assert.areEqual('SCode', u.Alias, 'User alias should have been updated.');

        Account accountObj = [SELECT Id FROM Account WHERE name='Test Account Future'];
        Assert.isNotNull(accountObj);
    }
}