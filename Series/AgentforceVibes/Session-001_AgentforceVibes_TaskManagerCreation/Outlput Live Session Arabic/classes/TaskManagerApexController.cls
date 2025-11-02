public with sharing class TaskManagerApexController {
    /*
     * TaskManagerApexController
     * Backend controller for LWC 'taskManager'
     * - getTasks(): returns Map<String, List<Task>> grouped by due date buckets for current user
     * - closeTask(Id): marks a task as Completed
     * - deferTask(Id): increments ActivityDate by +1 day (or sets to tomorrow if null)
     *
     * Notes:
     * - We use Date.today() which already respects org/user context.
     * - Group keys must be exactly: Overdue, Today, Tomorrow, This Week, Next Week, Later.
     */

    // Public constants for group keys
    private static final String OVERDUE = 'Overdue';
    private static final String TODAY = 'Today';
    private static final String TOMORROW = 'Tomorrow';
    private static final String THIS_WEEK = 'This Week';
    private static final String NEXT_WEEK = 'Next Week';
    private static final String LATER = 'Later';

    @AuraEnabled(cacheable=false)
    public static Map<String, List<Task>> getTasks() {
        // Initialize result map with all groups to ensure stable keys in the UI
        Map<String, List<Task>> groupedTasks = new Map<String, List<Task>>();
        groupedTasks.put(OVERDUE, new List<Task>());
        groupedTasks.put(TODAY, new List<Task>());
        groupedTasks.put(TOMORROW, new List<Task>());
        groupedTasks.put(THIS_WEEK, new List<Task>());
        groupedTasks.put(NEXT_WEEK, new List<Task>());
        groupedTasks.put(LATER, new List<Task>());

        // Current user and date context
        Id currentUserId = UserInfo.getUserId();
        Date today = Date.today();
        Date tomorrow = today.addDays(1);

        // Compute week windows (Mon–Sun)
        Date startOfThisWeek = getStartOfWeek(today);
        Date endOfThisWeek = startOfThisWeek.addDays(6);
        Date startOfNextWeek = startOfThisWeek.addDays(7);
        Date endOfNextWeek = startOfNextWeek.addDays(6);

        // Query required fields for open tasks assigned to current user
        List<Task> openTasks = [
            SELECT Id, Subject, Priority, ActivityDate, Status, OwnerId
            FROM Task
            WHERE OwnerId = :currentUserId
              AND Status != 'Completed'
        ];

        // Group each task according to rules
        for (Task taskRecord : openTasks) {
            String bucket = computeGroupKey(
                taskRecord.ActivityDate,
                today,
                tomorrow,
                startOfThisWeek,
                endOfThisWeek,
                startOfNextWeek,
                endOfNextWeek
            );
            groupedTasks.get(bucket).add(taskRecord);
        }

        return groupedTasks;
    }

    @AuraEnabled
    public static Boolean closeTask(Id taskId) {
        // Close the task by setting Status to 'Completed'
        try {
            if (taskId == null) {
                return false;
            }
            Task taskToClose = new Task(Id = taskId, Status = 'Completed');
            update taskToClose;
            return true;
        } catch (Exception ex) {
            // Log the error for troubleshooting
            System.debug('closeTask error: ' + ex.getMessage());
            return false;
        }
    }

    @AuraEnabled
    public static Boolean deferTask(Id taskId) {
        // Defer the task by adding 1 day to ActivityDate; if null, set to tomorrow
        try {
            if (taskId == null) {
                return false;
            }
            Task t = [SELECT Id, ActivityDate FROM Task WHERE Id = :taskId LIMIT 1];

            Date baseDate = (t.ActivityDate == null) ? Date.today() : t.ActivityDate;
            Date newDate = baseDate.addDays(1);

            Task updateTask = new Task(Id = t.Id, ActivityDate = newDate);
            update updateTask;
            return true;
        } catch (Exception ex) {
            // Log the error for troubleshooting
            System.debug('deferTask error: ' + ex.getMessage());
            return false;
        }
    }

    // Helper: Determine the bucket key for a given date
    private static String computeGroupKey(
        Date activityDate,
        Date todayValue,
        Date tomorrowValue,
        Date startOfThisWeek,
        Date endOfThisWeek,
        Date startOfNextWeek,
        Date endOfNextWeek
    ) {
        if (activityDate == null) {
            return LATER; // Null due date => Later
        }

        if (activityDate < todayValue) return OVERDUE;
        if (activityDate == todayValue) return TODAY;
        if (activityDate == tomorrowValue) return TOMORROW;

        Boolean inThisWeek = (activityDate >= startOfThisWeek && activityDate <= endOfThisWeek);
        Boolean inNextWeek = (activityDate >= startOfNextWeek && activityDate <= endOfNextWeek);

        // This Week: within current week AND strictly after Tomorrow
        if (inThisWeek && activityDate > tomorrowValue) {
            return THIS_WEEK;
        }
        if (inNextWeek) {
            return NEXT_WEEK;
        }
        // Later: beyond end of next week
        if (activityDate > endOfNextWeek) {
            return LATER;
        }

        // Fallback (should not hit due to above conditions)
        return LATER;
    }

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
}
