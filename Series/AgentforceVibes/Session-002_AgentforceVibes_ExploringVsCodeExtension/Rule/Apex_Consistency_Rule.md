# Rule: Apex Consistency Rule

**Description:** Maintain clean, safe, and well-documented Apex code.

**Applies to:** `**/*.cls`


**Guidelines:**
- Always include try/catch blocks when performing operations that might fail.
- Add clear comments explaining method purpose and inputs.
- Use PascalCase for class names and camelCase for variables and methods.
- Test class names should end with 'Test'.
- For Apex collections, start list variables with `lst` (for example: `lstCountries`), for maps start with `map` (for example: `mapAccountDetails`), and for sets start with `set` (for example: `setIds`).