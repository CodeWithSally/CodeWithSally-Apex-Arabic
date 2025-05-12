// This class fakes an HTTP response so we can test our callout logic
// It implements the HttpCalloutMock interface which is required in Salesforce tests
public class CountryMockResponse implements HttpCalloutMock {

    // This method is automatically called when a test makes an HTTP request
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake HTTP response
        HttpResponse res = new HttpResponse();

        // Set response headers
        res.setHeader('Content-Type', 'application/json');

        // Set response status to 200 OK (like a successful real API)
        res.setStatusCode(200);

        // Set the response body to a sample JSON representing country info (Canada in this case)
        res.setBody(
            '[{' +
            '"name":{"common":"Canada","official":"Canada"},' +
            '"capital":["Ottawa"],' +
            '"region":"Americas",' +
            '"currencies":{"CAD":{"name":"Canadian dollar","symbol":"$"}},' +
            '"languages":{"eng":"English","fra":"French"},' +
            '"translations":{"ara":{"common":"كندا"},"fra":{"common":"Canada"}},' +
            '"maps":{"googleMaps":"https://goo.gl/maps/jmEVLugreeqiZXxbA"},' +
            '"flags":{"png":"https://flagcdn.com/w320/ca.png"}' +
            '}]'
        );

        // Return the fake response to be used in the test
        return res;
    }
}
