import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore للتفاعل مع قاعدة بيانات Firebase.
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة.

class GetUserDataController extends GetxController { // تعريف كلاس GetUserDataController لإدارة بيانات المستخدم.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // إنشاء كائن Firestore للوصول إلى قاعدة البيانات.

  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async { // دالة لجلب بيانات المستخدم بناءً على معرّف المستخدم.
    final QuerySnapshot userData = await _firestore.collection("users").where("uId", isEqualTo: uId).get(); // الحصول على وثائق المستخدمين الذين يتطابق uId معهم.
    return userData.docs; // إرجاع قائمة الوثائق التي تم جلبها.
  }
}
