import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:last/screens/user_panel/cart/cartscreen.dart';
import 'package:last/screens/user_panel/notificationscreen.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      Get.snackbar(
        'Notification permission denied',
        'Please allow notifications to receive updates',
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 3), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  // Get device token
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("Device token: $token");
    return token!;
  }

  // Initialize local notifications
  Future<void> initLocalNotification() async {
    var androidInitSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitSetting = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitSetting,
      iOS: iosInitSetting,
    );

    await _flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        handleMessage(details.payload);
      },
    );
  }

  // Firebase message initialization
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (kDebugMode) {
        print("Notification title: ${notification?.title}");
        print("Notification body: ${notification?.body}");
      }

      if (Platform.isIOS) {
        iosForgroundMessage();
      }

      if (Platform.isAndroid && notification != null && android != null) {
        await initLocalNotification();
        showNotification(message);
      }
    });

    setupInteractMessage(context);
  }

  // Show notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification?.android?.channelId ?? 'default_channel',
      'Default Channel',
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: "Channel Description",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationPlugin.show(
      0,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
      payload: "custom_data",
    );
  }

  // Setup interaction with background/terminated notifications
  Future<void> setupInteractMessage(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message.data['screen']);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(message.data['screen']);
      }
    });
  }

  // Handle notification tap
  Future<void> handleMessage(String? screen) async {
    if (screen == 'cart') {
      // Get.to(() => const CartScreen());
    } else {
      // Get.to(() => const NotificationScreen(message;message));
    }
  }

  // Handle foreground notifications on iOS
  Future<void> iosForgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
