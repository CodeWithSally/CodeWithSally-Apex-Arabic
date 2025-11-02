// generate_test_tasks.apex
// Purpose: Seed demo Tasks for Task Manager LWC demo, idempotently and safely.
// How it works:
// - Deletes only tasks created by this script (identified by subject prefix).
// - Creates at least 3 tasks per category: Overdue, Today, Tomorrow, This Week, Next Week, Later.
// - Uses current running user as OwnerId.
// - Safe to run multiple times.

String SUBJECT_PREFIX = '[TM DEMO] ';

// 1) Delete existing demo tasks created by this script (idempotent cleanup)
List<Task> existingDemo = [
    SELECT Id, Subject
    FROM Task
    WHERE Subject LIKE :SUBJECT_PREFIX + '%'
    LIMIT 10000
];
if (!existingDemo.isEmpty()) {
    delete existingDemo;
    System.debug('Deleted demo tasks: ' + existingDemo.size());
} else {
    System.debug('No existing demo tasks to delete.');
}

// 2) Date helpers
Date today = Date.today();
Date tomorrow = today.addDays(1);
Date startOfThisWeek = today.toStartOfWeek(); // Monday
Date endOfThisWeek = startOfThisWeek.addDays(6); // Sunday
Date startOfNextWeek = startOfThisWeek.addDays(7);
Date endOfNextWeek = startOfNextWeek.addDays(6);

// Pick some representative days
Date overdue1 = today.addDays(-1);
Date overdue2 = today.addDays(-2);
Date overdue3 = today.addDays(-3);

Date thisWeek1 = (tomorrow.addDays(1) <= endOfThisWeek) ? tomorrow.addDays(1) : endOfThisWeek;
Date thisWeek2 = (thisWeek1.addDays(1) <= endOfThisWeek) ? thisWeek1.addDays(1) : endOfThisWeek;
Date thisWeek3 = (thisWeek2.addDays(1) <= endOfThisWeek) ? thisWeek2.addDays(1) : endOfThisWeek;

Date nextWeek1 = startOfNextWeek;
Date nextWeek2 = startOfNextWeek.addDays(1);
Date nextWeek3 = startOfNextWeek.addDays(2);

Date later1 = endOfNextWeek.addDays(1);
Date later2 = later1.addDays(10);
Date later3 = later2.addDays(10);

// 3) Build demo tasks (≥3 per category). Use varying priorities for visual interest.
List<Task> toInsert = new List<Task>{
    // Overdue
    new Task(Subject = SUBJECT_PREFIX + 'Overdue - Follow up lead', Status = 'Not Started', Priority = 'High', ActivityDate = overdue1, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Overdue - Call supplier', Status = 'In Progress', Priority = 'Normal', ActivityDate = overdue2, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Overdue - Prepare brief', Status = 'Not Started', Priority = 'Low', ActivityDate = overdue3, OwnerId = UserInfo.getUserId()),

    // Today
    new Task(Subject = SUBJECT_PREFIX + 'Today - Email prospect', Status = 'Not Started', Priority = 'High', ActivityDate = today, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Today - Internal sync', Status = 'In Progress', Priority = 'Normal', ActivityDate = today, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Today - Draft proposal', Status = 'Not Started', Priority = 'Low', ActivityDate = today, OwnerId = UserInfo.getUserId()),

    // Tomorrow
    new Task(Subject = SUBJECT_PREFIX + 'Tomorrow - Review contract', Status = 'Not Started', Priority = 'High', ActivityDate = tomorrow, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Tomorrow - Client check-in', Status = 'In Progress', Priority = 'Normal', ActivityDate = tomorrow, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Tomorrow - Prep demo', Status = 'Not Started', Priority = 'Low', ActivityDate = tomorrow, OwnerId = UserInfo.getUserId()),

    // This Week (after Tomorrow, within current week)
    new Task(Subject = SUBJECT_PREFIX + 'This Week - QA handoff', Status = 'Not Started', Priority = 'High', ActivityDate = thisWeek1, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'This Week - Refine requirements', Status = 'In Progress', Priority = 'Normal', ActivityDate = thisWeek2, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'This Week - Team retro', Status = 'Not Started', Priority = 'Low', ActivityDate = thisWeek3, OwnerId = UserInfo.getUserId()),

    // Next Week
    new Task(Subject = SUBJECT_PREFIX + 'Next Week - Kickoff session', Status = 'Not Started', Priority = 'High', ActivityDate = nextWeek1, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Next Week - Budget review', Status = 'In Progress', Priority = 'Normal', ActivityDate = nextWeek2, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Next Week - Design workshop', Status = 'Not Started', Priority = 'Low', ActivityDate = nextWeek3, OwnerId = UserInfo.getUserId()),

    // Later (beyond end of next week) + one null date
    new Task(Subject = SUBJECT_PREFIX + 'Later - Roadmap planning', Status = 'Not Started', Priority = 'High', ActivityDate = later1, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Later - Content calendar', Status = 'In Progress', Priority = 'Normal', ActivityDate = later2, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Later - Team offsite', Status = 'Not Started', Priority = 'Low', ActivityDate = later3, OwnerId = UserInfo.getUserId()),
    new Task(Subject = SUBJECT_PREFIX + 'Later - No due date', Status = 'Not Started', Priority = 'Normal', ActivityDate = null, OwnerId = UserInfo.getUserId())
};

insert toInsert;

System.debug('Created demo tasks: ' + toInsert.size());
System.debug('Use this script for quick reseeding before UI demos.');
