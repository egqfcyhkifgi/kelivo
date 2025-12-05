# Build X - دليل الإعداد والاستخدام

## نظرة عامة
Build X هو تطبيق دردشة ذكي يتصل بنموذج AI مخصص عبر API. التطبيق يدعم Web، Android، و iOS.

## الميزات الرئيسية
- ✅ واجهة دردشة بسيطة ونظيفة
- ✅ تسجيل دخول عبر Google Firebase
- ✅ نظام ذاكرة للمحادثات
- ✅ اتصال مباشر بنموذج AI مخصص
- ✅ دعم متعدد المنصات (Web/Android/iOS)

## إعداد API

### 1. إنشاء ملف .env
قم بإنشاء ملف `.env` في المجلد الجذر للمشروع:

```env
# Build X API Configuration
API_URL=https://premiere-geographic-telling-call.trycloudflare.com
MODEL_NAME=Build X
API_TIMEOUT=30000
MAX_TOKENS=4096
```

### 2. تغيير رابط API
لتغيير رابط API الخاص بك:
1. افتح ملف `.env`
2. غير قيمة `API_URL` إلى الرابط الجديد
3. احفظ الملف وأعد تشغيل التطبيق

مثال:
```env
API_URL=https://your-new-api-url.com
```

### 3. متطلبات API
يجب أن يدعم API الخاص بك:
- نقطة النهاية: `/v1/chat/completions`
- طريقة: POST
- تنسيق OpenAI Compatible
- دعم streaming (اختياري)

## إعداد Firebase

### 1. إنشاء مشروع Firebase
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. أنشئ مشروع جديد
3. فعل Authentication
4. أضف Google Sign-In كمزود

### 2. إعداد التطبيق
1. أضف تطبيقك إلى Firebase (Web/Android/iOS)
2. حمل ملفات التكوين:
   - `google-services.json` للـ Android
   - `GoogleService-Info.plist` للـ iOS
   - Firebase config للـ Web

### 3. تحديث firebase_options.dart
استخدم Firebase CLI لتوليد ملف التكوين:
```bash
firebase login
firebase init
flutterfire configure
```

## تشغيل التطبيق

### Web
```bash
flutter run -d web-server --web-port 12000 --web-hostname 0.0.0.0
```

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

## استخدام التطبيق

### 1. تسجيل الدخول
- افتح التطبيق
- اضغط على "Continue with Google"
- أكمل عملية تسجيل الدخول

### 2. بدء محادثة
- اكتب رسالتك في حقل النص
- اضغط إرسال
- انتظر رد النموذج

### 3. إدارة الذاكرة
- اذهب إلى الإعدادات
- اضغط على "Memory"
- فعل/عطل الذاكرة حسب الحاجة
- أضف معلومات مهمة للذاكرة

## استكشاف الأخطاء

### مشاكل API
- تأكد من صحة رابط API في ملف `.env`
- تحقق من أن النموذج يعمل ويقبل الطلبات
- تأكد من تنسيق OpenAI Compatible

### مشاكل Firebase
- تحقق من إعدادات Firebase
- تأكد من تفعيل Google Sign-In
- راجع ملفات التكوين

### مشاكل عامة
- امسح cache التطبيق
- أعد تشغيل التطبيق
- تحقق من اتصال الإنترنت

## الدعم
للحصول على المساعدة، تأكد من:
1. صحة إعداد API
2. عمل Firebase Authentication
3. وجود ملف `.env` بالقيم الصحيحة