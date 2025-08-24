public class SimplifiedCountryWrapper {

    @InvocableVariable @AuraEnabled public string capital;
    @InvocableVariable @AuraEnabled public string region;
    @InvocableVariable @AuraEnabled public string flagUrl;
    @InvocableVariable @AuraEnabled public string mapUrl;
    @InvocableVariable @AuraEnabled public string countryName;
    
    public SimplifiedCountryWrapper(CountryWrapper c){
        this.capital 	 = (c.capital != null && !c.capital.isEmpty()) ? c.capital[0] : null;
        this.region 	 = c.region;
        this.flagUrl 	 = c.flags.png;
        this.mapUrl 	 = c.maps.googleMaps;   
        this.countryName = c.name.common;   
    }

    public SimplifiedCountryWrapper(String countryName){
        this.countryName = countryName;   
    }
}