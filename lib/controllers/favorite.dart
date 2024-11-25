import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore للتعامل مع قاعدة البيانات السحابية.
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Auth للتعامل مع مصادقة المستخدمين.
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة والتنقل.
import 'package:last/utils/appconstant.dart'; // استيراد الثوابت المستخدمة في التطبيق.
import 'package:velocity_x/velocity_x.dart'; // استيراد مكتبة VelocityX لتسهيل تصميم واجهات المستخدم.

class FavoriteController extends GetxController { // تعريف الفئة FavoriteController التي تمدد GetxController.
  User? user = FirebaseAuth.instance.currentUser; // الحصول على المستخدم الحالي.
  var isFavorite = false.obs; // متغير لمراقبة حالة إضافة المنتج إلى المفضلة.

  // إضافة منتج إلى قائمة المفضلة الخاصة بالمستخدم مع معلومات إضافية
  addToFavorite(String docId, String productName, List<String> productImages, String fullPrice, context) async {
    await FirebaseFirestore.instance // استخدام Firestore للتعامل مع البيانات.
        .collection('favorites') // تحديد مجموعة المفضلة.
        .doc(user!.uid) // استخدام معرف المستخدم الحالي.
        .collection('favoriteProducts') // تحديد مجموعة المنتجات المفضلة.
        .doc(docId) // استخدام معرف المنتج.
        .set({ // تعيين البيانات.
      'productId': docId, // معرف المنتج.
      'productName': productName, // اسم المنتج.
      'productImages': productImages, // صور المنتج.
      'fullPrice': fullPrice, // السعر الكامل للمنتج.
      'addedAt': FieldValue.serverTimestamp(), // الوقت الذي تمت فيه الإضافة.
    }, SetOptions(merge: true)); // دمج البيانات إذا كانت موجودة بالفعل.

    isFavorite(true); // تعيين الحالة إلى مفضلة.
    VxToast.show( // عرض رسالة للمستخدم باستخدام VxToast.
      context,
      msg: 'تم الإضافة الى المفضلة', // نص الرسالة.
      bgColor: AppConstant.appMainColor, // لون خلفية الرسالة.
      textColor: AppConstant.appTextColor, // لون نص الرسالة.
    );
  }

  // إزالة منتج من قائمة المفضلة الخاصة بالمستخدم
  removeFromFavorite(String docId, context) async {
    await FirebaseFirestore.instance // استخدام Firestore للتعامل مع البيانات.
        .collection('favorites') // تحديد مجموعة المفضلة.
        .doc(user!.uid) // استخدام معرف المستخدم الحالي.
        .collection('favoriteProducts') // تحديد مجموعة المنتجات المفضلة.
        .doc(docId) // استخدام معرف المنتج.
        .delete(); // حذف المنتج من المفضلة.

    isFavorite(false); // تعيين الحالة إلى غير مفضلة.
    VxToast.show( // عرض رسالة للمستخدم باستخدام VxToast.
      context,
      msg: 'Removed from Favorites', // نص الرسالة.
      bgColor: AppConstant.appMainColor, // لون خلفية الرسالة.
      textColor: AppConstant.appTextColor, // لون نص الرسالة.
    );
  }

  // التحقق إذا كان المنتج في قائمة المفضلة للمستخدم
  checkIfFavorite(String docId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance // استخدام Firestore للتحقق من وجود المنتج.
        .collection('favorites') // تحديد مجموعة المفضلة.
        .doc(user!.uid) // استخدام معرف المستخدم الحالي.
        .collection('favoriteProducts') // تحديد مجموعة المنتجات المفضلة.
        .doc(docId) // استخدام معرف المنتج.
        .get(); // الحصول على الوثيقة.

    isFavorite(doc.exists); // تعيين الحالة بناءً على ما إذا كانت الوثيقة موجودة أم لا.
  }
}
