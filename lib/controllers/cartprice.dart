// استيراد مكتبة Cloud Firestore للتعامل مع قاعدة بيانات Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// استيراد مكتبة GetX لإدارة الحالة والتفاعلات
import 'package:get/get.dart';

// تعريف كلاس CartController لإدارة عمليات السلة
class CartController extends GetxController {

  // تعريف معرف المستخدم في تحديد السلة الخاصة به
  final String userId;

  // تعريف مرجع لمجموrعة السلة داخل Firestore
  late CollectionReference cartCollection;

  // تعريف متغير تفاعلي للسعر الإجمالي للسلة
  var totalCartPrice = 0.0.obs;

  // تعريف متغير تفاعلي لعرض حالة التحميل
  var isLoading = false.obs;

  // منشئ الكلاس لتعيين المعرف وتحضير العمليات
  CartController(this.userId) {
    // تحديد مسار مجموعة السلة الخاصة بالمستخدم بناءً على معرفه
    cartCollection = FirebaseFirestore.instance
        .collection('cart') // الوصول إلى مجموعة السلة العامة
        .doc(userId) // تحديد المستند الخاص بالمستخدم
        .collection('cartOrders'); // الوصول إلى طلبات السلة الخاصة به

    // حساب السعر الإجمالي عند تحميل المراقب
    calculateTotalPrice();
  }

  // دالة لحساب السعر الإجمالي لجميع المنتجات في السلة
  Future<void> calculateTotalPrice() async {
    // تحديد حالة التحميل إلى true أثناء حساب السعر
    isLoading.value = true;

    // جلب جميع مستندات المنتجات داخل السلة
    QuerySnapshot snapshot = await cartCollection.get();

    // متغير محلي لتجميع السعر الإجمالي
    double total = 0.0;

    // المرور على جميع المستندات في السلة
    for (var doc in snapshot.docs) {
      // إضافة السعر الإجمالي لكل منتج إلى المجموع
      total += doc['productTotalPrice'];
    }

    // تحديث القيمة التفاعلية للسعر الإجمالي
    totalCartPrice.value = total;

    // تحديد حالة التحميل إلى false بعد الانتهاء
    isLoading.value = false;
  }

  // دالة لتحديث كمية المنتج في السلة
  Future<void> updateQuantity(
      String productId, int newQuantity, double productPrice) async {
    // التحقق من أن الكمية الجديدة أكبر من صفر
    if (newQuantity > 0) {
      // حساب السعر الإجمالي الجديد للمنتج بناءً على الكمية
      double totalPrice = productPrice * newQuantity;

      // تحديث مستند المنتج داخل السلة
      await cartCollection.doc(productId).update({
        'productQuantity': newQuantity, // تحديث الكمية
        'productTotalPrice': totalPrice, // تحديث السعر الإجمالي
      });
    } else {
      // حذف المنتج من السلة إذا كانت الكمية الجديدة صفرًا
      await cartCollection.doc(productId).delete();
    }

    // إعادة حساب السعر الإجمالي للسلة بعد التحديث
    await calculateTotalPrice();
  }
}
