# Session 019 – Invocable Methods Part 6: Field Generation Prompt Template Grounded with Apex (Arabic)

This session demonstrates how to build a **Field Generation Prompt Template** grounded with Apex using Invocable Methods in Salesforce. We walk step-by-step through enabling AI capabilities, linking prompts to fields, grounding them with Apex, handling errors, and building custom logic dynamically.

📺 **YouTube Video (Arabic)**: https://youtu.be/272Vm8pF9RU

---

## 📦 Folder Overview

### ⚙️ Apex Classes
- `BrokerRatePromptAction.cls`: Invocable method to calculate broker commission dynamically.

---

## 📑 Prompts  
All used in the session to test and compare prompt behavior:

- `Prompt01_HardcodedRate_NoApexGrounded`: Static prompt without Apex.
- `Prompt02_ApexGrounded_LongText_apexGrounded`: Grounded with Apex, used with Long Text field.
- `Prompt03_Text255_apexGrounded`: Apex-grounded, constrained to Text(255).
- `Prompt04_RichText_ApexGrounded`: Apex-grounded and outputs HTML to Rich Text Field.

---

## 🗂️ Objects & Fields

### 📦 Objects from Dreamhouse Package

#### `Broker__c`
- Base object from the Dreamhouse app.
- **New custom fields added for this session**:
  - `Bio__c` (Long Text)
  - `Awards__c`
  - `Specializations__c`
  - `Hire_Date__c` (used for calculating commission rate)

#### `Property__c`
- From Dreamhouse app.
- Used for demonstrating record links in prompt templates.
- Field used:
  - `Property_Type__c`

---

### ✳️ New Custom Object Created for This Session

#### `Broker_Work_Experience__c`
- Custom object to store broker's work history.
- Fields:
  - `Company__c`
  - `Role__c`
  - `Start_Date__c`
  - `End_Date__c`
  - Lookup to `Broker__c`

---

## 🛠️ Custom Metadata

### `CommissionTier__mdt` *(Newly Created)*
Used by the Apex class to determine commission rate based on broker's years of experience.

- Records:
  - `Tier_0_2`
  - `Tier_3_5`
  - `Tier_6_plus`

- Fields:
  - `MinYears__c`
  - `MaxYears__c`
  - `RatePercent__c`

---

## 🧪 Key Concepts Covered

- Prompt Templates for **Field Generation**
- **Grounding with Apex** via Invocable Methods
- Using **Related Records** in Prompts
- Custom Metadata & Dynamic Business Logic
- With and Without `capabilityType`
- Error Handling Best Practices for Prompt Templates
- Adding **Record Links** in AI-Generated Email Templates (Part 5 Homework)

---

🔁 **Previous Parts of the Series:**

- **Part 1** – Record-Triggered Flows  
  https://youtu.be/-U1nJzlmf9U

- **Part 2** – Lists & Wrapper Classes + Unit Tests  
  https://youtu.be/mueKfjmjjzI

- **Part 3** – Screen Flow + API Callout  
  https://youtu.be/G9AUEhC9Eec

- **Part 4** – Prompt Templates (Concepts)  
  https://youtu.be/WE3t7gwTdik

- **Part 5** – Sales Email Prompt Template Grounded with Apex (Arabic)  
  https://youtu.be/DzsHnJcSCqs
