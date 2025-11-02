# Task Manager (LWC) — Requirements for Vibes

## Goal
Our Salesforce users feel the standard task management experience is too clunky and not visually appealing. We want to build a new **custom task manager** that feels clean, simple, and efficient. To reach that goal, build a Lightning Web Component named `taskManager` for the Salesforce **Home** page that lists **open** tasks for the current user in a compact UI, grouped by due date, with quick actions to **defer to tomorrow** and **complete**.

## What We Want
- It should be a **Lightning Web Component (LWC)**.
- It should appear on the **Home tab**.
- It should display all **open tasks** for the current logged-in user.
- The tasks should be shown in a **compact list**, grouped by **due date**:
  - Overdue
  - Today
  - Tomorrow
  - This week
  - Next week
  - Later

## Definitions
- **Open Task:** `Status != 'Completed'`
- **Fields (API names) to display:**
  - Subject (`Subject`)
  - Priority (`Priority`)
  - Due Date (`ActivityDate`)
- **Grouping rules** (assume the org’s timezone):
  - **Overdue:** `ActivityDate < TODAY`
  - **Today:** `ActivityDate = TODAY`
  - **Tomorrow:** `ActivityDate = TODAY + 1`
  - **This Week:** `ActivityDate` is within the **current calendar week** (Mon–Sun) and **after Tomorrow**
  - **Next Week:** `ActivityDate` is within the **next calendar week** (Mon–Sun)
  - **Later:** `ActivityDate` > end of Next Week **or** `ActivityDate = null` (treat null as Later)

## Backend Requirement (Apex code)
- **Class Name:** `TaskManagerApexController`
  - **Method:** `getTasks` (will be used by the `taskManager` LWC — **not cached**)
    - **Return type:** `Map<String, List<Task>>`
    - **Logic:**
      - Query all tasks that are open and assigned to the current running user.
      - Group tasks by the strings: **Overdue**, **Today**, **Tomorrow**, **This Week**, **Next Week**, **Later**.
  - **Method:** `closeTask` (will be used by the `taskManager` LWC — **not cached**)
    - **Parameter:** `Id` of a Task
    - **Return type:** `Boolean` indicating success
    - **Logic:**
      - Create a `Task` record, set its `Id` to the passed task Id.
      - Set the task **Status** to `Completed` and update it.
      - If successful, return `true`.
  - **Method:** `deferTask` (will be used by the `taskManager` LWC — **not cached**)
    - **Parameter:** `Id` of a Task
    - **Return type:** `Boolean` indicating success
    - **Logic:**
      - Update the task **ActivityDate** to `ActivityDate + 1 day`.
      - If successful, return `true`.

## LWC Component Requirement
- Create a new LWC component named `taskManager`.
- Each row shows: **Subject**, **Priority**, **Due Date**.
- Two `lightning-button-icon` actions per row:
  - **Defer** → sets `ActivityDate = ActivityDate + 1` (the row should move to the appropriate section based on the new `ActivityDate`).
  - **Complete** → sets `Status = 'Completed'` (the row disappears immediately).
- Use native Salesforce LWC base components.
- Prefer Salesforce **SLDS** classes before custom CSS.
- If a section has no tasks, show a friendly message indicating no tasks are available in that category.

## Apex Script Requirement
- Create a new `generate_test_tasks.apex` file inside the `scripts` folder.
- The purpose of this script file is to run it anonymously.
- **Logic:**
  1. Delete existing tasks in the org.
  2. Create **at least 3 tasks per category** shown in the UI: **Overdue**, **Today**, **Tomorrow**, **This Week**, **Next Week**, **Later**.

## Phases (Plan → Act)
- **Phase 1 (UI Prototype):** Build `taskManager` with mocked data to finalize the UI.
- **Phase 2 (Apex Controller):** Create the `TaskManagerApexController` class and implement its logic.
- **Phase 3 (Tests):** Create `TaskManagerApexControllerTest` covering all logic using the `Assert` class.
- **Phase 4 (Live Test Prep):** Create the script file `generate_test_tasks.apex`.
- **Phase 5 (Client Logic):** Update the LWC JavaScript to remove mocked data and use the `TaskManagerApexController` methods. Ensure loading, deferring, and completing tasks work end-to-end; keep code clean with concise comments; show toast confirmations and error toasts as needed.

## Acceptance Criteria
- Component deploys and renders on the Home page.
- Groups appear in the specified order with correct membership.
- Actions move/clear rows immediately; server confirms success.
- Tests cover positive, negative, and bulk cases; use `Assert` class methods.
- Demo scripts create tasks that populate all groups.