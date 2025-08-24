# 🚀 Session 015 - Invocable Methods (Part 3)

This session focuses on building a real-world **Screen Flow** that allows users to input multiple countries and retrieve country details via an **Apex callout** using an **Invocable Method**.

We reuse and extend previous components such as the **CountryCalloutUtility** and **CountryWrapper** classes and demonstrate how to connect it all in a flow.

---

## 📁 File Overview & Usage

### `classes/`

| File                             | Purpose                                                                 |
|----------------------------------|-------------------------------------------------------------------------|
| `CountryCalloutUtility.cls`      | Utility class responsible for calling the external Country REST API. Reused from previous sessions. |
| `CountryWrapper.cls`             | Wrapper class to store complex data retrieved from the API (e.g., name, region, language). |
| `GetCountriesDetailsAction.cls`  | **Invocable Method** class that wraps the utility call to be used inside the Screen Flow. |
| `SimplifiedCountryWrapper.cls`   | A trimmed version of the wrapper for flows — controls UI visibility using `@InvocableVariable`. |

---

### `flow/`

| File                                              | Purpose                                                                 |
|---------------------------------------------------|--------------------------------------------------------------------------|
| `Arabic_Get_Country_Details_Flow.flow-meta.flow-meta.xml`       | The **Screen Flow** where users enter country names and view country details. |

---

### `layouts/`

| File                                                   | Purpose                                                                 |
|--------------------------------------------------------|--------------------------------------------------------------------------|
| `Country__c-Country Layout.layout-meta.xml`            | Page layout configuration for the `Country__c` custom object. Optional for homework/expansion. |

---

### `objects/Country__c/`

| File                             | Purpose                                                                 |
|----------------------------------|-------------------------------------------------------------------------|
| `Country__c.object-meta.xml`     | Custom object definition (used in earlier sessions). |

> Note: `fields/` and `listViews/` folders contain metadata for object customization.

---

## 🧪 What You’ll Learn

- How to build and structure an **Invocable Method** that supports callouts
- Using **custom Apex wrapper classes** for rich Flow UIs
- Connecting Apex logic with **Flow inputs and outputs**
- Designing **Screen Flows** to support real-time API responses

---

## 📺 Watch the Session on YouTube

🔗 [Session 015 - Invocable Methods (Part 3)](https://youtu.be/G9AUEhC9Eec)

📺 [Watch Part 1](https://www.youtube.com/watch?v=-U1nJzlmf9U&list=PLeevJTFuNoISc6M_66RrulBIUYIkSm8kI&index=13&t=3s)  
📺 [Watch Part 2](https://www.youtube.com/watch?v=mueKfjmjjzI&list=PLeevJTFuNoISc6M_66RrulBIUYIkSm8kI&index=14&t=1s)

---

Happy coding! 💙  
**Code With Sally**
