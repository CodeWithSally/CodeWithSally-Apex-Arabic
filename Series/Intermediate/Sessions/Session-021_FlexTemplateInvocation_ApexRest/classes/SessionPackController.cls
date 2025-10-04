// Controller class to generate a Session Pack using an Einstein Prompt Template
public with sharing class SessionPackController {

    // Exposed method callable from LWC component
    @AuraEnabled 
    public static SessionPackResponse generate(String newVideoDescription,String newVideoTimestamps,String language, String mainTopic ) {
        // Response wrapper object (will hold either JSON or an error message)
        SessionPackResponse sessionPackResponseObj = new SessionPackResponse();

        try {
            sessionPackResponseObj.json = PromptTemplateService.invokePromptTemplate(newVideoDescription, newVideoTimestamps, language, mainTopic);
            return sessionPackResponseObj;
        } catch (Exception e) {
            // Handle any error gracefully
            sessionPackResponseObj.error = 'Failed to invoke prompt template: ' + e.getMessage();
            return sessionPackResponseObj;
        }
    }

    // =========================================================
    // Response Wrapper Class
    // =========================================================
    public class SessionPackResponse {
        @AuraEnabled public String json;   // JSON from the prompt (output)
        @AuraEnabled public String error;  // Error message (if any)
    }
}
