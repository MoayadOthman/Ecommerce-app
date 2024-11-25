import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cartprice.dart';
import '../../../utils/appconstant.dart';
import 'checkoutscreen.dart';

class CartScreen extends StatefulWidget {
  final String userId;
  final CartController cartController;

  CartScreen({super.key, required this.userId})
      : cartController = Get.put(CartController(userId));

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سلة المنتجات",
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:AppConstant.appMainColor),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.cartController.cartCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('خطأ في تحميل البيانات'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('سلة المنتجات فارغة'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {

                    var data = snapshot.data!.docs[index];
                    String productId = data.id;
                    String productName = data['productName'];
                    int productQuantity = data['productQuantity'];
                    double productPrice = double.parse(data['fullPrice']);
                    double productTotalPrice = data['productTotalPrice'];
                    String selectedColor = data['selectedColor'] ?? 'غير محدد';
                    String selectedSize = data['selectedSize'] ?? 'غير محدد';
                    String productImage = data['productImages'] != null && data['productImages'].isNotEmpty ? data['productImages'][0] :'';

                    return Card(
                      elevation: 5,
                      color:Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(productImage),
                                  fit: BoxFit.cover,
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
                                    productName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const Text('اللون:  '),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _colorFromHex(selectedColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: Get.width/25,
                                      ),
                                      Row(
                                        children: [
                                          const Text('القياس: ',),
                                          Text(selectedSize,style:const TextStyle(fontWeight: FontWeight.bold),),

                                        ],
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await widget.cartController.updateQuantity(
                                            productId,
                                            productQuantity - 1,
                                            productPrice,
                                          );
                                        },
                                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                                      ),
                                      Text('$productQuantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      IconButton(
                                        onPressed: () async {
                                          await widget.cartController.updateQuantity(
                                            productId,
                                            productQuantity + 1,
                                            productPrice,
                                          );
                                        },
                                        icon: const Icon(Icons.add_circle, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  // دالة لتحويل النص إلى لون
  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // افتراضي لإضافة الشفافية
    }
    return Color(int.parse('0x$hexColor'));
  }

  // دالة بناء القسم السفلي لعرض السعر الكلي وزر التحقق
  Widget _buildBottomSection() {
    return Obx(() {
      return Container(
        height: Get.height / 8,
        padding: const EdgeInsets.all(20),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              " السعر الكلي : ${widget.cartController.totalCartPrice.value.toStringAsFixed(2)} ل.س", // استخدام .value للوصول إلى قيمة RxDouble
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Material(
              color: AppConstant.appScendoryColor,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: Get.width / 4,
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const CheckoutScreen());
                    },
                    child: const Text(
                      "تحقق",
                      style: TextStyle(
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
    });
  }
}
