# 🚀 Session 014 - Invocable Methods (Part 2) - Arabic

📺 **Watch the session on YouTube**: [https://youtu.be/mueKfjmjjzI](https://youtu.be/mueKfjmjjzI)

This session builds on our previous Arabic session about Invocable Methods and covers:

- Passing **single values**, **lists**, and **custom wrapper classes** from Flow to Apex
- Writing **unit tests** for invocable methods
- Preparing for a **homework challenge** to build a screen flow that uses wrapper classes

---

## 📁 File Overview & Usage

### `classes/`

| File                             | Purpose                                                                 |
|----------------------------------|-------------------------------------------------------------------------|
| `AssignCaseCategoryAction.cls`   | Invocable method that accepts a **single record Id** and performs logic (used in record-triggered flow). |
| `AssignCaseCategoryActionTest.cls` | Unit test for `AssignCaseCategoryAction.cls` — covers bulk behavior and asserts logic. |
| `TestingFlowAction.cls`          | Invocable method to test different **input parameter types**, including List and wrapper classes. |
| `CustomFlowInputWrapper.cls`     | Example of a custom wrapper class passed from Flow to Apex. |

---

## 🧪 Homework Suggestions

- Write your own test class for `AssignCaseCategoryAction.cls` and compare it with the provided `AssignCaseCategoryActionTest.cls`.
- Modify `TestingFlowAction.cls` and try creating your own wrapper inputs.
- Create a screen flow that passes a list of wrapper classes to Apex and handles the logic cleanly.
- Review how to use `@InvocableMethod` and `@InvocableVariable` to make your methods and variables accessible to Flow.

---

## 🔗 Useful Links

- Yalla Salesforce Channel: https://www.youtube.com/@YallaSalesforce  
- Part 1 (Arabic): [Watch here](https://www.youtube.com/watch?v=-U1nJzlmf9U)    
- Agentforce Now: https://developer.salesforce.com/agentforce-now

---

📅 **Next Session**: August 22 — we’ll build the full screen flow using the wrapper class and implement the full challenge together.

🧠 Don’t forget to subscribe and practice the concepts with the demo files!