//1. When a new Account is created, set the Industry field to 'Technology' if it’s left blank. ==> before insert
//2. Accounts cannot have their AnnualRevenue reduced below $1,000,000. If a user attempts to do so, the system should display an error and prevent the update. ==> before update  
//3. After an Account is created, create a Welcome Task automatically for the Account Owner. ==> after insert
//4. Whenever an Account’s AnnualRevenue is updated, if the new value is greater than $10,000,000, notify the Account Owner by creating a task to review the Account. ==> after update
//5. "Users cannot delete an Account if it has associated Opportunities." ==> Before Delete (HW)
//6. Automatically create a Task for the Account Owner to review the restored Account.==> after undelete (HW)
trigger AccountTrigger on Account (before insert,before update,after insert,after update,before delete,after undelete) { //insert, update, delete , undelete
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){ //Requirement 1
            for(Account accountObj : Trigger.new){ //all record that are newly inserted
                // Set default Industry if it's blank
                if (String.isBlank(accountObj.Industry)) {
                    accountObj.Industry = 'Technology';
                }
            }
        }else if(Trigger.isUpdate){ //requirement 2
            for (Account acc : Trigger.new) { //all records that we want to update (will contain new values)
               Account oldAcc = Trigger.oldMap.get(acc.Id); //has the same account records we want to update (but has old Values)
			   // Prevent reducing AnnualRevenue below $1,000,000
		       if (acc.AnnualRevenue != oldAcc.AnnualRevenue && acc.AnnualRevenue < 1000000 && oldAcc.AnnualRevenue>=1000000) {
                   acc.addError('Annual Revenue cannot be reduced below $1,000,000.');
               }
            }
        }else if (Trigger.isDelete) { //requirement 5

            // Query the number of Opportunities per Account in ONE query 
            // Solution 1
            /*Map<Id, Integer> mapAccountOppCount = new Map<Id, Integer>();
            for (AggregateResult result : [SELECT AccountId, COUNT(Id) oppCount FROM Opportunity WHERE AccountId IN :Trigger.oldMap.keyset() GROUP BY AccountId]) {
                mapAccountOppCount.put((Id)result.get('AccountId'), (Integer)result.get('oppCount'));
            }

            // Prevent deletion if an Account has related Opportunities
            for (Account acc : Trigger.old) {
                if (mapAccountOppCount.containsKey(acc.Id) && mapAccountOppCount.get(acc.Id) > 0) {
                    acc.addError('You cannot delete this Account because it has associated Opportunities.');
                }
            }*/
            
            //solution 2
            /*Set<Id> setAccountsWithOpps = new Set<Id>();
            for (Opportunity opp : [SELECT AccountId FROM Opportunity WHERE AccountId IN :Trigger.oldMap.keyset()]) {
                setAccountsWithOpps.add(opp.AccountId);
            }

            // Prevent deletion if Opportunities exist
            for (Account acc : Trigger.old) {
                if (setAccountsWithOpps.contains(acc.Id)) {
                    acc.addError('You cannot delete this Account because it has associated Opportunities.');
                }
            }*/

            // Check for associated Opportunities
            //Solution 3
            List<Account> lstAccounts=[Select id,(Select Id from Opportunities) From Account where ID in : Trigger.oldMap.keyset()];
            Map<id,Integer> mapAccountOpps = new Map<Id,Integer>();
            for(Account accountObj : lstAccounts){
                Integer numberOpps=accountObj.Opportunities.isEmpty()?0:accountObj.Opportunities.size();
                mapAccountOpps.put(accountObj.id,numberOpps);
            }
            
            for (Account acc : Trigger.old) {
                if(mapAccountOpps.containsKey(acc.Id) && mapAccountOpps.get(acc.Id)>0){
                    acc.addError('You cannot delete this Account because it has associated Opportunities.');
                }
            }
        }
    }else if(Trigger.isAfter){
        
        if(Trigger.isInsert){ //requirement 3
            List<Task> lstTasks = new List<Task>();
            for (Account acc : Trigger.new) { //all records that got inserted (comitted to the org)
                // Create a Welcome Task for the Account Owner
                Task welcomeTask = new Task(	
                    Subject = 'Welcome to Salesforce!',
                    WhatId = acc.Id,
                    OwnerId = acc.OwnerId,
                    Status = 'Not Started',
                    Priority = 'Normal'
                );
                lstTasks.add(welcomeTask);
            }
            insert lstTasks;
        }else if(Trigger.isUpdate){ //requirement 4
            List<Task> lstTasks = new List<Task>();
            for (Account acc : Trigger.new) { //All record that got updated already(change comitted to org)
                
                Account oldAcc = Trigger.oldMap.get(acc.Id);
                // If AnnualRevenue is greater than $10,000,000, create a review task
                if (acc.AnnualRevenue != oldAcc.AnnualRevenue && acc.AnnualRevenue > 10000000 && oldAcc.AnnualRevenue<10000000) {
                    Task reviewTask = new Task(
                        Subject = 'Review High-Value Account4',
                        WhatId = acc.Id,
                        OwnerId = acc.OwnerId,
                        Status = 'Not Started',
                        Priority = 'High',
                        Description = 'Annual Revenue exceeded $10,000,000. Review account details.'
                    );
                    lstTasks.add(reviewTask);

                }
            }
            insert lstTasks;
        }else if (Trigger.isUndelete) { //requirement 6
            List<Task> tasks = new List<Task>();
            for (Account acc : Trigger.new) {
                // Create a Task for the Account Owner to review the restored Account
                Task reviewRestoredTask = new Task(
                    Subject = 'Review Restored Account',
                    WhatId = acc.Id,
                    OwnerId = acc.OwnerId,
                    Status = 'Not Started',
                    Priority = 'High',
                    Description = 'The Account has been restored. Please review the details.'
                );
                tasks.add(reviewRestoredTask);
            }
            insert tasks;
        }
    }
}