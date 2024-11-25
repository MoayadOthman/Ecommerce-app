import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:last/screens/auth_ui/signupscreen.dart';
import 'package:last/screens/auth_ui/splashscreen.dart';
import 'package:last/screens/user_panel/BottomNav.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // تأكد من تهيئة Firebase في الخلفية
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // التعامل مع الرسالة
  print('Received a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // تعيين معالج الرسائل في الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscribe();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'cairo',
      ),
      textDirection:TextDirection.rtl,
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

void subscribe(){
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  messaging.subscribeToTopic('all');
  print("subscribe");
}