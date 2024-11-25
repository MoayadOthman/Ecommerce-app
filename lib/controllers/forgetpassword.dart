import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Auth للتعامل مع مصادقة المستخدمين.
import 'package:flutter_easyloading/flutter_easyloading.dart'; // استيراد مكتبة Flutter EasyLoading لعرض مؤشرات التحميل.
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة والتنقل.
import 'package:last/screens/auth_ui/signinscreen.dart'; // استيراد شاشة تسجيل الدخول.
import 'package:last/utils/appconstant.dart'; // استيراد الثوابت المستخدمة في التطبيق.

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> forgetPassword(String userEmail) async {
    try {
      EasyLoading.show(status: "انتظر قليلا");
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        "إعادة تعيين كلمة سر",
        "تم إرسال رسالة الى $userEmail لإعادة تعيين كلمة سر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );
      Get.offAll(() => const SignInScreen());
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "خطأ",
        "حدث خطأ,حاول مجددا",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );
    }
    return null;
  }
}
