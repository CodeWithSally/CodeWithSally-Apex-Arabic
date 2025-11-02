# Rule: Code With Sally LWC JavaScript Best Practices

**Description:** Enforce best practices and naming and formatting standards for LWC JavaScript code.

**Applies to:** `**/*.js` 

**Guidelines:**
- Add inline comments to keep code clear, clean, and easy to understand.
- Method names must be camelCase (For example: `handleButtonClick` or `fetchRecords`).
- Constants must be UPPER_SNAKE_CASE (For example: `DEFAULT_PAGE_SIZE` or `MAX_RETRY_COUNT`).
- Variable names must be camelCase and descriptive (For example: `arrAccounts` or `isClosed`).
- Avoid abbreviations and single-letter variables (For example: `account`, not `acc`; `taskObj`, not `t`).
- Boolean variable names should start with `is`, `has`, or `can` (For example: `isActive` or `hasAccess`).

- Whenever you use try/catch blocks, if the user did not specify how to handle the exception, at minimum log the error in the console and show a toast message. Do not leave the catch block empty.
- Whenever it makes sense, get user confirmation before performing an action triggered by a button click.
- Whenever it makes sense, show a toast message after a user action to confirm that it was performed successfully or to display an error.

- Use `@wire` only for Apex methods annotated with `@AuraEnabled(cacheable=true)`.