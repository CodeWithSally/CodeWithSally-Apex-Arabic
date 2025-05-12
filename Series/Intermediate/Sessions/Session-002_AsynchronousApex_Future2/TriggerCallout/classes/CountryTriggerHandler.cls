public with sharing class CountryTriggerHandler {
    public static void onAfterInsert(List<Country__c> newCountries,Map<Id,Country__c> mapCountries) {
        updateCountriesDetails(mapCountries.keySet());
    }

    @future(callout=true)
    public static void updateCountriesDetails(Set<Id> setCountryIds){
        List<Country__c> lstCountriesToUpdate=[Select Capital__c,Region__c,Name,FlagURL__c,mapURL__c FROM Country__c where id in :setCountryIds];
        for(Country__c countryObj : lstCountriesToUpdate){
            List<CountryWrapper> lstCountries = CountryCalloutUtility.getCountryByName(countryObj.Name);
            if(!lstCountries.isEmpty()){
                countryObj.Capital__c = lstCountries[0].capital[0];
                countryObj.Region__c = lstCountries[0].region;
                countryObj.FlagURL__c = lstCountries[0].flags.png;
                countryObj.mapURL__C = lstCountries[0].maps.googleMaps;
            } 
        }
        update lstCountriesToUpdate;
    }
}