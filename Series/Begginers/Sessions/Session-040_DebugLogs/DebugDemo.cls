public class DebugDemo {

    public static void runDemo() {
        System.debug('🔍 Starting debug log demo.');

        // SOQL Query
        List<Account> accts = [SELECT Id, Name FROM Account LIMIT 1];
        System.debug('📋 Retrieved ' + accts.size() + ' account(s).');

        // DML Operation
        Account newAcc = new Account(Name = 'DebugLogTest');
        insert newAcc;
        System.debug('✅ Inserted new Account: ' + newAcc.Id);

        // Trigger LIMIT_USAGE entry (tiny loop)
        for (Integer i = 0; i < 5; i++) {
            System.debug('🔁 Loop iteration ' + i);
        }

        // Handled Exception
        try {
            Integer result = 10 / 0; // Division by zero
        } catch (Exception e) {
            System.debug('❗ Caught exception: ' + e.getMessage());
        }

        System.debug('🏁 Debug log demo complete.');
    }
}