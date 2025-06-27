public with sharing class CalloutAsyncInsideScheduledApex implements Schedulable{
    public void execute(SchedulableContext sc) {
        makeHttpCallout();
    }

    @future(callout=true)
    public static void makeHttpCallout(){
        // Create a new HTTP request
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        // Set the REST endpoint with encoded country name
        req.setEndpoint('https://restcountries.com/v3.1/name/' + EncodingUtil.urlEncode('Canada', 'UTF-8'));
        req.setMethod('GET');

        // Set timeout to 10 seconds (default is 10, max is 120,000 milliseconds)
        //req.setTimeout(10000);

        // 🚨 This will fail at runtime with a callout exception
        HttpResponse res = http.send(req);
        System.debug('check res: '+res.getBody());
    }
}