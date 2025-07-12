public class StateDemoScheduler implements Schedulable {
    public Integer runCount = 0; // persistent variable

    public void execute(SchedulableContext sc) {
        runCount++;
        System.debug('🔁 This is execution #' + runCount);
    }
}
