public with sharing class CountryCalloutUtility {

    // Main method to retrieve country data by name
    public static List<CountryWrapper> getCountryByName(String countryName) {
        // Create a new HTTP request
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        // Set the REST endpoint with encoded country name
        req.setEndpoint('https://restcountries.com/v3.1/name/' + EncodingUtil.urlEncode(countryName, 'UTF-8'));
        req.setMethod('GET');

        // Send the HTTP request
        HttpResponse res = http.send(req);

        // If the API call is successful, parse the response JSON
        if (res.getStatusCode() == 200) {
            return CountryWrapper.parseApiResponse(res.getBody());
        } else {
            // If status code is not 200, log the status for debugging
            System.debug('Failed to fetch country data. Status: ' + res.getStatus());
            return null;
        }
    }
}