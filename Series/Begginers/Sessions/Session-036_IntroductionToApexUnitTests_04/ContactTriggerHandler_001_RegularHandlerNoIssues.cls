public class ContactTriggerHandler {
    
    //Valildate that first Name is filled otherwise throw an error
    public static void onBeforeInsert(List<Contact> lstNewContacts) {
        for (Contact con : lstNewContacts) {
            if (String.isEmpty(con.FirstName)) {
                con.addError('First Name is required.');
            }
        }
    }
    
    //update the last contact date on the account that their contacts got inserted to be today
    public static void onAfterInsert(List<Contact> lstNewContacts) {
        UpdateAccountLastContactDate(lstNewContacts);
    }

    //stop users from clearing the email once the email is set 
    public static void onBeforeUpdate(List<Contact> lstOldContacts,Map<Id,Contact> mapOldContacts,List<Contact> lstNewContacts,Map<Id,Contact> mapNewContacts) {
        for (Contact con : lstNewContacts) {
            Contact oldCon = mapOldContacts.get(con.Id);
            if (oldCon.Email != null && con.Email == null) {
                con.addError('Email cannot be removed once set.');
            }
        }
    }
    
    //update the last contact date on the account that their contacts got updated to be today
    public static void onAfterUpdate(List<Contact> lstOldContacts,Map<Id,Contact> mapOldContacts,List<Contact> lstNewContacts,Map<Id,Contact> mapNewContacts){
        UpdateAccountLastContactDate(lstNewContacts);
    }

    ////////////////////////////Start Private Methods/////////////////////////////
    
    private static void UpdateAccountLastContactDate(List<Contact> lstNewContacts){
        Set<Id> accountIds = new Set<Id>();

        //get the account ids to be updated
        for (Contact con : lstNewContacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }

        if (!accountIds.isEmpty()) {
            //get account details
            Map<Id, Account> mapAccountsToUpdate = new Map<Id, Account>(
                [SELECT Id, Last_Contacted_Date__c FROM Account WHERE Id IN :accountIds]
            );

            //update the account last contact date 
            for (Contact con : lstNewContacts) {
                if (mapAccountsToUpdate.containsKey(con.AccountId)) {
                    mapAccountsToUpdate.get(con.AccountId).Last_Contacted_Date__c = System.today();
                }
            }

            //update accounts
            update mapAccountsToUpdate.values();
        }
    }
}