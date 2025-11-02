public with sharing class TaskManagerApexController {
    // Constants per Code With Sally rules
    private static final String COMPLETED_STATUS = 'Completed';
    private static final Set<String> VALID_DEFER_OPTIONS = new Set<String>{ 'Tomorrow', 'NextWeek', 'Plus2Weeks', 'CustomDays' };

    // DTO representing a simplified Task row for LWC
    public class TaskRow {
        @AuraEnabled public Id id;
        @AuraEnabled public String subject;
        @AuraEnabled public String status;
        @AuraEnabled public String priority;
        @AuraEnabled public Date dueDate;
        @AuraEnabled public Id ownerId;
        @AuraEnabled public Boolean isHighPriority;
        @AuraEnabled public String description;
        @AuraEnabled public String bucket;
        @AuraEnabled public String dueDateLabel;

        public TaskRow() {}

        public TaskRow(Task t, String computedBucket) {
            this.id = t.Id;
            this.subject = t.Subject;
            this.status = t.Status;
            this.priority = t.Priority;
            this.dueDate = t.ActivityDate;
            this.ownerId = t.OwnerId;
            this.isHighPriority = (t.Priority == 'High');
            this.description = t.Description;
            this.bucket = computedBucket;
            // Format the due date for display
            if (t.ActivityDate != null) {
                this.dueDateLabel = t.ActivityDate.format();
            }
        }
    }

    // DTO representing all buckets returned to LWC
    public class TaskBuckets {
        @AuraEnabled public List<TaskRow> overdue { get; set; }
        @AuraEnabled public List<TaskRow> today { get; set; }
        @AuraEnabled public List<TaskRow> tomorrow { get; set; }
        @AuraEnabled public List<TaskRow> thisWeek { get; set; }
        @AuraEnabled public List<TaskRow> nextWeek { get; set; }
        @AuraEnabled public List<TaskRow> later { get; set; }
        public TaskBuckets() {
            overdue = new List<TaskRow>();
            today = new List<TaskRow>();
            tomorrow = new List<TaskRow>();
            thisWeek = new List<TaskRow>();
            nextWeek = new List<TaskRow>();
            later = new List<TaskRow>();
        }
    }

    /**
     * Phase 3: Non-cacheable fetch for always-fresh data.
     * Returns open tasks grouped by due date buckets for the logged-in user.
     */
    @AuraEnabled
    public static TaskBuckets getOpenTasks() {
        try {
            // Get the current user ID
            Id currentUserId = UserInfo.getUserId();
            // Query only open tasks assigned to the current user with required fields.
            List<Task> lstOpenTasks = [
                SELECT Id, Subject, Status, Priority, ActivityDate, OwnerId, Description, WhatId, WhoId, IsClosed
                FROM Task
                WHERE IsClosed = false AND OwnerId = :currentUserId
                ORDER BY Priority DESC, ActivityDate ASC, Subject ASC
                LIMIT 2000
            ];

            TaskBuckets buckets = new TaskBuckets();

            Date today = Date.today();
            Date startOfWeek = getStartOfWeekMonday(today);
            Date endOfWeek = startOfWeek.addDays(6);
            Date endOfNextWeek = endOfWeek.addDays(7);

            for (Task t : lstOpenTasks) {
                // Defensive: some open tasks could have null ActivityDate; treat nulls as 'later'
                Date due = t.ActivityDate;
                String bucketKey = computeBucket(due, today, endOfWeek, endOfNextWeek);
                TaskRow row = new TaskRow(t, bucketKey);

                if (bucketKey == 'overdue') {
                    buckets.overdue.add(row);
                } else if (bucketKey == 'today') {
                    buckets.today.add(row);
                } else if (bucketKey == 'tomorrow') {
                    buckets.tomorrow.add(row);
                } else if (bucketKey == 'thisWeek') {
                    buckets.thisWeek.add(row);
                } else if (bucketKey == 'nextWeek') {
                    buckets.nextWeek.add(row);
                } else {
                    buckets.later.add(row);
                }
            }

            // Sorting per-bucket: Priority (High first), Due Date asc, Subject asc
            sortBucket(buckets.overdue);
            sortBucket(buckets.today);
            sortBucket(buckets.tomorrow);
            sortBucket(buckets.thisWeek);
            sortBucket(buckets.nextWeek);
            sortBucket(buckets.later);

            return buckets;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getOpenTasks: ' + e.getMessage());
            throw new AuraHandledException('Unable to load tasks. Please try again or contact your admin.');
        }
    }

    /**
     * Completes a single task by setting Status to Completed.
     * Returns the updated TaskRow (note: completed tasks will no longer be returned by getOpenTasks()).
     */
    @AuraEnabled
    public static TaskRow completeTask(Id taskId) {
        if (taskId == null) {
            throw new AuraHandledException('Task Id is required.');
        }
        try {
            Task t = [
                SELECT Id, Subject, Status, Priority, ActivityDate, OwnerId, Description, IsClosed
                FROM Task
                WHERE Id = :taskId
                LIMIT 1
            ];

            if (t.IsClosed == true) {
                // Already closed; return current state for clarity
                return new TaskRow(t, 'completed');
            }

            t.Status = COMPLETED_STATUS; // Assumes org has this status value
            update t;

            // Re-query to reflect final state
            Task tAfter = [
                SELECT Id, Subject, Status, Priority, ActivityDate, OwnerId, Description, IsClosed
                FROM Task
                WHERE Id = :t.Id
                LIMIT 1
            ];

            // Completed tasks are not bucketed with opens; bucket label informational only.
            return new TaskRow(tAfter, 'completed');
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in completeTask: ' + e.getMessage());
            throw new AuraHandledException('Unable to complete the task. Please try again.');
        }
    }

    /**
     * Defers a single task by adjusting ActivityDate according to option/customDays.
     * Returns the updated TaskRow with recalculated bucket.
     */
    @AuraEnabled
    public static TaskRow deferTask(Id taskId, String option, Integer customDays) {
        if (taskId == null) {
            throw new AuraHandledException('Task Id is required.');
        }
        if (String.isBlank(option) || !VALID_DEFER_OPTIONS.contains(option)) {
            throw new AuraHandledException('Invalid defer option.');
        }

        try {
            Task t = [
                SELECT Id, Subject, Status, Priority, ActivityDate, OwnerId, Description, IsClosed
                FROM Task
                WHERE Id = :taskId
                LIMIT 1
            ];

            if (t.IsClosed == true) {
                throw new AuraHandledException('This task is already closed.');
            }

            // Compute new due date based on option
            Date baseDate = (t.ActivityDate != null) ? t.ActivityDate : Date.today();
            Date newDue;

            if (option == 'Tomorrow') {
                // Set to tomorrow's actual date
                newDue = Date.today().addDays(1);
            } else if (option == 'NextWeek') {
                // Move to next Monday relative to TODAY (consistent with LWC behavior)
                Date today = Date.today();
                Date nextMonday = getNextMonday(today);
                // If baseDate is after nextMonday, keep baseDate + 7 to avoid moving backwards
                newDue = (baseDate > nextMonday) ? baseDate.addDays(7) : nextMonday;
            } else if (option == 'Plus2Weeks') {
                newDue = baseDate.addDays(14);
            } else {
                // CustomDays
                if (customDays == null || customDays < 1) {
                    throw new AuraHandledException('Custom days must be a positive number.');
                }
                newDue = baseDate.addDays(customDays);
            }

            t.ActivityDate = newDue;
            update t;

            // Return updated row and computed bucket (relative to "today")
            Task tAfter = [
                SELECT Id, Subject, Status, Priority, ActivityDate, OwnerId, Description, IsClosed
                FROM Task
                WHERE Id = :t.Id
                LIMIT 1
            ];

            Date today = Date.today();
            Date startOfWeek = getStartOfWeekMonday(today);
            Date endOfWeek = startOfWeek.addDays(6);
            Date endOfNextWeek = endOfWeek.addDays(7);

            String bucketKey = computeBucket(tAfter.ActivityDate, today, endOfWeek, endOfNextWeek);
            return new TaskRow(tAfter, bucketKey);
        } catch (AuraHandledException ahe) {
            // Re-throw handled exceptions without wrapping
            throw ahe;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in deferTask: ' + e.getMessage());
            throw new AuraHandledException('Unable to defer the task. Please try again.');
        }
    }

    // ===== Helpers =====

    // Sort by Priority desc (High first), then Due Date asc, then Subject asc
    private static void sortBucket(List<TaskRow> rows) {
        rows.sort(new TaskRowComparator());
    }

    private class TaskRowComparator implements Comparator<TaskRow> {
        public Integer compare(TaskRow a, TaskRow b) {
            // Priority order: High > Normal > Low > others
            Integer pa = priorityRank(a.priority);
            Integer pb = priorityRank(b.priority);
            if (pa != pb) return pb - pa; // higher rank first

            // Due date: nulls last
            if (a.dueDate == null && b.dueDate != null) return 1;
            if (a.dueDate != null && b.dueDate == null) return -1;
            if (a.dueDate != null && b.dueDate != null) {
                Integer d = Integer.valueOf(a.dueDate.daysBetween(b.dueDate));
                if (d != 0) return d; // earlier dates first
            }

            // Subject: nulls last, then lexicographic (case-insensitive)
            String sa = a.subject == null ? '' : a.subject.toLowerCase();
            String sb = b.subject == null ? '' : b.subject.toLowerCase();
            return sa.compareTo(sb);
        }

        private Integer priorityRank(String p) {
            if (p == 'High') return 3;
            if (p == 'Normal') return 2;
            if (p == 'Low') return 1;
            return 0;
        }
    }

    // Compute bucket based on due date versus today and week boundaries
    private static String computeBucket(Date due, Date today, Date endOfWeek, Date endOfNextWeek) {
        if (due == null) {
            return 'later'; // Null dates treated as later
        }
        if (due < today) return 'overdue';
        if (due == today) return 'today';
        if (due == today.addDays(1)) return 'tomorrow';
        if (due > today.addDays(1) && due <= endOfWeek) return 'thisWeek';
        if (due > endOfWeek && due <= endOfNextWeek) return 'nextWeek';
        return 'later';
    }

    // Monday as start of week helper
    private static Date getStartOfWeekMonday(Date d) {
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

    // Next Monday after a given date (at least +1 day)
    private static Date getNextMonday(Date d) {
        Integer isoDow;
        try {
            isoDow = Integer.valueOf(Datetime.newInstance(d.year(), d.month(), d.day(), 12, 0, 0).format('e')); // 1=Mon..7=Sun
        } catch (Exception ex) {
            isoDow = 1;
        }
        Integer daysUntilMonday = 8 - isoDow; // 7 when already Monday -> push a week
        if (daysUntilMonday == 0) daysUntilMonday = 7;
        return d.addDays(daysUntilMonday);
    }
}
