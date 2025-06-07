public class FailingBatchDemo implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name FROM Opportunity WHERE Name LIKE \'DemoSally %\'');
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        for (Opportunity o : scope) {
            if (o.Name.contains('DemoSally 650')) {
                // Simulate a crash in the 2nd chunk
                throw new CodeWithSallyException('💥 Simulated crash on purpose in chunck 4');
            } else {
                o.StageName = 'Closed Won';
            }
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('🎉 All done!');
    }
}
