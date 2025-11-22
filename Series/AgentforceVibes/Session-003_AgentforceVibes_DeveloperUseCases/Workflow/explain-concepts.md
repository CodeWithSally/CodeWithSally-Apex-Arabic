# Workflow: learn-or-compare-apex-concepts
description: A guided workflow to help understand or compare Apex concepts through explanation, examples, best practices, and test class creation.

Use the Salesforce DX MCP server tools first and only fall back to `sf` if the MCP service is unavailable.

<detailed_sequence_of_steps>

Perform the steps below in the following order.

## 1. ask_followup_question:
What concept do you want to learn about?  
(Example: static methods, instance methods, triggers, interfaces, etc.)

## 2. ask_followup_question:
Is this a comparison between two concepts, or do you want to focus on a single one?  
(Example: Compare static vs non-static methods.)

## 3. run_action:
If the user chose one concept, explain it in simple terms with examples and Apex code samples, including inline comments.

## 4. run_action:
If the user chose two concepts, explain the difference between both in Apex.  
Tell when to use each one.  
Provide an Apex example for each concept with clear comments to understand the logic.

## 5. run_action:
Describe the best practices for each concept and common mistakes to avoid.

## 6. run_action:
Show how to write unit test methods for each example inside a proper Apex test class, using @isTest annotation and the Assert class.

## 7. run_action:
Generate a beginner-friendly summary of everything explained above (key takeaways, use cases, and examples).

## 8. run_action:
Create a new Markdown file with a meaningful file name with the generated explanation, code examples, and summary and store it in folder called `Learning Materials`

</detailed_sequence_of_steps>