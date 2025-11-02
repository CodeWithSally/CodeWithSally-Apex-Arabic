// Demo Data Seeding Script: Task Manager (run anonymously)
// Purpose: Deletes current user's existing tasks and creates at least 3 tasks per category
// Categories: Overdue, Today, Tomorrow, This Week, Next Week, Later (including one with null date)
// Notes:
// - Safe and idempotent: affects only tasks owned by current user
// - No SOQL/DML inside loops; clear variable names; debug checkpoints

// Get current user
Id currentUserId = UserInfo.getUserId();

// 1) Cleanup: delete only this user's tasks to avoid duplicates across runs
List<Task> tasksToDelete = [SELECT Id FROM Task WHERE OwnerId = :currentUserId];
if (!tasksToDelete.isEmpty()) {
    delete tasksToDelete;
}
System.debug('Cleaned up existing tasks for current user: ' + tasksToDelete.size());

// 2) Prepare date helpers
Date today = Date.today();
Date tomorrow = today.addDays(1);

// Compute week windows (Mon–Sun)
Integer dayOfWeek = today.dayOfWeek(); // 1=Sun, 2=Mon, ..., 7=Sat
Integer offsetFromMonday;
if (dayOfWeek == 2) {
    offsetFromMonday = 0; // already Monday
} else if (dayOfWeek == 1) {
    offsetFromMonday = 6; // Sunday -> back 6 days to Monday
} else {
    offsetFromMonday = dayOfWeek - 2; // Tue..Sat -> back to Monday
}
Date startOfThisWeek = today.addDays(-offsetFromMonday);
Date endOfThisWeek = startOfThisWeek.addDays(6);
Date startOfNextWeek = startOfThisWeek.addDays(7);
Date endOfNextWeek = startOfNextWeek.addDays(6);

// 3) Build demo tasks
List<Task> tasksToInsert = new List<Task>();

// Overdue (3+)
tasksToInsert.add(new Task(Subject='Overdue - Call Client', Priority='High', ActivityDate=today.addDays(-1), OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Overdue - Send Contract', Priority='Normal', ActivityDate=today.addDays(-2), OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Overdue - Prepare Brief', Priority='Low', ActivityDate=today.addDays(-3), OwnerId=currentUserId, Status='Open'));

// Today (3+)
tasksToInsert.add(new Task(Subject='Today - Prepare Report', Priority='Normal', ActivityDate=today, OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Today - Customer Call', Priority='High', ActivityDate=today, OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Today - Inbox Zero', Priority='Low', ActivityDate=today, OwnerId=currentUserId, Status='Open'));

// Tomorrow (3+)
tasksToInsert.add(new Task(Subject='Tomorrow - Team Standup', Priority='Low', ActivityDate=tomorrow, OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Tomorrow - QA Review', Priority='Normal', ActivityDate=tomorrow, OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Tomorrow - Draft Update', Priority='High', ActivityDate=tomorrow, OwnerId=currentUserId, Status='Open'));

// This Week (after tomorrow but within this week, if possible)
Date thisWeekPick1 = (tomorrow.addDays(1) < startOfThisWeek) ? startOfThisWeek : tomorrow.addDays(1);
if (thisWeekPick1 > endOfThisWeek) thisWeekPick1 = endOfThisWeek;
Date thisWeekPick2 = thisWeekPick1.addDays(1);
if (thisWeekPick2 > endOfThisWeek) thisWeekPick2 = endOfThisWeek;
Date thisWeekPick3 = thisWeekPick2;

tasksToInsert.add(new Task(Subject='This Week - Review Proposal', Priority='High', ActivityDate=thisWeekPick1, OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='This Week - Submit Draft', Priority='Normal', ActivityDate=thisWeekPick2, OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='This Week - Align Stakeholders', Priority='Low', ActivityDate=thisWeekPick3, OwnerId=currentUserId, Status='Open'));

// Next Week (within next week)
tasksToInsert.add(new Task(Subject='Next Week - Budget Review', Priority='Normal', ActivityDate=startOfNextWeek, OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Next Week - Ops Sync', Priority='High', ActivityDate=startOfNextWeek.addDays(2), OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Next Week - Partner Call', Priority='Low', ActivityDate=endOfNextWeek, OwnerId=currentUserId, Status='Open'));

// Later (beyond next week) and one with null date
tasksToInsert.add(new Task(Subject='Later - Research Competitors', Priority='Low', ActivityDate=endOfNextWeek.addDays(3), OwnerId=currentUserId, Status='Open'));
tasksToInsert.add(new Task(Subject='Later - Plan Webinar', Priority='Normal', ActivityDate=endOfNextWeek.addDays(10), OwnerId=currentUserId, Status='Open'));
// Null due date => should show under "Later"
tasksToInsert.add(new Task(Subject='Later - Follow Up (No Date)', Priority='High', OwnerId=currentUserId, Status='Open'));

// 4) Insert
if (!tasksToInsert.isEmpty()) {
    insert tasksToInsert;
}
System.debug('Seeded demo tasks for Task Manager. Inserted: ' + tasksToInsert.size());
