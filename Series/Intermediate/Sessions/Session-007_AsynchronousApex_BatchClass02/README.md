# Session 007 – Batch Apex (Part 2): Unit Testing, Failed Batches & Stateful

This folder contains code samples from the second Arabic session on **Batch Apex**.

📺 Watch the video:  
https://youtu.be/5YgN3u3so4o

📺 Watch Part 1:  
https://youtu.be/MtvhjB9G1bk

---

## ✅ Topics Covered

- How to write Unit Tests for Batch Apex classes
- Why you can’t run `executeBatch()` more than once in the same test method
- What happens when one batch chunk fails — what’s committed, what’s skipped
- Using `Database.Stateful` to track state between execute runs (e.g. counters)

---

## 📂 Folder Contents

### ✅ Unit Testing  
- `BackfillOldOpportunities.cls`  
- `BackfillOldOpportunitiesTest.cls`  

### ⚠️ Batch Chunk Failure Simulation  
- `FailingBatchDemo.cls`  

### 🧠 Stateful Example  
- `StatefulOpportunityBatch.cls`  

---

For more content, visit [Code With Sally](https://www.youtube.com/@CodeWithSally).