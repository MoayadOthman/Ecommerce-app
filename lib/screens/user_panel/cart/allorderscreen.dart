import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last/models/order.dart';
import 'package:last/screens/user_panel/cart/reviewscreen.dart';
import 'package:last/utils/appconstant.dart';

import 'checkoutscreen.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الطلبات",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppConstant.appMainColor),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            return const Center(
              child: Text("خطأ في تحميل الطلبات"),
            );
          }

          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 7,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          // Handle empty data case
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("لا يوجد طلبات"),
            );
          }

          // Display data if available
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                      OrderModel orderModel = OrderModel(
                        orderDate: docData['orderDate'],
                        orderItems: List<Map<String, dynamic>>.from(docData['orderItems']),
                        orderStatus: docData['orderStatus'],
                        userId: docData['userId'],
                        userName: docData['userName'],
                        userPhone: docData['userPhone'],
                        userAddress: docData['userAddress'],
                        userToken: docData['userToken'],
                      );

                      // Assuming orderItems is a list with at least one item for demonstration
                      var firstItem = orderModel.orderItems.isNotEmpty ? orderModel.orderItems[0] : {};

                      return Card(
                        elevation: 5,
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 34,
                            backgroundColor: AppConstant.appMainColor,
                            backgroundImage: firstItem['productImages'] != null &&
                                (firstItem['productImages'] as List).isNotEmpty
                                ? NetworkImage(firstItem['productImages'][0])
                                : null,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                firstItem['productName'] ?? 'اسم المنتج غير متوفر',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${firstItem['productTotalPrice'] ?? '0'} ل.س",
                                style: const TextStyle(color: AppConstant.appMainColor, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                orderModel.orderStatus == true ? "تم التوصيل" : "قيد التنفيذ...",
                                style: TextStyle(
                                  color: orderModel.orderStatus == true ? Colors.green : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: orderModel.orderStatus == true
                              ? Material(
                            shadowColor: const Color(0xff4a2664),
                            borderRadius: BorderRadius.circular(40),
                            color: AppConstant.appMainColor,
                            child: SizedBox(
                              width: Get.width / 5,
                              height: Get.width / 12,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => ReviewScreen(orderModel: orderModel));
                                },
                                child: const Text(
                                  "تقييم",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Container(); // Return empty container if none of the conditions match
        },
      ),
    );
  }
}
