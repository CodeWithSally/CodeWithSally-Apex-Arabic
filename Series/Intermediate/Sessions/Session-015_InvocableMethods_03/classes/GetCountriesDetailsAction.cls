public class GetCountriesDetailsAction {
    @InvocableMethod(label='Get Countries Details' description='Fetches details for a list of country names' category='_Custom Apex Actions')
    public static List<CountryDetailsResult> getCountriesDetails(List<CountryRequest> requests) {
        System.debug('====> Number of countries passed: '+requests.size());
        List<CountryDetailsResult> lstBulkifiedResult=new List<CountryDetailsResult>();
        
        // Loop through each input wrapper
        for(CountryRequest requestObj :requests){
            CountryDetailsResult resultDetails = new CountryDetailsResult();
            // Fetch API data for the list of country names
            resultDetails.details = getCountryDetails(requestObj.lstCountryNames);

            // Add result to final list
            lstBulkifiedResult.add(resultDetails);
        }
        return lstBulkifiedResult;
    }

    // Private helper method to fetch country details from API
    //private static List<CountryDetail> getCountryDetails(List<String> lstCountryNames) {
    private static List<SimplifiedCountryWrapper> getCountryDetails(List<String> lstCountryNames) {
        //List<CountryDetail> lstCountryDetails = new List<CountryDetail>();
        List<SimplifiedCountryWrapper> lstCountryDetails = new List<SimplifiedCountryWrapper>();
        if (lstCountryNames == null || lstCountryNames.isEmpty()) return lstCountryDetails;

        for (String countryName : lstCountryNames) {
            if (String.isBlank(countryName)) continue;

            try {
                // Use your utility directly
                List<CountryWrapper> countryValues = CountryCalloutUtility.getCountryByName(countryName);

                if (countryValues != null && !countryValues.isEmpty()) {
                    CountryWrapper countryWrapperObj = countryValues[0]; 

                    /*CountryDetail countryDetailsObj = new CountryDetail();
                    countryDetailsObj.capital 	  = (countryWrapperObj.capital != null && !countryWrapperObj.capital.isEmpty()) ? countryWrapperObj.capital[0] : null;
                    countryDetailsObj.region 	  = countryWrapperObj.region;
                    countryDetailsObj.flagUrl 	  = countryWrapperObj.flags.png;
                    countryDetailsObj.mapUrl 	  = countryWrapperObj.maps.googleMaps;   
                    countryDetailsObj.countryName = countryWrapperObj.name.common; */
                    SimplifiedCountryWrapper countryDetailsObj = new SimplifiedCountryWrapper(countryWrapperObj);  

                    lstCountryDetails.add(countryDetailsObj);
                } else {
                    /*CountryDetail countryDetailsObj = new CountryDetail();
                    countryDetailsObj.countryName = countryName;*/
                    SimplifiedCountryWrapper countryDetailsObj = new SimplifiedCountryWrapper(countryName);  
                    lstCountryDetails.add(countryDetailsObj);
                }
            } catch (Exception e) {
                /*CountryDetail countryDetailsObj = new CountryDetail();
                countryDetailsObj.countryName = countryName;*/
                SimplifiedCountryWrapper countryDetailsObj = new SimplifiedCountryWrapper(countryName);  
                lstCountryDetails.add(countryDetailsObj);
            }
        }
        return lstCountryDetails;
    }


    /////////Start Input and output wrappers/////////
    // Input wrapper 
    public class CountryRequest{
        @InvocableVariable(label='Country Names' required=true) 
        public List<String> lstCountryNames;
    }  

    public class CountryDetailsResult {
        @InvocableVariable(label='Countries')
        public List<SimplifiedCountryWrapper> details;
    }

    /*public class CountryDetail {
        @InvocableVariable public String countryName;
        @InvocableVariable public String region;
        @InvocableVariable public String capital;
        @InvocableVariable public String flagUrl;
        @InvocableVariable public String mapUrl;
    }*/
}