Use the Salesforce DX MCP server tools first and only fall back to `sf` if the MCP service is unavailable. Create an Apex class, generate a test class, deploy them, and run tests — all in one go.

<detailed_sequence_of_steps>
Perform the steps below in the following order.

  ## 1. ask_followup_question: 
      What should be the logic of the new Apex class?
  ## 2. ask_followup_question: 
      What should we name the new Apex class?
  ## 3. run_action: 
      Generate the Apex class with its meta file
  ## 4. run_action: 
      Generate a test class this new class and create its meta file.
  ## 5. run_action: 
      Deploy both classes to the default org.
  ## 6. run_action: 
      Run Apex tests for the testing class using the Salesforce CLI command:
      sf apex test run --target-org default --class-names {testingClassName}Test --result-format human
</detailed_sequence_of_steps>