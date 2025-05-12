trigger CountryTrigger on Country__c (After insert) {
    switch on Trigger.operationType{
        when AFTER_INSERT {
            CountryTriggerHandler.onAfterInsert(Trigger.new,trigger.newMap);
        }
    }
}