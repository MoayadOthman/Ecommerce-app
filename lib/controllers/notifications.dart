import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore للتفاعل مع قاعدة بيانات Firebase.
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Auth للتعامل مع المصادقة.
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة.

class NotificationController extends GetxController { // تعريف كلاس NotificationController لإدارة الإشعارات.
  User? user = FirebaseAuth.instance.currentUser; // الحصول على المستخدم الحالي من Firebase Auth.
  var notificationCount = 0.obs; // تعريف متغير لمراقبة عدد الإشعارات غير المقروءة.

  @override
  void onInit() { // دالة تُستدعى عند تهيئة الكلاس.
    super.onInit(); // استدعاء دالة الأصل.
    fetchNotificationCount(); // استدعاء دالة جلب عدد الإشعارات.
  }

  void fetchNotificationCount() { // دالة لجلب عدد الإشعارات.
    FirebaseFirestore.instance // الوصول إلى قاعدة بيانات Firestore.
        .collection('notifications') // الانتقال إلى مجموعة "الإشعارات".
        .doc(user!.uid) // الحصول على وثيقة الإشعارات الخاصة بالمستخدم الحالي.
        .collection('notification') // الانتقال إلى مجموعة "الإشعارات" الخاصة بالمستخدم.
        .where('isSeen', isEqualTo: false) // تصفية الإشعارات غير المقروءة.
        .snapshots() // الحصول على تيار البيانات التلقائي لتحديثات الإشعارات.
        .listen((QuerySnapshot snapshot) { // الاستماع لتحديثات البيانات في اللقطة.
      notificationCount.value = snapshot.docs.length; // تعيين عدد الإشعارات غير المقروءة.
      print(notificationCount.value); // طباعة عدد الإشعارات في الكونسول.
      update(); // تحديث حالة الكلاس لإشعار المستمعين بالتغييرات.
    });
  }
}
