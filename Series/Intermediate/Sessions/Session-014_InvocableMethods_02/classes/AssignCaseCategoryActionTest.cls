@isTest
public class AssignCaseCategoryActionTest {

    @testSetup
    static void setupData() {
        // Prepare data - can be moved to test data factory
        List<Case> lstCases = new List<Case>{
            new Case(Subject = 'Billing issue with invoice'),
            new Case(Subject = 'Technical support needed'),
            new Case(Subject = 'Cannot login to account'),
            new Case(Subject = 'Forgot password'),
            new Case(Subject = 'Just a general question'),
            new Case(Subject = null) // Null subject to test 'Uncategorized'
        };
        insert lstCases;
    }

    @isTest
    static void testAssignBillingCategory() {
        // Prepare data
        Case billingCase = [SELECT Id FROM Case WHERE Subject LIKE '%Billing%' LIMIT 1];
        List<Id> lstIds = new List<Id>{billingCase.Id};

        // Act
        Test.startTest();
        List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstIds);
        Test.stopTest();

        // Assert
        Assert.areEqual(1, lstResults.size(), 'Result should be only one category.');
        Assert.areEqual('Billing', lstResults[0], 'Expected category is Billing.');
    }

    @isTest
    static void testAssignTechnicalCategory() {
        // Prepare data
        Case techCase = [SELECT Id FROM Case WHERE Subject LIKE '%Technical%' LIMIT 1];
        List<Id> lstIds = new List<Id>{techCase.Id};

        // Act
        List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstIds);

        // Assert
        Assert.areEqual(1, lstResults.size(), 'Result should be only one category.');
        Assert.areEqual('Technical', lstResults[0], 'Expected category is Technical.');
    }

    @isTest
    static void testAssignAuthenticationCategory_Login() {
        // Prepare data
        Case loginCase = [SELECT Id FROM Case WHERE Subject LIKE '%login%' LIMIT 1];
        List<Id> lstIds = new List<Id>{loginCase.Id};

        // Act
        List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstIds);

        // Assert
        Assert.areEqual('Authentication', lstResults[0], 'Expected category is Authentication.');
    }

    @isTest
    static void testAssignAuthenticationCategory_Password() {
        // Prepare data
        Case pwdCase = [SELECT Id FROM Case WHERE Subject LIKE '%password%' LIMIT 1];
        List<Id> lstIds = new List<Id>{pwdCase.Id};

        // Act
        List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstIds);

        // Assert
        Assert.areEqual('Authentication', lstResults[0], 'Expected category is Authentication.');
    }

    @isTest
    static void testAssignGeneralCategory() {
        // Prepare data
        Case genCase = [SELECT Id FROM Case WHERE Subject LIKE '%general%' LIMIT 1];
        List<Id> lstIds = new List<Id>{genCase.Id};

        // Act
        List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstIds);

        // Assert
        Assert.areEqual('General', lstResults[0], 'Expected category is General.');
    }

    @isTest
    static void testAssignUncategorized() {
        // Prepare data
        Case uncategorized = [SELECT Id FROM Case WHERE Subject = null LIMIT 1];
        List<Id> lstIds = new List<Id>{uncategorized.Id};

        // Act
        List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstIds);

        // Assert
        Assert.areEqual('Uncategorized', lstResults[0], 'Expected category is Uncategorized.');
    }

    @isTest
    static void testMultipleCasesWithKnownOrder() {
        // Prepare data
        Case case1 = new Case(Subject = 'Billing issue');
        Case case2 = new Case(Subject = 'Technical error');
        Case case3 = new Case(Subject = 'Forgot my password');
        Case case4 = new Case(Subject = 'Some random request');
        insert new List<Case>{ case1, case2, case3, case4 };

        List<Id> lstInputCaseIds = new List<Id>{ case1.Id, case2.Id, case3.Id, case4.Id };

        // Act
        Test.startTest();
        	List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstInputCaseIds);
        Test.stopTest();

        // Assert
        Assert.areEqual(4, lstResults.size(), 'Should return 4 categories.');
        Assert.areEqual('Billing', lstResults[0], 'Expected Billing for case1.');
        Assert.areEqual('Technical', lstResults[1], 'Expected Technical for case2.');
        Assert.areEqual('Authentication', lstResults[2], 'Expected Authentication for case3.');
        Assert.areEqual('General', lstResults[3], 'Expected General for case4.');
    }

    @isTest
    static void testEmptyInputList() {
        // Prepare data
        List<Id> lstCaseIds = new List<Id>();

        // Act
        List<String> lstResults = AssignCaseCategoryAction.assignCategory(lstCaseIds);

        // Assert
        Assert.areEqual(0, lstResults.size(), 'Empty input should return an empty list.');
    }
}