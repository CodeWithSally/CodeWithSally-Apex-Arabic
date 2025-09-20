public with sharing class BrokerRatePromptAction {
    @InvocableMethod(
        label='Get Broker Commission Rate'
        description='Returns JSON with portfolio rollups and a commission rate based on Broker number of years at Dreamhouse.'
        capabilityType='PromptTemplateType://einstein_gpt__fieldCompletion'
    )
    public static List<Response> build(List<Request> requests) {
        
        Request requestObj = (requests == null || requests.isEmpty()) ? null : requests[0];
        if (requestObj == null || requestObj.RelatedEntity == null) {
            return new List<Response>{ new Response('{"error":"missing RelatedEntity"}') };
        }
        
        if (requestObj.RelatedEntity.Hire_Date__c != null) {
            // Commission by Years via CMDT
            Decimal rate = rateByYears(requestObj.RelatedEntity.Hire_Date__c);
            return new List<Response>{ new Response(rate.toString()+'%') };
        }

        return new List<Response>{ new Response('') };
    }

    ///////////////Start Private Helper Methods////////////
    private static Decimal rateByYears(Date hiringDate) {

        Date today = Date.today();
        Integer dreamHouseYears = 0;
        //raw year difference between today and the hiring year 
        Integer rawYearDifference = today.year() -hiringDate.year();

        //if the current month is before the hiring month, subtract 1 from the year difference
        if(today.toStartOfMonth() < hiringDate.toStartOfMonth()){
            rawYearDifference = rawYearDifference - 1;
        }

        //Ensure no negative years
        dreamHouseYears = Math.max(0,rawYearDifference);

        // get tiers, prefer the record with the largest MinYears__c <= years
        for (CommissionTier__mdt tierObj : CommissionTier__mdt.getAll().values()) {
            if((tierObj.MinYears__c<=dreamHouseYears && tierObj.MaxYears__c>=dreamHouseYears) ||
               (tierObj.MinYears__c<=dreamHouseYears && tierObj.MaxYears__c==null)){
                return (tierObj.RatePercent__c == null ? 3.00 : tierObj.RatePercent__c);
            }
        }
        return 3.00; // sensible default
    }
    ///////////////End Private Helper Methods////////////

    ////////////////Input and Output Wrapper Class/////////////
    public class Request {
        @InvocableVariable(required=true) 
        public Broker__c RelatedEntity;
    }
    public class Response {
        @InvocableVariable(required=true) 
        public String Prompt;

        public Response() {}
        public Response(String promptValue) { this.Prompt = promptValue; }
    }
}