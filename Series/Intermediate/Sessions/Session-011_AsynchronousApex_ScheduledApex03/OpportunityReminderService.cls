public class OpportunityReminderService {
    public static void runReminderLogic() {
        List<Task> lstNewTasks = new List<Task>();
        for (Opportunity opp : [SELECT Name, OwnerId, CloseDate FROM Opportunity WHERE IsClosed = false AND CloseDate < TODAY LIMIT 1000]) {
            lstNewTasks.add(new Task(
                WhatId = opp.Id,
                OwnerId = opp.OwnerId,
                Subject = 'Follow up on overdue Opportunity',
                ActivityDate = Date.today() + 1
            ));
        }

        insert lstNewTasks;
    }
}
