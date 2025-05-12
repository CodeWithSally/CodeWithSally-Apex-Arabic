# 🚀 Session 002 – Future Methods in Apex (Part 2) (Arabic)

ده الجزء التاني والأخير من future methods في Apex. هنشتغل فيه على سيناريوهات حقيقية زي الـ API والـ callout من التريجر وكمان نختبر future methods.

🎥 **شاهد الجلسة:**  
https://youtu.be/RDQaIzXiMT0

📺 **الجزء الأول:**  
https://youtu.be/TkkBR-fvad4

---

## 📚 هنتعلم إيه في الجلسة دي؟

- يعني إيه API؟ وإزاي نستخدم Postman علشان نجربه
- يعني إيه JSON؟ وازاي نعمل serialize وdeserialize باستخدام Apex
- إزاي نعمل callout من Apex باستخدام HttpRequest
- ليه الـ callout من التريجر بيرجع Error؟ وازاي نحلها بـ `@future(callout=true)`
- إزاي نـmock response من API في unit test
- Limitations بتاعة future methods:
  - مفيش ترتيب في التنفيذ
  - مش بنقدر نعمل chaining من future method تانية

---

## 🧠 Resources

- [JSON Class - Salesforce Docs](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_System_Json.htm)
- [HttpCalloutMock Reference](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_interface_httpcalloutmock.htm)

---

## 📁 TriggerCallout/

- `CountryTriggerHandler.cls`: logic التريجر
- `CountryCalloutUtility.cls`: بيعمل callout
- `CountryWrapper.cls`: بيرجع بيانات البلد من الـ API
- `CountryMockResponse.cls`: بيـmock الـ response
- `CountryTriggerHandlerTest.cls`: test class للـ trigger handler

---

## 🙏 Special Thanks

، وشكر خاص لـ **Waleed El Hor** على مشاركة الـ public API اللي استخدمناه ❤️

---

**Code With Sally - Intermediate Apex Series**
