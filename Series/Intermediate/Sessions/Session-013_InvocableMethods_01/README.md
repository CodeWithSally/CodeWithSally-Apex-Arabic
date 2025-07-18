# Session 013 - Invocable Methods Part 1

Welcome to another session in our **Apex Intermediate Series** and the **Apex Invocation Series** on the Code With Sally channel!  
In this session, we dive into **Invocable Methods** — what they are, how they work, and why we need them.

## 🔹 What We Covered

- Quick review of the different types of Apex invocation
- What are Invocable Methods and how they are similar to regular Apex methods
- Special syntax, rules, and limitations of Invocable Methods
- Why they **must accept a list** (Salesforce bulkification!)
- Where Invocable Methods can be called from:  
  Flows, Prompt Builder, Agent Actions, and REST API
- Live demo:
  - Create an Invocable Method (`AssignCaseCategoryAction.cls`)
  - Build a Record-Triggered Flow to invoke it
  - Explain how the input/output order affects the results
- Q&A and live attendee discussion
- What’s next: How to pass a list of Strings to an Invocable Method and build a dynamic **Screen Flow**

## 🧠 Homework

✅ Add unit tests for `AssignCaseCategoryAction.cls`  
Hint: Focus on bulk test scenarios and verify output matches input order!

## 📁 Files in This Folder

- `AssignCaseCategoryAction.cls` – Invocable Method example used in the session
- `CaseBeforeInsert.flow-meta.xml` – Record-triggered Flow that uses the Invocable Method
- (Optional) `InvocableExample.cls` – Simple syntax starter for Invocable Methods

## ▶️ Watch the Full Video

📺 [Salesforce Apex Invocable Methods | Part 1: What & How to Use in Record-Triggered Flows (Arabic)](https://youtu.be/-U1nJzlmf9U)

## 💬 Let’s Connect

Follow more sessions, examples, and practice on:
- 🌐 [codewithsally.com](https://codewithsally.com)
- 📺 [YouTube - Code With Sally](https://youtube.com/@codewithsally)
- 💼 [LinkedIn - Code With Sally](https://www.linkedin.com/company/codewithsally/)

---