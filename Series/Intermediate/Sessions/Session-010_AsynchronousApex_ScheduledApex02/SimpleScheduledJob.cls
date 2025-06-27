/*
 This is a simple example of a Scheduled Apex class
 It runs based on a schedule you define later using 
 System.schedule() or the UI
*/
public class SimpleScheduledJob implements Schedulable {

    // This method is required when you implement the Schedulable interface
    // Salesforce will run this method when the job is triggered
    public void execute(SchedulableContext sc) {
        
        // This is just a sample action – printing a message to the debug log
        System.debug('📅 SimpleScheduledJob is running!');
    }
}

/*
To Manually test the logic before scheduling it,
you can run the following code in developer console

// Create an instance of your scheduled class
SimpleScheduledJob job = new SimpleScheduledJob();

// Call the execute method manually with a null SchedulableContext
job.execute(null);
*/
