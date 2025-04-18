public class ErrorHandlingScenarios {

    public static Double divideNumber(Integer number1,Integer number2) {
        return number1/number2;
    }

    public static Contact missingDataError(String emailValue) {
        // Querying a record that doesn't exist - List has no rows for assignment
        return [SELECT Id, Name FROM Contact WHERE Email = :emailValue LIMIT 1];
    }

    public static Account dmlError(String nameValue) {
        // Trying to insert an invalid record (missing required field)
        Account accObj= new Account(Name=nameValue); // can fail if namevalue is null
        insert accObj; 
        return accObj;
    }

    public static void governorLimitError(Integer numberAccounts) {
        // Exceeding SOQL limits by running a query inside a loop if numberAccounts is not small
        //BAD Practice just for demonstration
        for (Integer i = 0; i < numberAccounts; i++) {
            Account acc = [SELECT Id FROM Account LIMIT 1];
        }
    }
}