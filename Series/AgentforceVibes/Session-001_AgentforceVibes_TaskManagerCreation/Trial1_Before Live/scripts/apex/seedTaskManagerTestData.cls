/**
 * Script to seed test data for TaskManager component
 * This script will:
 * 1. Delete all existing tasks owned by the running user
 * 2. Create a set of test tasks covering all grouping categories
 * 3. Ensure we have at least one task in each category
 */
public class seedTaskManagerTestData {
    
    public static void run() {
        // Get current user ID
        Id currentUserId = UserInfo.getUserId();
        
        // Step 1: Delete existing tasks for this user to avoid duplicates
        List<Task> existingTasks = [SELECT Id FROM Task WHERE OwnerId = :currentUserId];
        if (!existingTasks.isEmpty()) {
            delete existingTasks;
        }
        
        // Step 2: Create test tasks covering all categories
        List<Task> tasksToCreate = new List<Task>();
        
        // Overdue task
        tasksToCreate.add(new Task(
            Subject = 'Overdue Task - Call Client',
            Priority = 'High',
            ActivityDate = Date.today().addDays(-3),
            OwnerId = currentUserId,
            Status = 'Open'
        ));
        
        // Today task
        tasksToCreate.add(new Task(
            Subject = 'Today Task - Prepare Report',
            Priority = 'Normal',
            ActivityDate = Date.today(),
            OwnerId = currentUserId,
            Status = 'Open'
        ));
        
        // Tomorrow task
        tasksToCreate.add(new Task(
            Subject = 'Tomorrow Task - Team Sync',
            Priority = 'Low',
            ActivityDate = Date.today().addDays(1),
            OwnerId = currentUserId,
            Status = 'Open'
        ));
        
        // This Week task (2 days from now)
        tasksToCreate.add(new Task(
            Subject = 'This Week Task - Review Proposal',
            Priority = 'High',
            ActivityDate = Date.today().addDays(2),
            OwnerId = currentUserId,
            Status = 'Open'
        ));
        
        // Next Week task (8 days from now)
        tasksToCreate.add(new Task(
            Subject = 'Next Week Task - Submit Budget',
            Priority = 'Normal',
            ActivityDate = Date.today().addDays(8),
            OwnerId = currentUserId,
            Status = 'Open'
        ));
        
        // Later task (15 days from now)
        tasksToCreate.add(new Task(
            Subject = 'Later Task - Research Competitors',
            Priority = 'Low',
            ActivityDate = Date.today().addDays(15),
            OwnerId = currentUserId,
            Status = 'Open'
        ));
        
        // Task with null due date (should go to "Later")
        tasksToCreate.add(new Task(
            Subject = 'Null Date Task - Follow Up',
            Priority = 'Normal',
            OwnerId = currentUserId,
            Status = 'Open'
        ));
        
        // Create all tasks
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
        
        System.debug('Successfully seeded test tasks for TaskManager component.');
    }
}
