public class AccountTriggerHandler {

    //6 static methods (up to 7 methods)
    
    //1. Handling before insert  (Trigger.New ==> lstNewAccounts)
    public static void handleBeforeInsert(List<Account> lstNewAccounts){
        setDefaultAnnualRevenueValues(lstNewAccounts);
        setDefaultIndustryValue(lstNewAccounts);
    }
    
    //2. Handling before update (Trigger.New ==> lstNewAccounts,Trigger.Old ==> lstOldAccounts,Trigger.NewMap ==> mapNewAccounts,Trigger.OldMap ==> mapOldAccounts)
    public static void handleBeforeUpdate(List<Account> lstNewAccounts,List<Account> lstOldAccounts,Map<Id, Account> mapNewAccounts,Map<Id, Account> mapOldAccounts){
        handleAnnualRevenueValidation(lstNewAccounts,mapOldAccounts);
        
    }
    
    ///////////////Private methods///////////////
    private static void setDefaultAnnualRevenueValues(List<Account> lstAccounts){
        
    }
    
    private static void setDefaultIndustryValue(List<Account> lstAccounts){
        for(Account accountObj : lstAccounts){ //all record that are newly inserted
            // Set default Industry if it's blank
            if (String.isBlank(accountObj.Industry)) {
                accountObj.Industry = 'Technology';
            }
        }
    }
    
    private static void handleAnnualRevenueValidation(List<Account> lstNewAccounts,Map<Id, Account> mapOldAccounts){
        for (Account acc : lstNewAccounts) { //all records that we want to update (will contain new values)
            Account oldAcc = mapOldAccounts.get(acc.Id); //has the same account records we want to update (but has old Values)
            // Prevent reducing AnnualRevenue below $1,000,000
            if (acc.AnnualRevenue != oldAcc.AnnualRevenue && acc.AnnualRevenue < 1000000 && oldAcc.AnnualRevenue>=1000000) {
                acc.addError('Annual Revenue cannot be reduced below $1,000,000.');
            }
        }
    }
}