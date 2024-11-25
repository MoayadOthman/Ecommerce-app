import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last/screens/auth_ui/signinscreen.dart';
import 'package:last/utils/appconstant.dart';

import '../../controllers/googlesignin.dart';
import '../user_panel/profile/editprofilescreen.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "مرحبا بك!",
          style: TextStyle(fontSize: 22, color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper:SShapeClipper(), // تطبيق شكل S
            child: Container(
              width: Get.width,
              height: Get.height / 3.5,
              color: AppConstant.appMainColor,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    decoration: const BoxDecoration(
                    ),
                    child: const Icon(
                      Icons.laptop,
                      color: Colors.white,
                      size: 200,
                    ),
                  ),
                  SizedBox(height: Get.height / 25),
                  const Text(
                    "استمتع بجولتك",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Get.height / 12),
                  Material(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppConstant.appMainColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: Get.width / 1.2,
                      height: Get.height / 12,
                      child: TextButton.icon(
                        onPressed: () {
                          _googleSignInController.signInWithGoogle();
                        },
                        icon: Image.asset(
                          "assets/images/google_logo.png",
                          width: Get.width / 16,
                          height: Get.height / 16,
                        ),
                        label: const Text(
                          "تسجيل دخول بإستخدام google",
                          style: TextStyle(color: AppConstant.appTextColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height / 50),
                  Material(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppConstant.appScendoryColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: Get.width / 1.2,
                      height: Get.height / 12,
                      child: TextButton.icon(
                        onPressed: () {
                          Get.to(() => const SignInScreen());
                        },
                        icon: const Icon(
                          Icons.email,
                          color: AppConstant.appTextColor,
                        ),
                        label: const Text(
                          "تسجيل دخول بإستخدام البريد الإلكتروني",
                          style: TextStyle(color: AppConstant.appTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
