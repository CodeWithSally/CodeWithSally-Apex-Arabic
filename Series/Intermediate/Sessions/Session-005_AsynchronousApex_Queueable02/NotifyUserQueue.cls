public class NotifyUserQueue implements Queueable {
    public void execute(QueueableContext context) {
        // Log this job’s own ID
        System.debug('📢 Child Job ID: ' + context.getJobId());
        
        System.debug('📢 NotifyUserQueue running — notify owner or send email...');
        // This could be sending notifications, emails, etc.
    }
}
