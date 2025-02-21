trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{
            ContactTriggerHandler.onBeforeInsert(trigger.new);
        }
        when AFTER_INSERT{
            ContactTriggerHandler.onAfterInsert(trigger.new);
        }
        when BEFORE_UPDATE{
            ContactTriggerHandler.onBeforeUpdate(trigger.old,trigger.oldMap,trigger.new,trigger.newMap);
        }
        when AFTER_UPDATE{
            ContactTriggerHandler.onAfterUpdate(trigger.old,trigger.oldMap,trigger.new,trigger.newMap);
        }
    }
}