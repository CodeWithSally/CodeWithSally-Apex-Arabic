//1. When a new Account is created, set the Industry field to 'Technology' if it’s left blank. ==> before insert
//2. Accounts cannot have their AnnualRevenue reduced below $1,000,000. If a user attempts to do so, the system should display an error and prevent the update. ==> before update  
//3. After an Account is created, create a Welcome Task automatically for the Account Owner. ==> after insert
//4. Whenever an Account’s AnnualRevenue is updated, if the new value is greater than $10,000,000, notify the Account Owner by creating a task to review the Account. ==> after update
//5. "Users cannot delete an Account if it has associated Opportunities." ==> Before Delete (HW)
//6. Automatically create a Task for the Account Owner to review the restored Account.==> after undelete (HW)
trigger AccountTrigger on Account (before insert,before update,after insert,after update,before delete,after undelete) { //insert, update, delete , undelete
    
    switch on Trigger.operationType {
        when BEFORE_INSERT { //requirement 1
            AccountTriggerHandler.handleBeforeInsert(Trigger.New);
        }
        when AFTER_INSERT { //requirement 3
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
        }
        when BEFORE_UPDATE { //requirement 2
            AccountTriggerHandler.handleBeforeUpdate(Trigger.New,Trigger.Old,Trigger.newMap,Trigger.oldMap);
        }
        when AFTER_UPDATE { //requirement 4
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
        }
        when BEFORE_DELETE { //requirement 5
            // Check for associated Opportunities
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
        when AFTER_UNDELETE { //requirement 6
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