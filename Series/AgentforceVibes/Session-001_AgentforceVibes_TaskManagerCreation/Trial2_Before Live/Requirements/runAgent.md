# 🧭 Agentforce Vibes Task

We’re building a **custom Salesforce Task Manager** as a Lightning Web Component.

Please read the full requirements in this file:
📄 `@/Extra_VibeCoding/TaskManagementVibe.md`
 
---

## 🔍 Context Files
You can also use the following context files for reference:
- 🗂️ `@/scripts/apex`  → contains Apex scripts, use it to create `generate_test_tasks.apex` for creating demo data.  
- 🧱 `@/.sfdx/tools/sobjects/standardObjects/Task.cls`  → describes the standard Task object and their API names.  
- 🖼️ `@/Extra_VibeCoding/standard-sf-task-creation-screen.png`  → shows the standard Salesforce Task creation screen for reference on required fields.

Make sure these files are recognized in your workspace before starting.

---

## 💡 How to Work
We will proceed **phase by phase** as described in the requirements:
1. **Phase 1:** Understand and plan the implementation.
2. **Phase 2:** Create the UI prototype (mock data only).
3. **Phase 3:** Add the Apex controller and logic.
4. **Phase 4:** Write test classes.
5. **Phase 5:** Add or verify the demo script file under `/scripts`.
6. **Phase 6:** Connect LWC to Apex, clean up, and finalize with toast messages and comments.

At each phase:
- Output your plan and generated code separately.
- Include clear explanations and concise inline comments.
- Use Lightning base components and SLDS classes before custom CSS.

---

## ✅ Expectations
- The component name must be `taskManager`.
- The Apex class name must be `TaskManagerApexController`.
- The UI should group open tasks by due date (Overdue, Today, Tomorrow, This Week, Next Week, Later).
- Defer and Complete actions should behave as described in the requirements.
- Follow best practices for Apex, LWC JS, LWC HTML, and Meta files.
- Code should be clean, readable, and production-ready for demo.

---

Let’s begin with **Phase 1: Plan** — summarize the steps you’ll take to build this feature before coding.