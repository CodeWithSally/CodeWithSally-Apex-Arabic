@isTest
public class TaskManagerApexControllerTest {

    @isTest
    static void testGetTasks() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'User' LIMIT 1];
        if (testUser == null) {
            // Create a test user if needed
            testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'test.user@example.com',
                Username = 'test.user@example.com',
                Alias = 'tuser',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;
        }

        // Create test tasks
        List<Task> tasksToInsert = new List<Task>();
        tasksToInsert.add(new Task(
            Subject = 'Overdue Task',
            Priority = 'High',
            ActivityDate = Date.today().addDays(-2),
            OwnerId = testUser.Id,
            Status = 'Open'
        ));
        tasksToInsert.add(new Task(
            Subject = 'Today Task',
            Priority = 'Normal',
            ActivityDate = Date.today(),
            OwnerId = testUser.Id,
            Status = 'Open'
        ));
        tasksToInsert.add(new Task(
            Subject = 'Tomorrow Task',
            Priority = 'Low',
            ActivityDate = Date.today().addDays(1),
            OwnerId = testUser.Id,
            Status = 'Open'
        ));
        tasksToInsert.add(new Task(
            Subject = 'Next Week Task',
            Priority = 'High',
            ActivityDate = Date.today().addDays(8),
            OwnerId = testUser.Id,
            Status = 'Open'
        ));
        tasksToInsert.add(new Task(
            Subject = 'Later Task',
            Priority = 'Normal',
            ActivityDate = Date.today().addDays(15),
            OwnerId = testUser.Id,
            Status = 'Open'
        ));
        tasksToInsert.add(new Task(
            Subject = 'Null Date Task',
            Priority = 'Low',
            OwnerId = testUser.Id,
            Status = 'Open'
        ));

        insert tasksToInsert;

        // Execute
        Map<String, List<Task>> result = TaskManagerApexController.getTasks();

        // Verify
        System.assert(result != null, 'Result should not be null');
        System.assertEquals(6, result.size(), 'Should have 6 groups');

        List<Task> overdueTasks = result.get('Overdue');
        List<Task> todayTasks = result.get('Today');
        List<Task> tomorrowTasks = result.get('Tomorrow');
        List<Task> thisWeekTasks = result.get('This Week');
        List<Task> nextWeekTasks = result.get('Next Week');
        List<Task> laterTasks = result.get('Later');

        System.assert(overdueTasks != null, 'Overdue tasks should not be null');
        System.assert(todayTasks != null, 'Today tasks should not be null');
        System.assert(tomorrowTasks != null, 'Tomorrow tasks should not be null');
        System.assert(thisWeekTasks != null, 'This Week tasks should not be null');
        System.assert(nextWeekTasks != null, 'Next Week tasks should not be null');
        System.assert(laterTasks != null, 'Later tasks should not be null');

        System.assertEquals(1, overdueTasks.size(), 'Should have 1 overdue task');
        System.assertEquals(1, todayTasks.size(), 'Should have 1 today task');
        System.assertEquals(1, tomorrowTasks.size(), 'Should have 1 tomorrow task');
        System.assertEquals(0, thisWeekTasks.size(), 'Should have 0 this week tasks');
        System.assertEquals(1, nextWeekTasks.size(), 'Should have 1 next week task');
        System.assertEquals(2, laterTasks.size(), 'Should have 2 later tasks (null date and future date)');
    }

    @isTest
    static void testCloseTaskSuccess() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'User' LIMIT 1];
        if (testUser == null) {
            testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'test.user@example.com',
                Username = 'test.user@example.com',
                Alias = 'tuser',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;
        }

        Task task = new Task(
            Subject = 'Test Task',
            Priority = 'Normal',
            ActivityDate = Date.today(),
            OwnerId = testUser.Id,
            Status = 'Open'
        );
        insert task;

        // Execute
        Boolean result = TaskManagerApexController.closeTask(task.Id);

        // Verify
        System.assert(result, 'Close task should return true on success');
        
        Task updatedTask = [SELECT Status FROM Task WHERE Id = :task.Id];
        System.assertEquals('Completed', updatedTask.Status, 'Task status should be Completed');
    }

    @isTest
    static void testCloseTaskFailure() {
        // Execute
        Boolean result = TaskManagerApexController.closeTask(null);

        // Verify
        System.assert(!result, 'Close task should return false for invalid task ID');
    }

    @isTest
    static void testDeferTaskSuccess() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'User' LIMIT 1];
        if (testUser == null) {
            testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'test.user@example.com',
                Username = 'test.user@example.com',
                Alias = 'tuser',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;
        }

        Task task = new Task(
            Subject = 'Test Task',
            Priority = 'Normal',
            ActivityDate = Date.today(),
            OwnerId = testUser.Id,
            Status = 'Open'
        );
        insert task;

        // Execute
        Boolean result = TaskManagerApexController.deferTask(task.Id);

        // Verify
        System.assert(result, 'Defer task should return true on success');
        
        Task updatedTask = [SELECT ActivityDate FROM Task WHERE Id = :task.Id];
        System.assertEquals(Date.today().addDays(1), updatedTask.ActivityDate, 'Task activity date should be tomorrow');
    }

    @isTest
    static void testDeferTaskFailure() {
        // Execute
        Boolean result = TaskManagerApexController.deferTask(null);

        // Verify
        System.assert(!result, 'Defer task should return false for invalid task ID');
    }
}
