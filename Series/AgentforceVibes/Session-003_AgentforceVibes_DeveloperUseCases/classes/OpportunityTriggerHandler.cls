public class OpportunityTriggerHandler {

    public static void onBeforeInsert(List<Opportunity> lstNewOpportunities) {
        for (Opportunity opp : lstNewOpportunities) {
            if (opp.StageName == null) {
                opp.StageName = 'Prospecting';
            }
            if (String.isBlank(opp.Description)) {
                opp.Description = 'New opportunity created — description pending.';
            }
        }
    }

    public static void onBeforeUpdate(List<Opportunity> lstNewOpportunities, Map<Id, Opportunity> mapOldOpportunities) {
        for (Opportunity opp : lstNewOpportunities) {
            Opportunity oldOpp = mapOldOpportunities.get(opp.Id);
            if (oldOpp.StageName != opp.StageName && opp.StageName == 'Closed Won') {
                opp.Description = '🎉 Deal closed successfully!';
            }
        }
    }
}