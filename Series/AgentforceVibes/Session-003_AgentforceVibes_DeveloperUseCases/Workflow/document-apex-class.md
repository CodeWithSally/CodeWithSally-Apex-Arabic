# Workflow: document-apex-class
description: Generate detailed Markdown documentation for one or more Apex classes, including explanations, parameter details, method analysis, and example usage.

<detailed_sequence_of_steps>

Perform the steps below in order.

## 1. Ask which class or classes to document
<ask_followup_question>
<question>Which Apex class or classes would you like me to document? 
(Example: @/force-app/main/default/classes/PromptTemplateService.cls or multiple separated by commas)</question>
</ask_followup_question>

If user specify more than one class ask the following followup question. If not, skip it
<ask_followup_question>
<question>Would you like to: Generate a single combined Markdown file for all selected classes, or Create a separate Markdown file for each class?</question>
<options>["A single Markdown file", "Create a separate Markdown file for each class"]</options>
</ask_followup_question>

## 2. For each selected class:
- Read the class file(s) to understand their structure and content.
- Generate a detailed explanation in beginner-friendly language, covering:
  - A high-level summary of what the class is used for and when it’s typically needed.
  - For each method in the class:
    - What the method does and why it’s used.
    - Parameters and their purpose.
    - Return type and what is returned.
    - Any exceptions or special handling.
    - Best practices or tips for using it.
  - Then explain how each method works internally, line by line, in clear, simple terms.
  - Include short examples showing how one or two key methods might be called in Apex code.

## 3. Format the result as a Markdown file
- Include clear Markdown structure with headings, bullet points, and code blocks.

## 4. Save the generated documentation
- Create a folder called `Documentation` to store those md files in
- If user chose a single combined file:
  - Combine all class outputs into one Markdown file named:
    `ApexClasses_Documentation_<timestamp>.md`
- If user chose multiple files:
  - Save each class separately using:
    `<ClassName>_Documentation.md`

</detailed_sequence_of_steps>