import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firebase Firestore للعمل مع قاعدة البيانات.
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة.

class CalculateRatingController extends GetxController { // تعريف كلاس CalculateRatingController لاحتساب تقييم المنتج.
  final String productId; // تعريف متغير لتخزين معرّف المنتج.
  RxDouble averageRating = 0.0.obs; // تعريف متغير لمراقبة التقييم المتوسط كقيمة قابلة للتفاعل.

  CalculateRatingController(this.productId); // مُنشئ الكلاس الذي يستقبل معرّف المنتج.

  @override
  void onInit() { // دالة يتم استدعاؤها عند تهيئة الكلاس.
    super.onInit(); // استدعاء دالة الأصل.
    calculateAverageRating(); // استدعاء دالة حساب التقييم المتوسط.
  }

  void calculateAverageRating() async { // دالة لحساب التقييم المتوسط بشكل غير متزامن.
    await FirebaseFirestore.instance // الانتظار حتى يتم استرداد البيانات من Firestore.
        .collection('products') // الانتقال إلى مجموعة "المنتجات".
        .doc(productId) // الحصول على وثيقة المنتج بناءً على معرّفه.
        .collection('reviews') // الانتقال إلى مجموعة "المراجعات" الخاصة بالمنتج.
        .snapshots() // الحصول على تيار البيانات التلقائي للتحديثات.
        .listen((snapshot) { // الاستماع لتحديثات البيانات.
      if (snapshot.docs.isNotEmpty) { // التحقق مما إذا كانت هناك وثائق في اللقطة.
        double totalRating = 0; // متغير لتخزين مجموع التقييمات.
        int numberOfReviews = 0; // متغير لتخزين عدد المراجعات.

        snapshot.docs.forEach((doc) { // تكرار الوثائق في اللقطة.
          final ratingAsString = doc['rating'] as String; // الحصول على التقييم من الوثيقة كـ String.
          final rating = double.tryParse(ratingAsString); // تحويل التقييم من String إلى double.
          if (rating != null) { // التحقق مما إذا كان التقييم صالحًا.
            totalRating += rating; // إضافة التقييم إلى المجموع.
            numberOfReviews++; // زيادة عدد المراجعات.
          }
        });

        // حساب التقييم المتوسط
        if (numberOfReviews != 0) { // التحقق مما إذا كان هناك أي مراجعات.
          averageRating.value = totalRating / numberOfReviews; // حساب المتوسط.
        } else {
          averageRating.value = 0; // إذا لم يكن هناك مراجعات، تعيين المتوسط إلى 0.
        }
      } else {
        averageRating.value = 0; // إذا كانت مجموعة الوثائق فارغة، تعيين المتوسط إلى 0.
      }
    });
  }
}
