# Session 021 – How to Invoke Flex Prompt Templates in Salesforce (REST API + Apex Demo)
In this session, we focus on **how to invoke Flex Templates**, since unlike Sales Email or Field Generation templates, Flex Templates don’t have out-of-the-box entry points.


📺 **Watch the full video here:**
👉 [YouTube Session 021 (Arabic)](https://youtu.be/6ibBRe_NGRE)


---


## 🌟 What You’ll Learn
- 🔀 Why Flex Templates need custom invocation
- 🌐 How to call Flex Templates using **REST API** (via Workbench)
- 📖 How to read Salesforce documentation for **Einstein Prompt Template Generations API**
- 🧹 Step-by-step building of the REST request and testing in Workbench
- ⚡ How Salesforce wraps REST resources into **ConnectAPI static methods** in Apex
- 🖥️ How to invoke Flex Templates from **Apex** using `ConnectApi` namespace
- 🧑‍💻 Live demo of building a static method to handle Flex invocation
- 🔗 Using the new method from **LWC** (`sessionPackHub` component)
- ✅ Recap of differences between REST vs. Apex invocation
- 🎓 Sneak peek of upcoming short video: **invoking Flex Templates from Flow**


---


## 📁 Contents


### 1. Apex Classes
- **`CustomException.cls`**
Custom exception handling class for reusable error management.
- **`PromptTemplateService.cls`**
Service class wrapping logic to call Flex Prompt Templates via Connect API in Apex.
- **`SessionPackController.cls`**
Apex controller used for invoking and testing Flex Prompt Template execution from Apex.


### 2. genAiPromptTemplates
- **`CWS_Session_Pack_Generator_Enhanced.genAiPromptTemplate-meta.xml`**
Flex Prompt Template for generating YouTube session content pack (title, description, timestamps, and announcements).


### 3. Lightning Web Component (LWC)
- **`sessionPackHub.html / .js / .css / .js-meta.xml`**
Custom LWC to manage session input/output and invoke Flex Prompt Template.


### 4. Custom Objects
- **`YoutubeVideo__c`**
Represents a YouTube video with description, timestamps, and related metadata.
- **`Playlist__c`**
Represents a video playlist (e.g., “Intermediate Apex Sessions”).
- **`VideoPlaylist__c`**
Junction object linking `YoutubeVideo__c` and `Playlist__c`.


### 5. Page Layouts
- **`Playlist__c-Layout.layout-meta.xml`**
Layout configuration for Playlist object.
- **`VideoPlaylist__c-Layout.layout-meta.xml`**
Layout configuration for VideoPlaylist object.
- **`YoutubeVideo__c-Layout.layout-meta.xml`**
Layout configuration for YoutubeVideo object.


---


## 🔗 Helpful Links
- **Workbench (REST Explorer):** https://workbench.developerforce.com/login.php?startUrl=%2FrestExplorer.php
- **Einstein Prompt Template Generations API Docs:** https://developer.salesforce.com/docs/atlas.en-us.chatterapi.meta/chatterapi/connect_resources_prompt_template.htm
- **JSON Formatter:** https://jsonformatter.curiousconcept.com/#