# Requirements

## Use Case
Our Salesforce users have complained that the native Salesforce task management component is ugly and inefficient.  They have asked us to create a custom component that should address the following requirements:
- Should be implemented as a Lightning Web Component (LWC)
- Should be available on the Salesforce home tab
- Any open tasks for the current logged in user should be displayed in a compact and concise list
- Each task record "row" should:
	- include the task subject, priority, and due date
	- include two button icons, one to update the due date to tomorrow and one to complete the task
- Records should be grouped by due date with the following groupings:
	- Overdue
	- Today
	- Tomorrow
    - This week
	- Next week
	- Later

## Implementation
Should be completed in the following phases:

### Phase 1 - Requirements Review
Ask clarifying questions to make sure you understand the requirements.


### Phase 2 - UI Prototyping
- Component Name: taskManager
- Create a prototype of a lightning web component that shows some sample records so that we can iterate on the design.
- Use native salesforce components whenever possible (i.e. lightning-button-icon, etc).
- For styling, preference should be given to slds classes before custom implementation of CSS classes

### Phase 3: Implement apex controller logic
- Class Name: TaskManagerApexController
	- Method: getTasks
		- Return type: Map with String as key and List of Tasks as value
		- Logic:
			- Query all tasks that are open and assigned to the current running user
			- Tasks should be grouped by the following strings: Overdue, Today, Tomorrow, This Week, Next Week, Later
	- Method: closeTask
		- Parameter: Id of a Task
		- Return type: Boolean indicating success
		- Logic:
			- Query the task associated to the passed in Id
            - Set the task statue to Completed
			- If successful, return true
	- Method: deferTask 
		- Paramter: Id of a Task
		- Return type: Boolean indicating success
		- Logic:
			- Query the task associated to the passed in Id
			- Update the task due date to tomorrow
			- If successful, return true

#### Phase 3A: Create the class and methods stubs so that the methods can be referenced in LWC and test classes
#### Phase 3B: Implement logic

### Phase 4: Test Class
- Class Name: TaskManagerApexControllerTest
- Requirements:
	- Create test methods to cover all logic implemented as part of Phase 3
	- Use only Assert class methods; do not use System.Assert methods

### Phase 5: Live Test Prep
- Create script in the scripts folder that will delete all existing task records, then create an appropriate amount of test records for us to be able to test our interface
- Ensure that we have a few records for each group
- Review the standard-sf-task-creation-screen.png for a reference on all required fields.

### Phase 6: Impelement Client-side Logic
- Migrate from hard coded test data to data retrieved from the apex class implemented in Phase 3
- When completing a task, the task should be removed from the interface immediately
- When defering a task, the task should move to the Tomorrow section immediately 

## Rules
- Implementation should be taken one step at a time
- Ask clarifying questions when needed