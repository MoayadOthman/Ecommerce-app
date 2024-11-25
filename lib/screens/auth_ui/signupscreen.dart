import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:last/controllers/signup.dart';
import 'package:last/screens/auth_ui/signinscreen.dart';
import 'package:last/services/notificationservice.dart';
import '../../utils/appconstant.dart';

// تعريف واجهة تسجيل المستخدم كـ StatefulWidget للحفاظ على حالتها أثناء التفاعل
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// إنشاء الحالة (State) لواجهة تسجيل المستخدم
class _SignUpScreenState extends State<SignUpScreen> {
  // تعريف وحدة التحكم الخاصة بالتسجيل
  final SignUpController _signUpController = Get.put(SignUpController());
  // إنشاء حقول النص لإدخال البيانات مثل اسم المستخدم، البريد الإلكتروني، إلخ
  final TextEditingController username = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  final TextEditingController userPhone = TextEditingController();
  final TextEditingController userCity = TextEditingController();

  // تدمير حقول النص عند الخروج من الشاشة لتحرير الذاكرة
  @override
  void dispose() {
    username.dispose();
    userEmail.dispose();
    userPassword.dispose();
    userPhone.dispose();
    userCity.dispose();
    super.dispose();
  }

  // بناء واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    // مراقبة ظهور لوحة المفاتيح باستخدام KeyboardVisibilityBuilder
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        // استخدام Scaffold لإنشاء واجهة الشاشة الكاملة
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
            title: const Text(
              "إنشاء حساب",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
            ),
            centerTitle: true,
          ),
          // وضع محتوى الشاشة داخل ScrollView لتمكين التمرير عند ظهور لوحة المفاتيح
          body: Stack(
            children: [
              ClipPath(
                clipper: SShapeClipper(), // تطبيق شكل S
                child: Container(
                  width: Get.width,
                  height: Get.height / 3.5,
                  color: AppConstant.appMainColor,
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 50),
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "مرحبا بك!",
                          style: TextStyle(fontSize: 22, color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: userEmail,
                          cursorColor: AppConstant.appMainColor,
                          keyboardType: TextInputType.emailAddress,
                          decoration:  const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)
                              ),
                            ),
                            errorBorder:const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)
                              ),
                            ) ,

                            focusedBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30)
                                )
                            ) ,
                            hintText: "البريد الإلكتروني",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(

                            ),
                          ),
                          // التحقق من صحة البريد الإلكتروني
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل بريدك الإلكتروني';
                            }
                            if (!GetUtils.isEmail(value.trim())) {
                              return 'يجب أن يكون بريد إلكتروني';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: username,
                          cursorColor: AppConstant.appMainColor,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)
                              ),
                            ),
                            errorBorder:const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)
                                        ),
                                       ) ,
                            focusedBorder:const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30)
                                )
                            ) ,
                            hintText: "اسم المستخدم",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          // التحقق من صحة حقل اسم المستخدم
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل اسم المستخدم';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: userPhone,
                          cursorColor: AppConstant.appMainColor,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            errorBorder:const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)
                              ),
                            ) ,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)
                              ),
                            ),
                            focusedBorder:const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30)
                                )
                            ) ,
                            hintText: "هاتف",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          // التحقق من صحة حقل الهاتف
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل رقم هاتفك';
                            }
                            if (!GetUtils.isPhoneNumber(value.trim())) {
                              return 'يجب أن يكون رقماً';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: userCity,
                          cursorColor: AppConstant.appMainColor,
                          keyboardType: TextInputType.streetAddress,
                          decoration: const InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)
                              ),
                            ),
                            focusedBorder:const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30)
                                )
                            ) ,
                            errorBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30))
                            ),

                            hintText: "المدينة",
                            prefixIcon: Icon(Icons.location_pin),
                            border: OutlineInputBorder(),
                          ),
                          // التحقق من صحة حقل المدينة
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل اسم مدينتك';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Obx(() => TextFormField(
                          obscureText: !_signUpController.isPasswordVisible.value,
                          controller: userPassword,
                          cursorColor: AppConstant.appMainColor,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)
                              ),
                            ),
                            focusedBorder:const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30)
                                )
                            ) ,
                            errorBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30))
                            ),

                            hintText: "كلمة السر",
                            prefixIcon: const Icon(Icons.password_sharp),
                            suffixIcon: IconButton(
                              icon: _signUpController.isPasswordVisible.value
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                _signUpController.isPasswordVisible.toggle();
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          // التحقق من صحة حقل كلمة المرور
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل كلمةالسر';
                            }
                            if (value.trim().length < 6) {
                              return 'كلمة السر يجب أن تكون على الأقل 6 أحرف';
                            }
                            return null;
                          },
                        )),
                      ),
                      SizedBox(height: Get.height / 25),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppConstant.appScendoryColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: Get.width / 2,
                          height: Get.height / 18,
                          child: TextButton(
                            onPressed: () async {
                              NotificationService notificationService=NotificationService();
                              String name = username.text.trim();
                              String email = userEmail.text.trim();
                              String phone = userPhone.text.trim();
                              String city = userCity.text.trim();
                              String password = userPassword.text.trim();
                              String userDeviceToken = await notificationService.getDeviceToken();


                              if (name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty || password.isEmpty) {
                                Get.snackbar(
                                  "خطأ",
                                  "ادخل جميع الحقول",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appScendoryColor,
                                  colorText: AppConstant.appTextColor,
                                );
                              }
                              else {
                                UserCredential? userCredential = await _signUpController.signUp(
                                  name,
                                  email,
                                  phone,
                                  city,
                                  password,
                                  userDeviceToken,
                                );

                                if (userCredential != null) {

                                  Get.snackbar(
                                    "التحقق ",
                                    " تحقق من بريد الإلكتروني",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppConstant.appScendoryColor,
                                    colorText: AppConstant.appTextColor,
                                  );
                                  //تسجيل خروج لزيادة الامان وان المستحدم سيتحقق من البريد
                                  FirebaseAuth.instance.signOut();
                                  Get.offAll(() => const SignInScreen());
                                }
                              }
                            },
                            child: const Text(
                              "إنشاء حساب",
                              style: TextStyle(color: AppConstant.appTextColor, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "هل تملك حساب؟",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.offAll(() => const SignInScreen());
                            },
                            child: const Text(
                              " سجل دخول",
                              style: TextStyle(fontSize: 16, color: AppConstant.appScendoryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height / 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height - 50,
    );

    path.quadraticBezierTo(
      size.width * 0.75, size.height - 100,
      size.width, size.height - 50,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

