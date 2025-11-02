@IsTest
private class TaskManagerApexControllerTest {
    /*
     * Test coverage for TaskManagerApexController
     * Scenarios:
     *  - getTasks groups: Overdue, Today, Tomorrow, This Week, Next Week, Later
     *  - closeTask positive/negative
     *  - deferTask positive (with/null date) and negative
     * Notes:
     *  - Use Assert class methods per project rules
     */

    @testSetup
    static void setupData() {
        Id currentUserId = UserInfo.getUserId();

        // Clean tasks for current user to avoid interference
        List<Task> existing = [SELECT Id FROM Task WHERE OwnerId = :currentUserId];
        if (!existing.isEmpty()) {
            delete existing;
        }

        Date today = Date.today();
        Date tomorrow = today.addDays(1);

        // Compute week windows for setup
        Date startOfThisWeek = getStartOfWeek(today);
        Date endOfThisWeek = startOfThisWeek.addDays(6);
        Date startOfNextWeek = startOfThisWeek.addDays(7);
        Date endOfNextWeek = startOfNextWeek.addDays(6);

        List<Task> toInsert = new List<Task>();

        // Overdue (yesterday)
        toInsert.add(new Task(Subject = 'Overdue A', Priority = 'High', ActivityDate = today.addDays(-1), OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Overdue B', Priority = 'Normal', ActivityDate = today.addDays(-2), OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Overdue C', Priority = 'Low', ActivityDate = today.addDays(-3), OwnerId = currentUserId, Status = 'Open'));

        // Today
        toInsert.add(new Task(Subject = 'Today A', Priority = 'High', ActivityDate = today, OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Today B', Priority = 'Normal', ActivityDate = today, OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Today C', Priority = 'Low', ActivityDate = today, OwnerId = currentUserId, Status = 'Open'));

        // Tomorrow
        toInsert.add(new Task(Subject = 'Tomorrow A', Priority = 'Low', ActivityDate = tomorrow, OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Tomorrow B', Priority = 'Normal', ActivityDate = tomorrow, OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Tomorrow C', Priority = 'High', ActivityDate = tomorrow, OwnerId = currentUserId, Status = 'Open'));

        // This Week: after tomorrow but within this week
        Date thisWeekPick1 = minDate(maxDate(tomorrow.addDays(1), startOfThisWeek), endOfThisWeek);
        Date thisWeekPick2 = minDate(maxDate(tomorrow.addDays(2), startOfThisWeek), endOfThisWeek);
        toInsert.add(new Task(Subject = 'ThisWeek A', Priority = 'High', ActivityDate = thisWeekPick1, OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'ThisWeek B', Priority = 'Normal', ActivityDate = thisWeekPick2, OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'ThisWeek C', Priority = 'Low', ActivityDate = thisWeekPick2, OwnerId = currentUserId, Status = 'Open'));

        // Next Week: within next week
        toInsert.add(new Task(Subject = 'NextWeek A', Priority = 'Normal', ActivityDate = startOfNextWeek, OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'NextWeek B', Priority = 'Low', ActivityDate = startOfNextWeek.addDays(1), OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'NextWeek C', Priority = 'High', ActivityDate = endOfNextWeek, OwnerId = currentUserId, Status = 'Open'));

        // Later: after end of next week + null date
        toInsert.add(new Task(Subject = 'Later A', Priority = 'Low', ActivityDate = endOfNextWeek.addDays(1), OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Later B', Priority = 'Normal', ActivityDate = endOfNextWeek.addDays(5), OwnerId = currentUserId, Status = 'Open'));
        toInsert.add(new Task(Subject = 'Later C (Null)', Priority = 'High', OwnerId = currentUserId, Status = 'Open'));

        // Completed (should be excluded)
        toInsert.add(new Task(Subject = 'Completed Should Exclude', Priority = 'Normal', ActivityDate = today, OwnerId = currentUserId, Status = 'Completed'));

        insert toInsert
    }

    @IsTest
    static void testGetTasks_GroupsAndCounts() {
        Test.startTest();
        Map<String, List<Task>> result = TaskManagerApexController.getTasks();
        Test.stopTest();

        // Validate presence of all buckets
        Assert.isTrue(result.containsKey('Overdue'), 'Missing Overdue key');
        Assert.isTrue(result.containsKey('Today'), 'Missing Today key');
        Assert.isTrue(result.containsKey('Tomorrow'), 'Missing Tomorrow key');
        Assert.isTrue(result.containsKey('This Week'), 'Missing This Week key');
        Assert.isTrue(result.containsKey('Next Week'), 'Missing Next Week key');
        Assert.isTrue(result.containsKey('Later'), 'Missing Later key');

        // Validate counts (3 per category, Completed excluded)
        Assert.areEqual(3, result.get('Overdue').size(), 'Overdue count mismatch');
        Assert.areEqual(3, result.get('Today').size(), 'Today count mismatch');
        Assert.areEqual(3, result.get('Tomorrow').size(), 'Tomorrow count mismatch');
        Assert.areEqual(3, result.get('This Week').size(), 'This Week count mismatch');
        Assert.areEqual(3, result.get('Next Week').size(), 'Next Week count mismatch');
        Assert.areEqual(3, result.get('Later').size(), 'Later count mismatch');
    }

    @IsTest
    static void testCloseTask_Positive() {
        // Pick an open task
        Task t = [SELECT Id, Status FROM Task WHERE Status != 'Completed' LIMIT 1];

        Test.startTest();
        Boolean ok = TaskManagerApexController.closeTask(t.Id);
        Test.stopTest();

        Assert.isTrue(ok, 'closeTask should return true');
        Task refreshed = [SELECT Status FROM Task WHERE Id = :t.Id];
        Assert.areEqual('Completed', refreshed.Status, 'Task should be completed');
    }

    @IsTest
    static void testCloseTask_Negative_InvalidId() {
        Test.startTest();
        Boolean ok = TaskManagerApexController.closeTask(null);
        Test.stopTest();

        Assert.isFalse(ok, 'closeTask should return false on null Id');
    }

    @IsTest
    static void testDeferTask_Positive_WithNullDate() {
        // Create a task with null ActivityDate
        Task t = new Task(Subject = 'Null Date Defer', Priority = 'Normal', Status = 'Open', OwnerId = UserInfo.getUserId());
        insert t;

        Test.startTest();
        Boolean ok = TaskManagerApexController.deferTask(t.Id);
        Test.stopTest();

        Assert.isTrue(ok, 'deferTask should return true');
        Task refreshed = [SELECT ActivityDate FROM Task WHERE Id = :t.Id];
        Assert.areEqual(Date.today().addDays(1), refreshed.ActivityDate, 'Null date should be set to tomorrow');
    }

    @IsTest
    static void testDeferTask_Positive_WithDate() {
        // Create a task with specific ActivityDate
        Task t = new Task(Subject = 'Has Date Defer', Priority = 'High', Status = 'Open', OwnerId = UserInfo.getUserId(), ActivityDate = Date.today());
        insert t;

        Test.startTest();
        Boolean ok = TaskManagerApexController.deferTask(t.Id);
        Test.stopTest();

        Assert.isTrue(ok, 'deferTask should return true');
        Task refreshed = [SELECT ActivityDate FROM Task WHERE Id = :t.Id];
        Assert.areEqual(Date.today().addDays(1), refreshed.ActivityDate, 'Date should be incremented by +1 day');
    }

    @IsTest
    static void testDeferTask_Negative_InvalidId() {
        Test.startTest();
        Boolean ok = TaskManagerApexController.deferTask(null);
        Test.stopTest();

        Assert.isFalse(ok, 'deferTask should return false on null Id');
    }

    // --- Helpers (match controller logic for week math) ---

    // Helper: Get Monday of the week for a given date (Mon–Sun)
    private static Date getStartOfWeek(Date d) {
        // Build a DateTime (format() is available here)
        Integer isoDow;
        try {
            isoDow = Integer.valueOf(Datetime.newInstance(d.year(), d.month(), d.day(), 12, 0, 0).format('e')); // 1=Mon..7=Sun
        } catch (Exception ex) {
            isoDow = 1; // fallback to Monday
        }
        Integer daysSinceMonday = isoDow - 1; // 0 when Monday
        return d.addDays(-daysSinceMonday);
    }

    private static Date maxDate(Date a, Date b) {
        return (a > b) ? a : b;
    }

    private static Date minDate(Date a, Date b) {
        return (a < b) ? a : b;
    }
}
