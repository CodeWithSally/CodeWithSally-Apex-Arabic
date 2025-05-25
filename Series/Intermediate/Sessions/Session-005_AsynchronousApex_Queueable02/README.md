# Session 005 – Queueable Apex (Part 2): Chaining, Callouts & Testing (Arabic)

This folder contains code examples from the Arabic session about advanced Queueable Apex topics.

🎥 **Watch the video here**:  
[YouTube Link – Arabic Session](https://youtu.be/v_J47saXmIw)

---

## 📚 Topics Covered

- Chaining Queueable jobs using `System.enqueueJob()`
- Using `QueueableContext` to track job execution
- Writing Unit Tests for Queueable classes
- Performing HTTP Callouts inside Queueable Apex
- How to mock callouts in tests (Homework suggestion)
- Comparing Queueable vs. Future methods
- When to still use Future methods

---

## 📂 Folder Contents

### 🔁 Chaining Demo
- `UpdateContactsQueue.cls`
- `NotifyUserQueue.cls`

### ✅ Unit Test Demo
- `ContactUpdaterQueue.cls`
- `ContactUpdaterQueueTest.cls`

### 🌐 Callout from Queueable
- `CountryDataFetcher.cls`

---

## 🔗 Related Videos

- [Queueable Apex Part 1 – Arabic](https://youtu.be/TPZdWjAbx9Q)

Explore more videos and content at (https://www.youtube.com/@CodeWithSally)
