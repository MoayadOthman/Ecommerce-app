import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:last/utils/appconstant.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // for password visibility (يمكن نقل هذا إلى SignInScreen إذا لم يكن مستخدمًا هنا)
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signIn(String userEmail, String userPassword) async {
    try {
      EasyLoading.show(status: "انتظر قليلا...");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

// التحقق مما إذا كان البريد الإلكتروني للمستخدم لم يتم التحقق منه بعد (emailVerified غير صحيح).
      if (!userCredential.user!.emailVerified) {
        // تسجيل خروج المستخدم من التطبيق باستخدام `_auth.signOut()`.
        await _auth.signOut();

        // عرض رسالة خطأ للمستخدم تشير إلى أن عليه التحقق من بريده الإلكتروني قبل تسجيل الدخول.
        Get.snackbar(
          "خطأ", // عنوان الرسالة
          "تحقق من البريد الإلكتروني قبل تسجيل الدخول", // نص الرسالة
          snackPosition: SnackPosition.BOTTOM, // تحديد موضع عرض الرسالة في الجزء السفلي من الشاشة
          backgroundColor: AppConstant.appScendoryColor, // تعيين لون خلفية الرسالة
          colorText: AppConstant.appTextColor, // تعيين لون النص في الرسالة
        );

        // إرجاع قيمة null لإيقاف المعالجة وتوضيح أن العملية لم تكتمل بسبب التحقق من البريد الإلكتروني.
        return null;
      }

      return userCredential;

    } on FirebaseAuthException
    catch (e) {
      String errorMessage;
      if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "This user has been disabled.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "No user found for this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      } else {
        errorMessage = "An unexpected error occurred. Please try again.";
      }

      Get.snackbar(
        "خطأ",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );
    }
    return null;
  }
}





