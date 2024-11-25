import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:last/screens/user_panel/cart/allorderscreen.dart';
import 'package:last/screens/user_panel/product/allproductsscreen.dart';
import 'package:last/screens/user_panel/sale/allsalescreen.dart';
import 'package:last/screens/user_panel/cart/cartscreen.dart';
import 'package:last/screens/user_panel/notificationscreen.dart';
import 'package:last/services/fcm.dart';
import 'package:last/services/notificationservice.dart';
import 'package:last/services/sendnotificationservice.dart';
import 'package:last/utils/appconstant.dart';
import 'package:last/screens/user_panel/profile/profilescreen.dart';
import 'package:last/screens/user_panel/sale/custom-topsale.dart';
import '../../controllers/notifications.dart';
import '../../services/getserviceskey.dart';
import 'category/custom-categories.dart';
import '../../widgets/custom-heading.dart';
import 'newarrivel/custom-banners.dart';
import 'product/custom-products.dart';
import 'searchscreen.dart';
import 'category/allcategoriesscreen.dart';
import 'package:badges/badges.dart' as badges;

import 'favoritesscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NotificationService notificationService = NotificationService();
  GetServerKey getServerKey = GetServerKey();
  final NotificationController notificationController = Get.put(NotificationController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    FcmService.fiebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: SShapeClipper(), // تطبيق شكل S
                  child: Container(
                    width: Get.width,
                    height: Get.height / 3.3,
                    color: AppConstant.appMainColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      StreamBuilder<DocumentSnapshot>(
                        stream: user != null ? _firestore.collection("users").doc(user!.uid).snapshots() : null,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.grey.shade200,
                              child: const CircularProgressIndicator(), // مؤشر تحميل
                            );
                          }
                          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                            return const CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.error), // أيقونة خطأ
                            );
                          }


                          // الحصول على البيانات المحدثة من الـ Stream
                          final userData = snapshot.data!.data() as Map<String, dynamic>?;

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 25.0,
                                backgroundImage: CachedNetworkImageProvider(userData?['userImg'] ?? ""),
                              ),
                              SizedBox(width: Get.width / 50),
                              Text(
                                'مرحبا, ${userData?['username'] ?? "Username"}',
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          Obx(() {
                            return badges.Badge(
                              badgeContent: Text(
                                "${notificationController.notificationCount.value}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              position: badges.BadgePosition.topEnd(top: 0, end: 3),
                              showBadge: notificationController.notificationCount.value > 0,
                              child: IconButton(
                                onPressed: () async {
                                  Get.to(() => const NotificationScreen());
                                },
                                icon: const Icon(Icons.notifications, color: Colors.white, size: 30),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),


            const CustomArrival(),
            CustomHeading(
              headingTitle: "التصنيفات",
              buttonText: "عرض المزيد >",
              press: () => Get.to(() => const AllCategoriesScreen()),
            ),
            const CustomCategories(),
            CustomHeading(
              headingTitle: "الحسومات",
              buttonText: "عرض المزيد >",
              press: () => Get.to(() => const AllSaleScreen()),
            ),
            const CustomTopSale(),
            CustomHeading(
              headingTitle: "جميع المنتجات",
              buttonText: "عرض المزيد >",
              press: () => Get.to(() => const AllProductsScreen()),
            ),
            CustomProducts(),
          ],
        ),
      ),
    );
  }
}
