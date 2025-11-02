@IsTest
private class TaskManagerApexControllerTest {
    // Constants for predictable grouping and naming
    private static final String DEMO_PREFIX = '[TM TEST] ';

    @testSetup
    static void setupData() {
        // Create a dedicated user to own tasks to avoid interference with running user
        // For simplicity and to keep focus on controller logic, tasks will be owned by the running user.
        // Seed at least 1 record per group; more in specific tests if needed.
        Date today = Date.today();
        Date tomorrow = today.addDays(1);

        Date startOfThisWeek = today.toStartOfWeek(); // Monday
        Date endOfThisWeek = startOfThisWeek.addDays(6); // Sunday
        Date startOfNextWeek = startOfThisWeek.addDays(7);
        Date endOfNextWeek = startOfNextWeek.addDays(6);

        List<Task> lst = new List<Task>();

        // Overdue: ActivityDate < today
        lst.add(new Task(Subject = DEMO_PREFIX + 'Overdue A', Status = 'Not Started', Priority = 'Normal', ActivityDate = today.addDays(-2), OwnerId = UserInfo.getUserId()));
        // Today
        lst.add(new Task(Subject = DEMO_PREFIX + 'Today A', Status = 'Not Started', Priority = 'High', ActivityDate = today, OwnerId = UserInfo.getUserId()));
        // Tomorrow
        lst.add(new Task(Subject = DEMO_PREFIX + 'Tomorrow A', Status = 'Not Started', Priority = 'Normal', ActivityDate = tomorrow, OwnerId = UserInfo.getUserId()));
        // This Week: after tomorrow and within this week
        Date thisWeekDay = (tomorrow.addDays(1) <= endOfThisWeek) ? tomorrow.addDays(1) : endOfThisWeek;
        lst.add(new Task(Subject = DEMO_PREFIX + 'ThisWeek A', Status = 'Not Started', Priority = 'Low', ActivityDate = thisWeekDay, OwnerId = UserInfo.getUserId()));
        // Next Week: within next week window
        lst.add(new Task(Subject = DEMO_PREFIX + 'NextWeek A', Status = 'Not Started', Priority = 'Normal', ActivityDate = startOfNextWeek, OwnerId = UserInfo.getUserId()));
        // Later: beyond next week
        lst.add(new Task(Subject = DEMO_PREFIX + 'Later A', Status = 'Not Started', Priority = 'Normal', ActivityDate = endOfNextWeek.addDays(1), OwnerId = UserInfo.getUserId()));
        // Later: null date
        lst.add(new Task(Subject = DEMO_PREFIX + 'Later Null', Status = 'Not Started', Priority = 'Normal', ActivityDate = null, OwnerId = UserInfo.getUserId()));

        insert lst;
    }

    @IsTest
    static void testGetTasks_GroupingAndPresence() {
        Test.startTest();
        Map<String, List<Task>> result = TaskManagerApexController.getTasks();
        Test.stopTest();

        // Validate keys and at least one record in each expected group
        Assert.isTrue(result.containsKey('Overdue'), 'Result should contain Overdue group');
        Assert.isTrue(result.containsKey('Today'), 'Result should contain Today group');
        Assert.isTrue(result.containsKey('Tomorrow'), 'Result should contain Tomorrow group');
        Assert.isTrue(result.containsKey('This Week'), 'Result should contain This Week group');
        Assert.isTrue(result.containsKey('Next Week'), 'Result should contain Next Week group');
        Assert.isTrue(result.containsKey('Later'), 'Result should contain Later group');

        // Check that our seeded examples made it into the correct buckets
        Assert.isTrue(!result.get('Overdue').isEmpty(), 'Overdue should not be empty');
        Assert.isTrue(!result.get('Today').isEmpty(), 'Today should not be empty');
        Assert.isTrue(!result.get('Tomorrow').isEmpty(), 'Tomorrow should not be empty');
        Assert.isTrue(!result.get('This Week').isEmpty(), 'This Week should not be empty');
        Assert.isTrue(!result.get('Next Week').isEmpty(), 'Next Week should not be empty');
        Assert.isTrue(!result.get('Later').isEmpty(), 'Later should not be empty');

        // Make sure null ActivityDate landed in Later
        Boolean hasNullDueInLater = false;
        for (Task t : result.get('Later')) {
            if (t.Subject.startsWith(DEMO_PREFIX + 'Later Null')) {
                hasNullDueInLater = true;
                break;
            }
        }
        Assert.isTrue(hasNullDueInLater, 'Later group should include task with null ActivityDate');
    }

    @IsTest
    static void testCloseTask_SuccessAndAlreadyCompleted() {
        // Pick a non-completed task (e.g., Today A)
        Task t = [SELECT Id, Status, Subject FROM Task WHERE Subject = :DEMO_PREFIX + 'Today A' LIMIT 1];
        Assert.areNotEqual('Completed', t.Status, 'Precondition: task should not be Completed');

        Test.startTest();
        Boolean ok = TaskManagerApexController.closeTask(t.Id);
        Test.stopTest();

        Assert.isTrue(ok, 'closeTask should return true on success');
        Task reloaded = [SELECT Id, Status FROM Task WHERE Id = :t.Id];
        Assert.areEqual('Completed', reloaded.Status, 'Task should be marked Completed');

        // Negative-ish: calling closeTask again should still return true (idempotent update)
        Test.startTest();
        Boolean okAgain = TaskManagerApexController.closeTask(t.Id);
        Test.stopTest();
        Assert.isTrue(okAgain, 'closeTask should be idempotent and return true again');
    }

    @IsTest
    static void testCloseTask_InvalidId() {
        Test.startTest();
        Boolean ok = TaskManagerApexController.closeTask(null);
        Test.stopTest();

        Assert.isFalse(ok, 'closeTask should return false when taskId is null');
    }

    @IsTest
    static void testDeferTask_MovesDateByOneDay() {
        // Use a Tomorrow record, so it should stay in the future after deferring
        Task t = [SELECT Id, ActivityDate, Subject FROM Task WHERE Subject = :DEMO_PREFIX + 'Tomorrow A' LIMIT 1];
        Date original = t.ActivityDate;

        Test.startTest();
        Boolean ok = TaskManagerApexController.deferTask(t.Id);
        Test.stopTest();

        Assert.isTrue(ok, 'deferTask should return true on success');

        Task reloaded = [SELECT Id, ActivityDate FROM Task WHERE Id = :t.Id];
        Assert.areEqual(original.addDays(1), reloaded.ActivityDate, 'ActivityDate should be incremented by 1 day');
    }

    @IsTest
    static void testDeferTask_NullActivityDateBecomesTomorrow() {
        // Create a record with null due date for this test case
        Task t = new Task(Subject = DEMO_PREFIX + 'Defer Null Case', Status = 'Not Started', Priority = 'Normal', ActivityDate = null, OwnerId = UserInfo.getUserId());
        insert t;

        Test.startTest();
        Boolean ok = TaskManagerApexController.deferTask(t.Id);
        Test.stopTest();

        Assert.isTrue(ok, 'deferTask should return true on success');
        Task reloaded = [SELECT Id, ActivityDate FROM Task WHERE Id = :t.Id];
        Assert.areEqual(Date.today().addDays(1), reloaded.ActivityDate, 'Null ActivityDate should become today + 1 day');
    }

    @IsTest
    static void testGetTasks_BoundaryTransitions() {
        // Craft a record that is at end of this week then defer it to push into next week/later as needed
        Date today = Date.today();
        Date startOfThisWeek = today.toStartOfWeek();
        Date endOfThisWeek = startOfThisWeek.addDays(6);
        Task boundary = new Task(Subject = DEMO_PREFIX + 'Boundary ThisWeek', Status = 'Not Started', Priority = 'Normal', ActivityDate = endOfThisWeek, OwnerId = UserInfo.getUserId());
        insert boundary;

        // Verify it appears in This Week
        Map<String, List<Task>> before = TaskManagerApexController.getTasks();
        Boolean foundInThisWeek = false;
        for (Task t : before.get('This Week')) {
            if (t.Id == boundary.Id) {
                foundInThisWeek = true;
                break;
            }
        }
        Assert.isTrue(foundInThisWeek, 'Task should be categorized in This Week initially');

        // Defer and verify date changed by +1
        Test.startTest();
        Boolean ok = TaskManagerApexController.deferTask(boundary.Id);
        Test.stopTest();
        Assert.isTrue(ok, 'deferTask should succeed on boundary task');

        Task after = [SELECT Id, ActivityDate FROM Task WHERE Id = :boundary.Id];
        Assert.areEqual(endOfThisWeek.addDays(1), after.ActivityDate, 'Boundary task date should have moved +1 day');
    }
}
