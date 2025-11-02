public without sharing class TaskManagerApexController {
    // Constants for group keys to avoid typos and keep UI contract clear
    private static final String GROUP_OVERDUE = 'Overdue';
    private static final String GROUP_TODAY = 'Today';
    private static final String GROUP_TOMORROW = 'Tomorrow';
    private static final String GROUP_THIS_WEEK = 'This Week';
    private static final String GROUP_NEXT_WEEK = 'Next Week';
    private static final String GROUP_LATER = 'Later';

    // Public API - getTasks
    // Returns a Map where keys are the fixed group names and values are Task lists
    @AuraEnabled
    public static Map<String, List<Task>> getTasks() {
        // Prepare result map seeded with all groups to ensure deterministic ordering on client
        Map<String, List<Task>> mapGroupedTasks = new Map<String, List<Task>>{
            GROUP_OVERDUE => new List<Task>(),
            GROUP_TODAY => new List<Task>(),
            GROUP_TOMORROW => new List<Task>(),
            GROUP_THIS_WEEK => new List<Task>(),
            GROUP_NEXT_WEEK => new List<Task>(),
            GROUP_LATER => new List<Task>()
        };

        // Compute date anchors based on org/user timezone
        Date today = Date.today();
        Date tomorrow = today.addDays(1);

        // Determine current week (Mon-Sun) and next week ranges
        // ISO-like week logic: Monday=1 ... Sunday=7
        Integer dow = today.toStartOfWeek().daysBetween(today) + 1; // derive day-of-week indirectly
        // Simpler and safer: Apex provides toStartOfWeek()/toStartOfMonth(), use toStartOfWeek()
        Date startOfThisWeek = today.toStartOfWeek(); // Monday of current week
        Date endOfThisWeek = startOfThisWeek.addDays(6); // Sunday
        Date startOfNextWeek = startOfThisWeek.addDays(7);
        Date endOfNextWeek = startOfNextWeek.addDays(6);

        // Query open tasks for the running user (avoid DML/SOQL in loops, simple single query)
        // Fields selected per UI need and grouping logic
        List<Task> lstOpenTasks = [
            SELECT Id, Subject, Priority, ActivityDate, Status, OwnerId
            FROM Task
            WHERE OwnerId = :UserInfo.getUserId()
              AND Status != 'Completed'
            ORDER BY ActivityDate NULLS LAST, Priority, Subject
            LIMIT 2000
        ];

        // Grouping logic following the requirements
        for (Task taskRecord : lstOpenTasks) {
            Date dueDate = taskRecord.ActivityDate;

            if (dueDate == null) {
                // Null dates are considered "Later"
                mapGroupedTasks.get(GROUP_LATER).add(taskRecord);
                continue;
            }

            if (dueDate < today) {
                mapGroupedTasks.get(GROUP_OVERDUE).add(taskRecord);
            } else if (dueDate == today) {
                mapGroupedTasks.get(GROUP_TODAY).add(taskRecord);
            } else if (dueDate == tomorrow) {
                mapGroupedTasks.get(GROUP_TOMORROW).add(taskRecord);
            } else if (dueDate > tomorrow && dueDate >= startOfThisWeek && dueDate <= endOfThisWeek) {
                // After Tomorrow but still in current week
                mapGroupedTasks.get(GROUP_THIS_WEEK).add(taskRecord);
            } else if (dueDate >= startOfNextWeek && dueDate <= endOfNextWeek) {
                mapGroupedTasks.get(GROUP_NEXT_WEEK).add(taskRecord);
            } else {
                mapGroupedTasks.get(GROUP_LATER).add(taskRecord);
            }
        }

        return mapGroupedTasks;
    }

    // Public API - closeTask
    // Marks a task as Completed
    @AuraEnabled
    public static Boolean closeTask(Id taskId) {
        if (taskId == null) {
            return false;
        }
        try {
            // Partial update with minimal fields for efficiency
            Task taskToClose = new Task(
                Id = taskId,
                Status = 'Completed'
            );
            update taskToClose;
            return true;
        } catch (Exception ex) {
            // Log for debugging; surface boolean to client per contract
            System.debug('closeTask failed: ' + ex.getMessage());
            return false;
        }
    }

    // Public API - deferTask
    // Adds 1 day to ActivityDate
    @AuraEnabled
    public static Boolean deferTask(Id taskId) {
        if (taskId == null) {
            return false;
        }

        try {
            // Query current ActivityDate to compute new date (handles null -> today+1 per reasonable assumption)
            Task currentTask = [
                SELECT Id, ActivityDate
                FROM Task
                WHERE Id = :taskId
                LIMIT 1
            ];

            Date currentDue = currentTask.ActivityDate;
            Date newDue = (currentDue == null) ? Date.today().addDays(1) : currentDue.addDays(1);

            Task taskToUpdate = new Task(
                Id = taskId,
                ActivityDate = newDue
            );
            update taskToUpdate;
            return true;
        } catch (QueryException qx) {
            System.debug('deferTask query failed: ' + qx.getMessage());
            return false;
        } catch (Exception ex) {
            System.debug('deferTask failed: ' + ex.getMessage());
            return false;
        }
    }
}
