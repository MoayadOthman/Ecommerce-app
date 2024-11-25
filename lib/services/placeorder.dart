// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database operations.
// import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for user authentication.
// import 'package:flutter/src/widgets/framework.dart'; // Import Flutter framework widgets.
// import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import EasyLoading for loading indicators.
// import 'package:get/get.dart'; // Import GetX for state management and routing.
// import 'package:last/models/order.dart'; // Import the Order model class.
// import 'package:last/screens/user_panel/BottomNav.dart';
// import 'package:last/screens/user_panel/mainscreen.dart'; // Import the main screen for navigation after order placement.
// import 'package:last/services/genrateorderid.dart'; // Import service for generating order IDs.
// import 'package:last/services/sendnotificationservice.dart'; // Import service for sending notifications.
// import 'package:last/utils/appconstant.dart'; // Import application constants for UI customization.
//
// import 'notificationservice.dart'; // Import notification service.
// void placeOrder({
//   required BuildContext context,
//   required String customerName,
//   required String customerPhone,
//   required String customerAddress,
//   required String customerToken
// }) async {
//   final user = FirebaseAuth.instance.currentUser;
//   NotificationService notificationService = NotificationService();
//
//   Future<String?> getAdminToken() async {
//     try {
//       final querysnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('isAdmin', isEqualTo: true)
//           .get();
//       if (querysnapshot.docs.isNotEmpty) {
//         return querysnapshot.docs.first['userDeviceToken'] as String;
//       } else {
//         return null;
//       }
//     }
//     catch (e) {
//       print("Error! is ${e}");
//       return null;
//     }
//   }
//
//   String? adminToken = await getAdminToken();
//
//   EasyLoading.show(status: "انتظر قليلا..");
//   if (user != null) {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('cart')
//           .doc(user.uid)
//           .collection('cartOrders')
//           .get();
//       List<QueryDocumentSnapshot> docs = querySnapshot.docs;
//
//       for (var doc in docs) {
//         Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
//         String orderId = genrateOrderId();
//
//
//         OrderModel orderModel = OrderModel(
//           categoryId: data['categoryId'],
//           customerId: user.uid,
//           categoryName: data['categoryName'],
//           createdAt: DateTime.now(),
//           updateAt: data['updateAt'],
//           deliveryTime: data['deliveryTime'],
//           fullPrice: data['fullPrice'],
//           productDescription: data['productDescription'],
//           productId: data['productId'],
//           productImages: List<String>.from(data['productImages']),
//           productName: data['productName'],
//           salePrice: data['salePrice'],
//           isSale: data['isSale'],
//           productQuantity: data['productQuantity'],
//           productTotalPrice: data['productTotalPrice'],
//           status: false,
//           customerName: customerName,
//           customerPhone: customerPhone,
//           customerAddress: customerAddress,
//           customerDeviceToken: customerToken,
//           selectedColor:data['selectedColor'], // إضافة اللون المختار
//           selectedSize: data['selectedSize'], // إضافة الحجم المختار
//         );
//
//         await FirebaseFirestore.instance.collection('orders').doc(user.uid).set({
//           'uId': user.uid,
//           'customerName': customerName,
//           'customerPhone': customerPhone,
//           'customerAddress': customerAddress,
//           'customerToken': customerToken,
//           'orderStatus': false,
//           'createdAt': DateTime.now()
//         });
//
//         await FirebaseFirestore.instance
//             .collection('orders')
//             .doc(user.uid)
//             .collection('confirmOrders')
//             .doc(orderId)
//             .set(orderModel.toJson());
//
//         await FirebaseFirestore.instance
//             .collection('cart')
//             .doc(user.uid)
//             .collection('cartOrders')
//             .doc(orderModel.productId.toString())
//             .delete()
//             .then((value) {
//           print("Deleted cart products $orderModel");
//         });
//
//         await FirebaseFirestore.instance
//             .collection('admin_notifications')
//             .doc()
//             .set({
//           'title': "طلب جديد من $customerName",
//           'body': "تم تأكيد الطلب",
//           'createdAt': DateTime.now(),
//           'isSeen': false,
//         });
//       }
//
//       SendNotificationService.sendNotificationUsingApi(
//           token: adminToken,
//           title: "طلب الزبون ${customerName}",
//           body: "تم تأكيد الطلب",
//           data: {
//             "screen": "notification",
//           }
//       );
//
//       SendNotificationService.sendNotificationUsingApi(
//           token: customerToken,
//           title: "تفاصيل الطلب",
//           body: "تم تأكيد الطلب",
//           data: {
//             "screen":"notification",
//           }
//       );
//
//       print("Order Confirm");
//       Get.snackbar("تم تأكيد الطلب", "اختيار جيد!",
//         backgroundColor: AppConstant.appMainColor,
//         colorText: AppConstant.appTextColor,
//         duration: Duration(seconds: 3),
//       );
//       Get.offAll(() => BottomNav());
//     } catch (e) {
//       print("error $e");
//     }
//   }
// }
