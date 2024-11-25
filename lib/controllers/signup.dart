import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:last/models/user.dart';
import 'package:last/utils/appconstant.dart';

import '../screens/auth_ui/signinscreen.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?>
  signUp(
      String userName,
      String userEmail,
      String userPhone,
      String userCity,
      String userPassword,
      String userDeviceToken,
      )
  async {
    try
    {
      EasyLoading.show(status: "انتظر قليلا");
      // إنشاء المستخدم باستخدام Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      // إرسال رسالة تحقق عبر البريد الإلكتروني
      await userCredential.user!.sendEmailVerification();

      // إنشاء نموذج المستخدم
      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        phone: userPhone,
        userDeviceToken: userDeviceToken,
        userImg: "",
        country: "",
        userAddress: "",
        city: userCity,
        street: "",
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
      );

      // إضافة بيانات المستخدم إلى Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toJson());

      EasyLoading.dismiss();

      // توجيه المستخدم بعد التسجيل
      Get.snackbar(
        "تم إنشاء حساب بنجاح",
        "تحقق من بريدك الإلكتروني لتأكيد التسجيل ",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );

      // يمكنك توجيه المستخدم إلى شاشة تسجيل الدخول أو شاشة أخرى
      Get.offAll(() => const SignInScreen());

      return userCredential;

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      String errorMessage;

      // تخصيص رسائل الخطأ بناءً على رمز الخطأ
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "The email address is already in use.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'operation-not-allowed':
          errorMessage = "Email/password accounts are not enabled.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        default:
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
