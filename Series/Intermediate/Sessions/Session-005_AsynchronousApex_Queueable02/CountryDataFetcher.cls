public class CountryDataFetcher implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://restcountries.com/v3.1/name/France');
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }
}
