import 'package:firebase_messaging/firebase_messaging.dart'; // استيراد مكتبة Firebase Messaging لإدارة الإشعارات.

Future<String> getCustomerDeviceToken() async { // تعريف دالة للحصول على رمز الجهاز للمستخدم.
  try { // بدء كتلة try لتجربة تنفيذ الكود.
    String? token = await FirebaseMessaging.instance.getToken(); // محاولة الحصول على رمز الجهاز من Firebase Messaging.
    if (token != null) { // التحقق إذا كان الرمز غير فارغ.
      return token; // إذا كان الرمز غير فارغ، إرجاعه.
    } else { // إذا كان الرمز فارغًا.
      throw Exception("Error"); // إلقاء استثناء بسبب وجود خطأ.
    }
  } catch (e) { // في حالة حدوث أي استثناء.
    print("Error $e"); // طباعة الخطأ في وحدة التحكم.
    throw Exception("Error"); // إلقاء استثناء بسبب الخطأ.
  }
}
