public with sharing class PromptTemplateService {
    
    public static String invokePromptTemplate(String newVideoDescription,String newVideoTimestamps,String language,String mainTopic ){
        // =====================================================
        // Step1: Create an input object
        // =====================================================
        ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        executeTemplateInput.isPreview = false;  // false → actually call the LLM to generate a response

        // =====================================================
        // Step2: build input maps
        // =====================================================
        // Map to hold all inputs, where key = "Input:<apiName>"
        Map<String, ConnectApi.WrappedValue> inputs = new Map<String, ConnectApi.WrappedValue>();

        // --- Video Description ---
        ConnectApi.WrappedValue inputVideoDescription = new ConnectApi.WrappedValue();
        inputVideoDescription.value = (newVideoDescription == null ? '' : newVideoDescription);
        inputs.put('Input:newVideoDescription', inputVideoDescription);

        // --- Video Timestamps ---
        ConnectApi.WrappedValue inputTimestamps = new ConnectApi.WrappedValue();
        inputTimestamps.value = (newVideoTimestamps == null ? '' : newVideoTimestamps);
        inputs.put('Input:newVideoTimestamps', inputTimestamps);

        // --- Language (default = English) ---
        ConnectApi.WrappedValue inputLanguage = new ConnectApi.WrappedValue();
        inputLanguage.value = (String.isBlank(language)) ? 'English' : language;
        inputs.put('Input:language', inputLanguage);

        // --- main Topic (default = General) ---
        ConnectApi.WrappedValue inputMainTopic = new ConnectApi.WrappedValue();
        inputMainTopic.value = (mainTopic == null ? '' : mainTopic);
        inputs.put('Input:mainTopic', inputMainTopic);

        // Attach the input map
        executeTemplateInput.inputParams = inputs;

        // =====================================================
        // Step3: configure additional settings
        // =====================================================
        executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        executeTemplateInput.additionalConfig.applicationName = 'PromptTemplateGenerationsInvocable';//'PromptBuilderPreview';
        //Latest: Found PromptTemplateGenerationsInvocable in https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/connectapi_examples_resolve_prompt_template.htm
        //Other code samples online using : PromptBuilderPreview : https://developer.salesforce.com/blogs/2024/04/invoke-prompt-templates-from-flow-apex-or-the-rest-api


        // =====================================================
        // Step 4. Invoke the Prompt Template
        // =====================================================
        ConnectApi.EinsteinPromptTemplateGenerationsRepresentation executeTemplateOuput =
            ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                'CWS_Session_Pack_Generator_Enhanced',   // API Name of your Prompt Template , can use the Template ID
                executeTemplateInput //inputs
            );

        // ===============================================================
        // Step 5. Handle the resolution and response.
        // executeTemplateOuput.prompt --> will show us the resolved prompt
        // ================================================================
        // Validate response
        if (executeTemplateOuput == null || 
            executeTemplateOuput.generations == null || 
            executeTemplateOuput.generations.isEmpty()
        ) {
            Throw new CustomException ('Prompt returned no generations.');
        }

        // Success → extract the first generated response text
        return executeTemplateOuput.generations[0].text;
    }
}