public class StatelessDemoScheduler implements Schedulable {
    transient public Integer runCount;

    public void execute(SchedulableContext sc) {
        if (runCount == null) {
            runCount = 0;
        }        
        
        runCount++;
        System.debug('🔁 StatelessDemoScheduler : This is execution #' + runCount);
    }
}
