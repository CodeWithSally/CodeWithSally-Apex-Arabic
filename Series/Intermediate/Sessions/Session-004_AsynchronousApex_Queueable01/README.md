# Session 004 – Queueable Apex (Part 1) - Arabic

In this session, we explored how to use **Queueable Apex** in Salesforce to run asynchronous logic in a more flexible and structured way than future methods.

## ✅ What We Covered

- What is Queueable Apex and when to use it
- Syntax and structure of a Queueable class
- How to execute it using the Anonymous Window
- How to pass data:
  - List of records (e.g., List<Contact>)
  - Wrapper class with multiple fields
- Comparison with Future Methods
- Two hands-on demos using different data structures

## 📁 GitHub Folder Structure

- `MyQueueableJob.cls`  
  ➤ Basic demo to explain Queueable syntax and execution

- `ContactUpdaterQueue.cls`  
  ➤ Queueable class that accepts a List of Contact records and processes them

- `ContactRegionWrapper.cls`  
  ➤ A wrapper class used for passing more complex data

- `ContactRegionJob.cls`  
  ➤ Queueable job that consumes the wrapper and performs logic accordingly

---

📺 **Watch the session on YouTube**  
https://youtu.be/TPZdWjAbx9Q

▶️ **Explore the full Intermediate series (Arabic)**  
https://www.youtube.com/playlist?list=PLeevJTFuNoISc6M_66RrulBIUYIkSm8kI

🌐 More on: [codewithsally.com](https://codewithsally.com)

---

