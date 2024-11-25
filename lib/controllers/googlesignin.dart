import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:last/models/user.dart';
import 'package:last/screens/user_panel/BottomNav.dart';

class GoogleSignInController extends GetxController {
  //لتسجيل دخول بإستخدام غوغل
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //للوصول الى خدمة التحقق
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> signInWithGoogle() async {
    try {
     //تسجيل دخول بحساب غوغل
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      //اي يوجد حساب و مسجل دخول سابقا
      if (googleSignInAccount != null) {
        EasyLoading.show(status:"انتظر قليلا..");
        //لتحقق من حساب مسجل دخول
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        // الحصول على المعلومات اللازمة لتسجيل الدخول باستخدام Firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // تسجيل الدخول إلى Firebase باستخدام Google
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
      //معلومات المستخدم الاستسية في الفاير
        final User? user = userCredential.user;
        //اي المستخدم سجل دخول لفاير
        if (user != null) {
          // إنشاء نموذج المستخدم
          UserModel userModel = UserModel(
            uId: user.uid,
            username: user.displayName ?? '',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            userImg: user.photoURL ?? '',
            userDeviceToken: "",
            country: "",
            userAddress: "",
            city: '',
            street: "",
            isAdmin: false,
            isActive: true,
            createdOn: DateTime.now(),
          );

          // تخزين معلومات المستخدم في Firestore
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set(userModel.toJson());
          EasyLoading.dismiss();
         Get.offAll(()=>BottomNav());
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error during Google sign-in: $e");
    }
  }
}


