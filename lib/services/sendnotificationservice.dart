import 'dart:convert'; // استيراد مكتبة لتحويل البيانات بين التنسيقات، مثل JSON.
import 'package:last/services/getserviceskey.dart'; // استيراد خدمة لاسترجاع مفتاح الخادم (Server Key).
import 'package:http/http.dart' as http; // استيراد مكتبة HTTP للتعامل مع طلبات الشبكة.

class SendNotificationService { // تعريف فئة خدمة إرسال الإشعارات.
  static Future<void> sendNotificationUsingApi({ // تعريف دالة غير متزامنة لإرسال الإشعارات.
    required String? token, // توكن الجهاز الذي سيتم إرسال الإشعار إليه.
    required String? title, // عنوان الإشعار.
    required String? body, // محتوى الإشعار.
    required Map<String, dynamic>? data, // بيانات إضافية يمكن إرسالها مع الإشعار.
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken(); // استرجاع مفتاح الخادم باستخدام GetServerKey.
    String url = "https://fcm.googleapis.com/v1/projects/ecommerce-7650e/messages:send"; // رابط API لإرسال الرسائل عبر FCM.
    var headers = <String, String>{ // إنشاء خريطة للرؤوس المستخدمة في الطلب.
      'Content-Type': 'application/json', // تحديد نوع المحتوى كـ JSON.
      'Authorization': 'Bearer $serverKey', // إضافة مفتاح المصادقة في الرؤوس.
    };
    Map<String, dynamic> message = { // بناء هيكل الرسالة التي سيتم إرسالها.
      "message": {
        "token": token, // توكن الجهاز.
        "notification": { // بيانات الإشعار.
          "body": body, // محتوى الإشعار.
          "title": title, // عنوان الإشعار.
        },
        "data": data // بيانات إضافية يمكن إرسالها.
      }
    };

    final http.Response response = await http.post( // إرسال الطلب POST إلى FCM.
      Uri.parse(url), // تحويل الرابط إلى URI.
      headers: headers, // إضافة الرؤوس للطلب.
      body: jsonEncode(message), // تحويل هيكل الرسالة إلى JSON.
    );

    if (response.statusCode == 200) { // تحقق من حالة الاستجابة.
      print("Notification sent successfully"); // طباعة رسالة نجاح إذا تم إرسال الإشعار.
    } else { // إذا لم تكن الحالة 200.
      print("Notification not sent!"); // طباعة رسالة فشل في إرسال الإشعار.
    }
  }
}
