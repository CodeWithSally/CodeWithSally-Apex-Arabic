public with sharing class TaskManagerApexController {

    /**
     * Retrieves open tasks assigned to the current user, grouped by due date.
     * Groups: Overdue, Today, Tomorrow, This Week, Next Week, Later
     * @return Map<String, List<Task>> - Grouped tasks
     */
    @AuraEnabled
    public static Map<String, List<Task>> getTasks() {
        // Get current user ID
        Id currentUserId = UserInfo.getUserId();
        
        // Query open tasks assigned to current user
        List<Task> tasks = [
            SELECT Id, Subject, Priority, ActivityDate, Status
            FROM Task
            WHERE OwnerId = :currentUserId
            AND IsClosed = false
            ORDER BY ActivityDate ASC
        ];

        // Initialize result map
        Map<String, List<Task>> groupedTasks = new Map<String, List<Task>>();
        groupedTasks.put('Overdue', new List<Task>());
        groupedTasks.put('Today', new List<Task>());
        groupedTasks.put('Tomorrow', new List<Task>());
        groupedTasks.put('This Week', new List<Task>());
        groupedTasks.put('Next Week', new List<Task>());
        groupedTasks.put('Later', new List<Task>());

        // Get today's date (no time component)
        Date today = Date.today();
        Date tomorrow = today.addDays(1);
        Date nextWeekStart = today.addDays(7);
        Date nextWeekEnd = nextWeekStart.addDays(6);

        // Group tasks
        for (Task t : tasks) {
            Date dueDate = t.ActivityDate;
            
            // Handle null due dates
            if (dueDate == null) {
                groupedTasks.get('Later').add(t);
                continue;
            }

            if (dueDate < today) {
                groupedTasks.get('Overdue').add(t);
            } else if (dueDate == today) {
                groupedTasks.get('Today').add(t);
            } else if (dueDate == tomorrow) {
                groupedTasks.get('Tomorrow').add(t);
            } else if (dueDate >= nextWeekStart && dueDate <= nextWeekEnd) {
                groupedTasks.get('Next Week').add(t);
            } else if (dueDate > nextWeekEnd) {
                groupedTasks.get('Later').add(t);
            } else {
                // Default to "This Week" for dates between today+1 and nextWeekStart-1
                groupedTasks.get('This Week').add(t);
            }
        }

        return groupedTasks;
    }

    /**
     * Completes a task by setting its status to 'Completed'.
     * @param taskId The Id of the task to complete
     * @return Boolean indicating success
     */
    @AuraEnabled
    public static Boolean closeTask(Id taskId) {
        try {
            Task task = [
                SELECT Id, Status
                FROM Task
                WHERE Id = :taskId
                LIMIT 1
            ];
            
            if (task != null) {
                task.Status = 'Completed';
                update task;
                return true;
            }
            return false;
        } catch (Exception e) {
            // Log exception if needed (not required by spec)
            return false;
        }
    }

    /**
     * Defers a task by updating its due date to tomorrow.
     * @param taskId The Id of the task to defer
     * @return Boolean indicating success
     */
    @AuraEnabled
    public static Boolean deferTask(Id taskId) {
        try {
            Task task = [
                SELECT Id, ActivityDate
                FROM Task
                WHERE Id = :taskId
                LIMIT 1
            ];
            
            if (task != null) {
                task.ActivityDate = Date.today().addDays(1);
                update task;
                return true;
            }
            return false;
        } catch (Exception e) {
            // Log exception if needed (not required by spec)
            return false;
        }
    }
}
