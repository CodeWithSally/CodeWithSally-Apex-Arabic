# Rule: Code With Sally Apex Best Practices

**Description:** Enforce some best practices and naming and formatting standards for Apex code

**Applies to:** `**/*.cls` and `**/*.trigger`.

**Guidelines:**
- Add short inline comments to keep code well documented and easy to understand.
- Class names must be PascalCase (For example: `AccountService`).
- Method names must be camelCase (For example: `calculateTotalAmount` or `getActiveAccounts`).
- Constants must be UPPER_SNAKE_CASE (For example: `MAX_RECORDS_LIMIT` or `DEFAULT_TAX_RATE`).

- Variable names must be camelCase and descriptive (For example: `lstAccounts` or `isClosed`).
- **No single-letter names** for variables, parameters, or fields.  
  - ✅ Allowed only for tiny loop indices in very small scopes: `for (Integer i = 0; …)`  
  - ❌ Not allowed elsewhere (e.g., `Task t`, `Integer d`, `String p`, `TaskRow a`).
  - Use descriptive alternatives: `taskRecord`, `daysDifference`, `priorityValue`, `leftRow`, `rightRow`.
- Avoid abbreviations (For example: `account`, not `acc`).
- Boolean variable names should start with `is`, `has`, or `can` (For example: `isActive` or `hasAccess`).
- For Apex collections, start list variables with `lst` (for example: `lstCountries`), for maps start with `map` (for example: `mapAccountDetails`), and for sets start with `set` (for example: `setIds`).

- Avoid SOQL or DML inside `for` loops. Use Maps and Sets to bulkify logic.
- Avoid returning SOQL results into a single sObject to prevent the error `System.QueryException: List has no rows for assignment to SObject`. Always return a list, then check if the list is empty before accessing records.

- Test classes must use PascalCase and end with `Test` (For example: `AccountServiceTest`).
- Test method names should describe the test scenario clearly (For example: `testCalculateTax_WithValidInput`).
- When writing asserts, always use the `Assert` class instead of the `System` class (For example: `Assert.areEqual`, not `System.assertEquals`).
- For Test Classes, use `Test.startTest()` and `Test.stopTest()` around code being tested.
- For Test Classes, use `@testSetup` or Test Data Factory to prepare test data.
- For Test Classes, include both positive and negative test scenarios.

- Whenever you have try and catch blocks, if the user did not specify how to handle the exception, at minimum write the error in the debug log. Do not leave the catch block empty.
