trigger OpportunityTrigger on Opportunity (before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            OpportunityTriggerHandler.onBeforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            OpportunityTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}