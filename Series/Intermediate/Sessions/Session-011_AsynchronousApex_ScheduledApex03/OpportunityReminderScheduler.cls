public class OpportunityReminderScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        OpportunityReminderService.runReminderLogic();
    }
}
