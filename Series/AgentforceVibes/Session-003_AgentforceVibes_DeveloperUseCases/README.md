# Salesforce Agentforce Vibes — Developer Use Cases  
This folder contains all the Apex classes, triggers, workflows, CSV files, and assets used in the session:

➡️ **YouTube Session:** https://youtu.be/MGVeqfI3Q_Q?si=2C-9NMBJdsKp-WyS  
➡️ **Title:** *Salesforce Agentforce Vibes: Real Developer Use Cases (Not Just LWC & Apex!) (Arabic)*

In this session, we explored **8 practical developer-focused use cases** powered by *Agentforce Vibes* inside VS Code.

---

## **1. Ask Coding Questions — Grounded in Your Own Org & Codebase**
Workflow used: **`explain-concepts`**  
Example when Workflow asked me to enter what concepts I want to learn about:  
> *Explain static methods vs instance methods and show examples from the existing codebase.*

---

## **2. Explain Code / Generate Documentation**
Workflow used: **`document-apex-class`**  
We generated documentation for Apex classes directly from our Workspace.

---

## **3. Ask Questions About Your Codebase**
Test question used:  
> *“Do I have logic in place in my classes to call prompt templates from Apex?”*

Agentforce Vibes scanned all classes and returned relevant matches.

---

## **4. Deep Planning + Focus Chain + Code Refactoring**
We used **three triggers** (two incorrect, one correct) and applied Deep Planning with this prompt:

> Refactor triggers located in `@/force-app/main/default/triggers`  
> • Move business logic into handler classes  
> • Name handlers `{TriggerName}TriggerHandler`  
> • Use methods like `onBeforeInsert`, `onAfterUpdate`, etc.  
> • Standardize variable names: `lstNewObjects`, `lstOldObjects`, `mapNewObjects`, `mapOldObjects`  
> • Match trigger context variables correctly  
> • After refactoring, generate bulkified test classes  
> • Add descriptive comments and follow best practices

We observed all 4 phases live: Silent Investigation → Questions → MD Plan → New Task execution.

---

## **5. Add Inline Comments + Improve Code Quality**
File used: **`@/force-app/main/default/classes/MathUtility.cls`**  
Agentforce Vibes added inline comments and improved the method structure & clarity.

---

## **6. Generate a Visualforce Page (PDF-Ready)**
Prompt:  
> Create a read-only Visualforce page (PDF-ready) to display:  
> • Account Name  
> • Fax  
> • Phone  
> • Website  
> • Type  
> using a **standard controller**, no Apex controller needed.

Account metadata path:  
`@/force-app/main/default/objects/Account`

---

## **7. Convert JSON ⇆ Apex Wrapper Classes**
### JSON → Apex Wrapper
Prompt used:  
> Create a wrapper class for this JSON:  
> ```json
> { 
>   "firstName": "Alice",
>   "lastName": "Smith",
>   "gender": "female",
>   "age": 32,
>   "address": { "streetAddress": "202", "city": "Los Angeles", "state": "CA" },
>   "phoneNumbers": [ { "type": "mobile", "numberValue": "9876543210" } ]
> }
> ```

### Apex Wrapper → Sample JSON
Prompt used:  
> Give me a sample JSON string representing `Class context` for use in a test class.

---

## **8. Load CSV Data Into Salesforce**
We inserted data from:  
`@/docs/sample.csv`

Prompt:  
> Load this CSV into the standard `Account` object using the native  
> ```
> sf data import
> ```  
> command using org alias: **orgAlias**

---

## **📌 Additional Resources**
This project supports the full walkthrough shown in the session video.  
Files include:  
✔ Apex classes  
✔ Trigger handlers  
✔ Triggers  
✔ Documentation workflows  
✔ Sample CSV  
✔ Instructions for automation & refactoring

---

## **📺 YouTube Session**
🎥 https://youtu.be/MGVeqfI3Q_Q?si=2C-9NMBJdsKp-WyS 

---