public with sharing class PropertySimilarSalesEmailAction {

    @InvocableMethod(
        label='Similar Properties for Sales Email'
        description='Returns JSON with main property + up to 3 similar properties for sales email prompts.'
        capabilityType='PromptTemplateType://einstein_gpt__salesEmail'
    )
    public static List<Response> getSimilarProperties(List<Request> requests) {
        // Only one request at a time for Sales Email, but still bulk-safe
        Request requestObj = (requests == null || requests.isEmpty()) ? null : requests[0];

        // Default ResponseDetails
        ResponseDetails responseDetailsObj = new ResponseDetails();

        if (requestObj != null && requestObj.relatedObject != null) {
            // Find similar properties
            List<Property__c> lstSimilarProperties = findSimilarProperties(requestObj.relatedObject);

            for (Property__c similarPropertyObj : lstSimilarProperties) {
                responseDetailsObj.similars.add(new PropertyDetails(similarPropertyObj));
            }
        }

        // Always return valid JSON, even if no similars
        String jsonOutput = JSON.serialize(responseDetailsObj);
        return new List<Response>{ new Response(jsonOutput) };
    }

    /************************** Start Helper Methods *****************************************/
    private static List<Property__c> findSimilarProperties(Property__c mainPropertyObj) {
        String propertyId = mainPropertyObj.Id;
        String propertyCity = mainPropertyObj.City__c;

        List<String> whereParts = new List<String>{
            'Id != :propertyId',
            'Status__c = \'Available\''
        };

        // City
        if (!String.isBlank(mainPropertyObj.City__c)) {
            whereParts.add('City__c = :propertyCity');
        }

        // Beds & Baths (+/- 1 tolerance)
        /*Integer beds  = (mainPropertyObj.Beds__c  == null) ? null : Integer.valueOf(mainPropertyObj.Beds__c);
        Integer minBeds  = (beds  == null) ? null : beds  - 1;
        Integer maxBeds  = (beds  == null) ? null : beds  + 1;
        if (beds != null) {
            whereParts.add('Beds__c >= :minBeds AND Beds__c <= :maxBeds');
        }*/

        /*Integer baths = (mainPropertyObj.Baths__c == null) ? null : Integer.valueOf(mainPropertyObj.Baths__c);
        Integer minBaths = (baths == null) ? null : baths - 1;
        Integer maxBaths = (baths == null) ? null : baths + 1;
        if (baths != null) {
            whereParts.add('Baths__c >= :minBaths AND Baths__c <= :maxBaths');
        }

        // Price (+/- 20%)
        Decimal price = mainPropertyObj.Price__c;
        Decimal low   = (price == null) ? null : price * 0.8;
        Decimal high  = (price == null) ? null : price * 1.2;
        if (price != null) {
            whereParts.add('Price__c >= :low AND Price__c <= :high');
        }*/

        // Final SOQL
        String soql =
            'SELECT Name, City__c, Beds__c, Baths__c, Price__c, Picture__c, Status__c ' +
            'FROM Property__c WHERE ' + String.join(whereParts, ' AND ') +
            ' Order by Price__c asc LIMIT 10';

        return Database.query(soql);
    }
    /************************** End Helper Methods *****************************************/

    /****** ----------- Start Prompt Template Input and Output ----------------------- ***/
    public class Request {
        @InvocableVariable 
        public User Sender;      

        @InvocableVariable 
        public Contact Recipient;       

        @InvocableVariable 
        public Property__c RelatedObject;   // The selected property
    }

    public class Response {
        @InvocableVariable(required=true) 
        public String Prompt; // JSON output

        public Response(String p) { this.prompt = p; }
    }
    /****** ----------- End Prompt Template Input and Output --------------------------- ***/

   /****** ----------- Start Response Details Wrapper Class ----------------------- ***/
    public class ResponseDetails {
        public List<PropertyDetails> similars = new List<PropertyDetails>();
    }

    public class PropertyDetails {
        public Id      id;
        public String  name;
        public String  city;
        public Integer beds;
        public Integer baths;
        public Decimal price;
        public String  pictureUrl;

        public PropertyDetails(Property__c propertyObj){
            this.id         = propertyObj.Id;
            this.name       = propertyObj.Name;
            this.city       = propertyObj.City__c;
            this.beds       = (propertyObj.Beds__c == null) ? null : Integer.valueOf(propertyObj.Beds__c);
            this.baths      = (propertyObj.Baths__c == null) ? null : Integer.valueOf(propertyObj.Baths__c);
            this.price      = propertyObj.Price__c;
            this.pictureUrl = propertyObj.Picture__c;
        }
    }
    /****** ----------- End Response Details Wrapper Class ----------------------- ***/
}