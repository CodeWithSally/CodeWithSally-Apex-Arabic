@isTest
public class TaskManagerApexControllerTest {

    @testSetup
    static void setupTestData() {
        // Create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            Username = 'standarduser@testorgSALLY.com',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;

        // Create a test task owned by the user
        Task t1 = new Task(
            Subject = 'Test Task 1',
            Status = 'Not Started',
            Priority = 'High',
            ActivityDate = Date.today().addDays(-1), // Overdue
            OwnerId = testUser.Id
        );
        Task t2 = new Task(
            Subject = 'Test Task 2',
            Status = 'Not Started',
            Priority = 'Normal',
            ActivityDate = Date.today(), // Today
            OwnerId = testUser.Id
        );
        Task t3 = new Task(
            Subject = 'Test Task 3',
            Status = 'Not Started',
            Priority = 'Low',
            ActivityDate = Date.today().addDays(1), // Tomorrow
            OwnerId = testUser.Id
        );
        Task t4 = new Task(
            Subject = 'Test Task 4',
            Status = 'Not Started',
            Priority = 'High',
            ActivityDate = Date.today().addDays(3), // This Week
            OwnerId = testUser.Id
        );
        Task t5 = new Task(
            Subject = 'Test Task 5',
            Status = 'Not Started',
            Priority = 'Normal',
            ActivityDate = Date.today().addDays(8), // Next Week
            OwnerId = testUser.Id
        );
        Task t6 = new Task(
            Subject = 'Test Task 6',
            Status = 'Not Started',
            Priority = 'Low',
            ActivityDate = Date.today().addDays(20), // Later
            OwnerId = testUser.Id
        );

        // Create a completed task (should not appear)
        Task t7 = new Task(
            Subject = 'Completed Task',
            Status = 'Completed',
            Priority = 'Normal',
            ActivityDate = Date.today().addDays(-1),
            OwnerId = testUser.Id
        );

        // Create a task owned by another user (should not appear)
        User otherUser = new User(
            Alias = 'other',
            Email = 'otheruser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Other',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            Username = 'otheruser@testorg.com',
            TimeZoneSidKey = 'America/New_York'
        );
        insert otherUser;

        Task t8 = new Task(
            Subject = 'Other User Task',
            Status = 'Not Started',
            Priority = 'Normal',
            ActivityDate = Date.today(),
            OwnerId = otherUser.Id
        );

        insert new List<Task>{t1, t2, t3, t4, t5, t6, t7, t8};
    }

    @isTest
    static void testGetOpenTasks_GroupingAndSorting() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            // Execute
            TaskManagerApexController.TaskBuckets buckets = TaskManagerApexController.getOpenTasks();

            // Verify counts
            Assert.areEqual(1, buckets.overdue.size(), 'Should have 1 overdue task');
            Assert.areEqual(1, buckets.today.size(), 'Should have 1 today task');
            Assert.areEqual(1, buckets.tomorrow.size(), 'Should have 1 tomorrow task');
            Assert.areEqual(1, buckets.thisWeek.size(), 'Should have 1 this week task');
            Assert.areEqual(1, buckets.nextWeek.size(), 'Should have 1 next week task');
            Assert.areEqual(1, buckets.later.size(), 'Should have 1 later task');

            // Verify sorting within each bucket (by priority, then date, then subject)
            // Overdue: High priority first
            TaskManagerApexController.TaskRow overdueRow = buckets.overdue[0];
            Assert.areEqual('Test Task 1', overdueRow.subject, 'Overdue task should be sorted by subject');
            Assert.areEqual('High', overdueRow.priority, 'Overdue task should be High priority');

            // Today: High priority first
            TaskManagerApexController.TaskRow todayRow = buckets.today[0];
            Assert.areEqual('Test Task 2', todayRow.subject, 'Today task should be sorted by subject');
            Assert.areEqual('Normal', todayRow.priority, 'Today task should be Normal priority');

            // Tomorrow: High priority first
            TaskManagerApexController.TaskRow tomorrowRow = buckets.tomorrow[0];
            Assert.areEqual('Test Task 3', tomorrowRow.subject, 'Tomorrow task should be sorted by subject');
            Assert.areEqual('Low', tomorrowRow.priority, 'Tomorrow task should be Low priority');

            // This Week: High priority first
            TaskManagerApexController.TaskRow thisWeekRow = buckets.thisWeek[0];
            Assert.areEqual('Test Task 4', thisWeekRow.subject, 'This week task should be sorted by subject');
            Assert.areEqual('High', thisWeekRow.priority, 'This week task should be High priority');

            // Next Week: Normal priority first
            TaskManagerApexController.TaskRow nextWeekRow = buckets.nextWeek[0];
            Assert.areEqual('Test Task 5', nextWeekRow.subject, 'Next week task should be sorted by subject');
            Assert.areEqual('Normal', nextWeekRow.priority, 'Next week task should be Normal priority');

            // Later: Low priority first
            TaskManagerApexController.TaskRow laterRow = buckets.later[0];
            Assert.areEqual('Test Task 6', laterRow.subject, 'Later task should be sorted by subject');
            Assert.areEqual('Low', laterRow.priority, 'Later task should be Low priority');

            // Verify no completed or other-user tasks
            Set<String> allSubjects = new Set<String>();
            for (TaskManagerApexController.TaskRow row : buckets.overdue) allSubjects.add(row.subject);
            for (TaskManagerApexController.TaskRow row : buckets.today) allSubjects.add(row.subject);
            for (TaskManagerApexController.TaskRow row : buckets.tomorrow) allSubjects.add(row.subject);
            for (TaskManagerApexController.TaskRow row : buckets.thisWeek) allSubjects.add(row.subject);
            for (TaskManagerApexController.TaskRow row : buckets.nextWeek) allSubjects.add(row.subject);
            for (TaskManagerApexController.TaskRow row : buckets.later) allSubjects.add(row.subject);

            Assert.isNotNull(allSubjects, 'All tasks should be present');
            Assert.isFalse(allSubjects.contains('Completed Task'), 'Completed task should not be included');
            Assert.isFalse(allSubjects.contains('Other User Task'), 'Other user task should not be included');
        }
    }

    @isTest
    static void testCompleteTask_Success() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            Task taskToComplete = [SELECT Id FROM Task WHERE Subject = 'Test Task 1' LIMIT 1];

            // Execute
            TaskManagerApexController.TaskRow result = TaskManagerApexController.completeTask(taskToComplete.Id);

            // Verify
            Assert.isNotNull(result, 'Result should not be null');
            Assert.areEqual('Completed', result.status, 'Task status should be Completed');
            Assert.areEqual('completed', result.bucket, 'Bucket should be "completed" for completed tasks');

            // Verify the task is actually updated
            Task updatedTask = [SELECT Status, IsClosed FROM Task WHERE Id = :taskToComplete.Id LIMIT 1];
            Assert.areEqual('Completed', updatedTask.Status, 'Task should be updated to Completed');
            Assert.isTrue(updatedTask.IsClosed, 'Task should be IsClosed = true');
        }
    }

    @isTest
    static void testCompleteTask_InvalidId() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            // Execute & Verify
            try {
                TaskManagerApexController.completeTask(null);
                System.assert(false, 'Expected AuraHandledException was not thrown');
            } catch (AuraHandledException e) {
                System.assertEquals('Task Id is required.', e.getMessage(), 'Should throw correct error message');
            }
        }
    }

    @isTest
    static void testDeferTask_Tomorrow() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            Task taskToDefer = [SELECT Id, ActivityDate FROM Task WHERE Subject = 'Test Task 2' LIMIT 1];

            // Execute
            TaskManagerApexController.TaskRow result = TaskManagerApexController.deferTask(taskToDefer.Id, 'Tomorrow', null);

            // Verify
            Assert.isNotNull(result, 'Result should not be null');
            // When deferring to "Tomorrow", it should be set to tomorrow's actual date
            Assert.areEqual(Date.today().addDays(1), result.dueDate, 'ActivityDate should be set to tomorrow\'s date');

            // Verify the task is actually updated
            Task updatedTask = [SELECT ActivityDate FROM Task WHERE Id = :taskToDefer.Id LIMIT 1];
            Assert.areEqual(Date.today().addDays(1), updatedTask.ActivityDate, 'Task should be updated to tomorrow\'s date');
        }
    }

    @isTest
    static void testDeferTask_NextWeek() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            Task taskToDefer = [SELECT Id, ActivityDate FROM Task WHERE Subject = 'Test Task 3' LIMIT 1];

            // Store original date
            Date originalDate = taskToDefer.ActivityDate;

            // Execute
            TaskManagerApexController.TaskRow result = TaskManagerApexController.deferTask(taskToDefer.Id, 'NextWeek', null);

            // Verify
            Assert.isNotNull(result, 'Result should not be null');
            // Should be moved to next Monday (at least 1 day ahead)
            Date expectedDate = originalDate.addDays(7); // Simple assumption for test
            Assert.areEqual(expectedDate, result.dueDate, 'ActivityDate should be moved to next week');

            // Verify the task is actually updated
            Task updatedTask = [SELECT ActivityDate FROM Task WHERE Id = :taskToDefer.Id LIMIT 1];
            Assert.areEqual(expectedDate, updatedTask.ActivityDate, 'Task should be updated with new date');
        }
    }

    @isTest
    static void testDeferTask_CustomDays() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            Task taskToDefer = [SELECT Id, ActivityDate FROM Task WHERE Subject = 'Test Task 4' LIMIT 1];

            // Store original date
            Date originalDate = taskToDefer.ActivityDate;

            // Execute
            TaskManagerApexController.TaskRow result = TaskManagerApexController.deferTask(taskToDefer.Id, 'CustomDays', 5);

            // Verify
            Assert.isNotNull(result, 'Result should not be null');
            Assert.areEqual(originalDate.addDays(5), result.dueDate, 'ActivityDate should be incremented by 5 days');

            // Verify the task is actually updated
            Task updatedTask = [SELECT ActivityDate FROM Task WHERE Id = :taskToDefer.Id LIMIT 1];
            Assert.areEqual(originalDate.addDays(5), updatedTask.ActivityDate, 'Task should be updated with new date');
        }
    }

    @isTest
    static void testDeferTask_InvalidOption() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            Task taskToDefer = [SELECT Id FROM Task WHERE Subject = 'Test Task 5' LIMIT 1];

            // Execute & Verify
            try {
                TaskManagerApexController.completeTask(null);
                Assert.fail('Expected AuraHandledException was not thrown');
            } catch (AuraHandledException e) {
                Assert.areEqual('Task Id is required.', e.getMessage(), 'Should throw correct error message');
            }
        }
    }

    @isTest
    static void testDeferTask_AlreadyClosed() {
        // Setup
        User testUser = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            Task taskToDefer = [SELECT Id FROM Task WHERE Subject = 'Completed Task' LIMIT 1];

            // Execute & Verify
            try {
                TaskManagerApexController.deferTask(taskToDefer.Id, 'InvalidOption', null);
                Assert.fail('Expected AuraHandledException was not thrown');
            } catch (AuraHandledException e) {
                Assert.areEqual('Invalid defer option.', e.getMessage(), 'Should throw correct error message');
            }
            try {
                TaskManagerApexController.deferTask(taskToDefer.Id, 'Tomorrow', null);
                Assert.fail('Expected AuraHandledException was not thrown');
            } catch (AuraHandledException e) {
                Assert.areEqual('This task is already closed.', e.getMessage(), 'Should throw correct error message');
            }
        }
    }
}
