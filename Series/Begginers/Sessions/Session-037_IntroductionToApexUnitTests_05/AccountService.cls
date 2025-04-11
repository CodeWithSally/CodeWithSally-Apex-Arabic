public class AccountService {
    
    //example used in unit testing unit
    public static void createRestrictedAccount(String accountName) {
        //Admin only are allowed to use this method
        if (UserInfo.getProfileId() != [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id) {
            throw new System.DmlException('Only System Administrators can create accounts.');
        }
        insert new Account(Name=accountName);
    }
}