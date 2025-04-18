public class AccountService {
    
    //example used in unit testing unit
    public static void createRestrictedAccount(String accountName) {
        //Admin only are allowed to use this method
        if (UserInfo.getProfileId() != [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id) {
            throw new System.DmlException('Only System Administrators can create accounts.');
        }
        insert new Account(Name=accountName);
    }
    
    //example used in exception handling example
    public static void createAccount(String name, String industry) {
        if (String.isEmpty(industry)) {
            throw new MissingRequiredFieldException('Industry is required.');
        }

        if(String.isEmpty(name)){
            throw new MissingRequiredFieldException('Name value is required');
        }
        
        Account acc = new Account(Name = name, Industry = industry);
        insert acc;
    }
}