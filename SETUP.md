# Student Learning App — Ready Starter

## ما الموجود؟
- Home/Dashboard
- Quiz مع تصحيح فوري أخضر/أحمر
- عداد للدرجة النهائية
- Homework List
- Homework Details مع أماكن الكاميرا/اختيار الملف والإرسال
- Lessons List
- Lesson Details مع أماكن الفيديو وPDF والتنزيل
- مخطط Firestore في docs/firestore_schema.json

## تشغيل نسخة Flutter
1. ثبّت Flutter.
2. داخل مجلد المشروع شغّل:
   flutter pub get
3. ثم:
   flutter run

## ربط Firebase
أضف Firebase إلى مشروع Flutter ثم اربط:
- Firebase Authentication
- Cloud Firestore
- Firebase Storage

## تحويله إلى FlutterFlow
أنشئ الصفحات بنفس الأسماء:
LoginPage
HomePage
QuizPage
ResultPage
HomeworkPage
HomeworkDetailsPage
LessonsPage
LessonDetailsPage

أنشئ Collections والحقول الموجودة في firestore_schema.json.
اربط:
- Quiz answers -> Conditional Action -> score
- Submit Homework -> Upload File -> Create Document
- Lessons -> Query Collection
- Video -> videoUrl
- PDF -> pdfUrl
- Progress -> lesson_progress

## ملاحظة
هذا Starter قابل للتشغيل فوراً ببيانات تجريبية. روابط الفيديو/PDF ورفع الملفات تحتاج ربط Firebase/الخدمات الفعلية.
