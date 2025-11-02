// Get current user ID
Id currentUserId = UserInfo.getUserId();

// Step 1: Delete existing tasks for this user to avoid duplicates
List<Task> existingTasks = [SELECT Id FROM Task WHERE OwnerId = :currentUserId];
if (!existingTasks.isEmpty()) {
    delete existingTasks;
}

// Step 2: Create test tasks covering all categories with at least 3 per category

List<Task> tasksToCreate = new List<Task>();

// Overdue tasks (3 tasks)
tasksToCreate.add(new Task(
    Subject = 'Overdue Task - Call Client',
    Priority = 'High',
    ActivityDate = Date.today().addDays(-3),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Overdue Task - Prepare Report',
    Priority = 'Normal',
    ActivityDate = Date.today().addDays(-5),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Overdue Task - Review Proposal',
    Priority = 'Low',
    ActivityDate = Date.today().addDays(-10),
    OwnerId = currentUserId,
    Status = 'Open'
));

// Today tasks (3 tasks)
tasksToCreate.add(new Task(
    Subject = 'Today Task - Team Sync',
    Priority = 'High',
    ActivityDate = Date.today(),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Today Task - Prepare Presentation',
    Priority = 'Normal',
    ActivityDate = Date.today(),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Today Task - Client Meeting',
    Priority = 'Low',
    ActivityDate = Date.today(),
    OwnerId = currentUserId,
    Status = 'Open'
));

// Tomorrow tasks (3 tasks)
tasksToCreate.add(new Task(
    Subject = 'Tomorrow Task - Follow Up',
    Priority = 'High',
    ActivityDate = Date.today().addDays(1),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Tomorrow Task - Schedule Call',
    Priority = 'Normal',
    ActivityDate = Date.today().addDays(1),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Tomorrow Task - Review Feedback',
    Priority = 'Low',
    ActivityDate = Date.today().addDays(1),
    OwnerId = currentUserId,
    Status = 'Open'
));

// This Week tasks (3 tasks)
// These should be between tomorrow and end of current week (Sunday)
tasksToCreate.add(new Task(
    Subject = 'This Week Task - Submit Draft',
    Priority = 'High',
    ActivityDate = Date.today().addDays(2),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'This Week Task - Update Documentation',
    Priority = 'Normal',
    ActivityDate = Date.today().addDays(4),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'This Week Task - Plan Next Sprint',
    Priority = 'Low',
    ActivityDate = Date.today().addDays(6),
    OwnerId = currentUserId,
    Status = 'Open'
));

// Next Week tasks (3 tasks)
tasksToCreate.add(new Task(
    Subject = 'Next Week Task - Budget Approval',
    Priority = 'High',
    ActivityDate = Date.today().addDays(8),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Next Week Task - Performance Review',
    Priority = 'Normal',
    ActivityDate = Date.today().addDays(10),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Next Week Task - Training Session',
    Priority = 'Low',
    ActivityDate = Date.today().addDays(12),
    OwnerId = currentUserId,
    Status = 'Open'
));

// Later tasks (3 tasks)
tasksToCreate.add(new Task(
    Subject = 'Later Task - Market Research',
    Priority = 'High',
    ActivityDate = Date.today().addDays(15),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Later Task - Strategic Planning',
    Priority = 'Normal',
    ActivityDate = Date.today().addDays(20),
    OwnerId = currentUserId,
    Status = 'Open'
));

tasksToCreate.add(new Task(
    Subject = 'Later Task - Long Term Goals',
    Priority = 'Low',
    ActivityDate = Date.today().addDays(30),
    OwnerId = currentUserId,
    Status = 'Open'
));

// Create all tasks
if (!tasksToCreate.isEmpty()) {
    insert tasksToCreate;
}

System.debug('Successfully seeded test tasks for TaskManager component.');
