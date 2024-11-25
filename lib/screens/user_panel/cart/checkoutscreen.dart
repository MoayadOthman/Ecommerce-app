
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // مكتبة للمصادقة عبر Firebase
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart'; // مكتبة لتحريك الخلايا
import 'package:get/get.dart'; // مكتبة GetX لإدارة الحالة والتنقل
import 'package:last/controllers/cartprice.dart'; // وحدة تحكم للحصول على أسعار المنتجات
import 'package:last/controllers/getcustomerdevicetoken.dart'; // وحدة تحكم للحصول على توكن جهاز المستخدم
import 'package:last/models/cart.dart'; // موديل بيانات السلة
import 'package:last/utils/appconstant.dart'; // استيراد الثوابت

import '../../../services/getserviceskey.dart'; // خدمات للحصول على مفتاح الخدمة
import '../../../services/placeorder.dart';
import '../../../services/sendnotificationservice.dart';
import '../BottomNav.dart'; // خدمات لوضع الطلب

// تعريف واجهة شاشة الخروج
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

// الحالة لشاشة CheckoutScreen
class _CheckoutScreenState extends State<CheckoutScreen> {
  User? user = FirebaseAuth.instance.currentUser; // الحصول على المستخدم الحالي
  TextEditingController nameController = TextEditingController(); // متحكم لحقل الاسم
  TextEditingController phoneController = TextEditingController(); // متحكم لحقل الهاتف
  TextEditingController addressController = TextEditingController(); // متحكم لحقل العنوان

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التحقق من الطلب",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:AppConstant.appMainColor),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid) // الوصول إلى السلة الخاصة بالمستخدم
            .collection('cartOrders')
            .snapshots(), // استمع للتحديثات في مجموعة cartOrders
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("خطأ تحميل الطلبات"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 7,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("لا يوجد لديك طلبات!"),
            );
          }

          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                      CartModel cartModel = CartModel(
                        categoryId: docData['categoryId'],
                        categoryName: docData['categoryName'],
                        createdAt: docData['createdAt'],
                        updateAt: docData['updateAt'],
                        fullPrice: docData['fullPrice'],
                        salePrice: docData['salePrice'],
                        productDescription: docData['productDescription'] ?? '',
                        productId: docData['productId'],
                        productImages: List<String>.from(docData['productImages']),
                        productName: docData['productName'],
                        isSale: docData['isSale'],
                        productQuantity: docData['productQuantity'],
                        productTotalPrice: docData['productTotalPrice'],
                        sizes: List<String>.from(docData['sizes']),
                        colors: List<String>.from(docData['colors']),
                        selectedColor: docData['selectedColor'],
                        selectedSize: docData['selectedSize'],
                      );


                      return SwipeActionCell(
                        key: ObjectKey(cartModel.productId),
                        trailingActions: [
                          SwipeAction(
                            title: "إزالة",
                            performsFirstActionWithFullSwipe: true,
                            forceAlignmentToBoundary: true,
                            onTap: (handler) async {
                              await FirebaseFirestore.instance
                                  .collection('cart')
                                  .doc(user!.uid)
                                  .collection('cartOrders')
                                  .doc(cartModel.productId)
                                  .delete();
                            },
                          )
                        ],

                        child:Card(
                        elevation: 5,
                        color:Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Row(
                          children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.all( 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image:  NetworkImage(cartModel.productImages[0]),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                    cartModel.productName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text('اللون:  '),
                                            Row(
                                              children: cartModel.colors.map((color) {
                                                // تحويل اللون من النص إلى اللون الفعلي
                                                Color displayColor = Color(int.parse('0xff' + color.replaceAll('#', '')));
                                                return Container(
                                                  width: 20,
                                                  height: 20,
                                                  margin: const EdgeInsets.only(left: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: displayColor,
                                                    shape: BoxShape.circle, // يمكن استخدام BoxShape.rectangle لمربعات
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: Get.width/25,
                                        ),
                                        Row(
                                          children: [
                                            Text('القياس: ',),
                                            Text(
                                              "${cartModel.selectedSize}", // عرض المقاس المحدد
                                              style: const TextStyle(fontWeight:FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text('الكمية: ',),

                                        Text(
                                          " ${cartModel.productQuantity}", // عرض عدد الكمية
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('الإجمالي: '),
                                        Text(
                                          "${cartModel.productTotalPrice} ل.س",
                                          style: const TextStyle(color: AppConstant.appMainColor,fontWeight:FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                                              ),


                      );
                    },
                  ),
                ),
                _buildBottomSection(),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, -1),
          ),
        ],
      ),
      height: Get.height / 8,
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: AppConstant.appScendoryColor,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: Get.width / 2,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    showCustomBottomSheet();
                    GetServerKey getServerKey = GetServerKey();
                    String accessToken = await getServerKey.getServerKeyToken();
                    print(accessToken);
                  },
                  child: const Text(
                    "تأكيد الطلب",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppConstant.appTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.45,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height / 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  cursorColor: AppConstant.appMainColor,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "اسم المستخدم",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: phoneController,
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "الهاتف",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: addressController,
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "العنوان",
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 50),
              Material(
                color: AppConstant.appScendoryColor,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: Get.width / 3,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () async {

                     String name = nameController.text.trim();
                     String phone = phoneController.text.trim();
                     String address = addressController.text.trim();

                if (name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty) {
    // الحصول على الطلبات الحالية من السلة
                 var cartSnapshot = await FirebaseFirestore.instance
                    .collection('cart')
                    .doc(user!.uid)
                    .collection('cartOrders')
                    .get();

    List<Map<String, dynamic>> cartItems = cartSnapshot.docs.map((doc) {
    return doc.data();
    }).toList();
    String customerToken = await getCustomerDeviceToken();

    // إرسال البيانات إلى مجموعة 'orders'
    await FirebaseFirestore.instance.collection('orders').doc(user!.uid)
        .collection('confirmOrders').add({
    'userId': user!.uid,
    'userName': name,
    'userPhone': phone,
    'userAddress': address,
    'orderItems': cartItems,
    'orderStatus': true,
    'orderDate': DateTime.now().toIso8601String(),
    'userToken':customerToken,
    });

    // حذف الطلبات من السلة
    for (var doc in cartSnapshot.docs) {
    await doc.reference.delete();
    }

    // إرسال إشعار
    try {
    // استرجاع توكن الإدمن (هنا افترض أنك ستجلبه من قاعدة البيانات)

    Future<String?> getAdminToken() async {
      try {
        final querysnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('isAdmin', isEqualTo: true)
            .get();
        if (querysnapshot.docs.isNotEmpty) {
          return querysnapshot.docs.first['userDeviceToken'] as String;
        } else {
          return null;
        }
      }
      catch (e) {
        print("Error! is ${e}");
        return null;
      }
    }

    String? adminToken = await getAdminToken();

    // إرسال إشعار للإدمن
    await FirebaseFirestore.instance.collection('admin_notifications').doc().set({
    'title': "طلب جديد من $name",
    'body': "تم تأكيد الطلب",
    'createdAt': DateTime.now(),
    'isSeen': false,
    });

    SendNotificationService.sendNotificationUsingApi(
    token: adminToken,
    title: "طلب الزبون $name",
    body: "تم تأكيد الطلب",
    data: {"screen": "notification"},
    );
    String productName = cartItems[0]['productName'] ?? 'اسم المنتج غير متوفر';
    // إرسال إشعار للمستخدم
    await FirebaseFirestore.instance.collection('notifications')
        .doc(user!.uid) // تأكد من استخدام معرف المستخدم الصحيح
        .collection('notification')
        .add({
      'title': "تفاصيل الطلب",
      'body': "تم تأكيد الطلب${productName}",
      'createdAt': DateTime.now(),
      'isSeen': false,
    });
    // إظهار رسالة تأكيد
    Get.snackbar("تم تأكيد الطلب", "اختيار جيد!",
    backgroundColor: AppConstant.appMainColor,
    colorText: AppConstant.appTextColor,
    duration: Duration(seconds: 3),
    );
    Get.offAll(() => BottomNav());
    } catch (e) {
    print("Error sending notification: $e");
    Get.snackbar("خطأ", "حدث خطأ أثناء تأكيد الطلب",
    backgroundColor: Colors.red,
    colorText: Colors.white,
    );
    }
    } else {
    // رسالة خطأ عند ترك حقول فارغة
                             // إذا كان هناك حقل فارغ
                          Get.snackbar(
                            "خطأ",
                            "يرجى ملء جميع الحقول قبل إرسال الطلب",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: const Text(
                        "إرسال",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppConstant.appTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }

}