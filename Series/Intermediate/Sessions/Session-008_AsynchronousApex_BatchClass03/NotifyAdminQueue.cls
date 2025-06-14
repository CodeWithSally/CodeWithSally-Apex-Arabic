public class NotifyAdminQueue implements Queueable {
    public void execute(QueueableContext context) {
        System.debug('📬📬📬 Notification: Batch job completed!');
        // You can expand this to send an email or create a task.
    }
}