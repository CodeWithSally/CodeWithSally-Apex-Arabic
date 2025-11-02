# Rule: Code With Sally Apex Script Best Practices

**Description:** Enforce best practices and formatting standards for Apex script files used in the Developer Console or anonymous execution.

**Applies to:** `**/*.apex`

**Guidelines:**
- Write scripts that can be executed **directly in the Developer Console** (no class or method wrapper).
- Include a short header comment describing the purpose of the script.
- Add short inline comments for clarity and readability.
- Use clear and descriptive variable names.
- Always delete or filter data safely — avoid deleting unrelated records.
- When inserting sample or demo data, ensure at least one record per required category or scenario.
- Use `System.debug()` for key checkpoints or success messages.
- Keep scripts concise — no unnecessary classes, methods, or logic wrapping.
- Prefer `Date.today().addDays()` for relative dates rather than hardcoding.
- Query or DML only what is needed; avoid SOQL or DML inside loops.
- When referencing the current user, use `UserInfo.getUserId()` instead of hardcoding IDs.
- Make sure scripts are **idempotent** (can safely run multiple times without breaking data).

**Example:**
```apex
// Simple data seeding script for testing custom component behavior
Id currentUserId = UserInfo.getUserId();
List<Task> existingTasks = [SELECT Id FROM Task WHERE OwnerId = :currentUserId];
if (!existingTasks.isEmpty()) delete existingTasks;

List<Task> tasks = new List<Task>{
    new Task(Subject='Demo Task', Priority='Normal', ActivityDate=Date.today(), OwnerId=currentUserId, Status='Open')
};
insert tasks;

System.debug('Created demo task successfully.');
```
