# Session-012_AsynchronousApex_ScheduledApex04

**Topic:** Salesforce Scheduled Apex – Part 4: Gotchas, Best Practices & Common Mistakes  
**Language:** Arabic

## 📌 What’s Covered:
- When to use System.scheduleBatch instead of Scheduled Apex class
- 100 job limit and paused job behavior
- Scheduling best practices and common mistakes
- Deployment blockers and how to avoid them
- Reminder about moving logic to helper classes
- Callouts in Scheduled Apex (must be async)
- What happens during sandbox refresh and maintenance windows
- Job state persistence and transient variables
- Job behavior when paused and resumed

## 📂 Resources:
---

## 📁 Folder Contents

| File Name                             | Description                                                             |
|--------------------------------------|-------------------------------------------------------------------------|
| `StateDemoScheduler.cls`             | Demo showing how to maintain state in a scheduled class (with state).   |
| `StatelessDemoScheduler.cls`         | Demo showing no state is retained (stateless example).                  |
| `apex_UsefulTemplates.code-snippets` | VS Code snippet to schedule Apex jobs quickly and cleanly.              |
| `Homework/`                          | Practice questions to reinforce learning with image-based exercises.    |

---

## 📝 Homework

Test yourself with two engaging practice sections:

### ✅ Part 1: True or False  
Images:  
- `AsyncHW_TrueFalse_001.png`  
- `AsyncHW_TrueFalse_002.png`

### 🎯 Part 2: Choose the Right Async Type  
Images:  
- `AsyncHW_Type_001.png`  
- `AsyncHW_Type_002.png`  
- `AsyncHW_Type_003.png`

These questions test your understanding of when to use Future, Queueable, Batch, or Scheduled Apex.

---

📺 Watch the full session here:  
https://youtu.be/KLVZZ8c_-Mw