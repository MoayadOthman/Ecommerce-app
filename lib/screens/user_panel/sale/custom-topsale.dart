import 'package:cached_network_image/cached_network_image.dart'; // مكتبة لتحميل الصور من الإنترنت مع التخزين المؤقت
import 'package:cloud_firestore/cloud_firestore.dart'; // مكتبة للوصول إلى Firestore
import 'package:flutter/cupertino.dart'; // Widgets لنظام iOS
import 'package:flutter/material.dart'; // مكتبة Material لتصميم واجهات Android
import 'package:get/get.dart'; // مكتبة GetX لإدارة الحالة والتنقل بين الصفحات
import 'package:last/models/products.dart'; // استيراد نموذج البيانات ProductModel
import 'package:last/screens/user_panel/product/productsdetailsscreen.dart'; // شاشة تفاصيل المنتج
import 'package:last/utils/appconstant.dart'; // ثابتات التطبيق، مثل الألوان

class CustomTopSale extends StatelessWidget {
  const CustomTopSale({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isSale', isEqualTo: true).get(), // جلب المنتجات التي عليها خصومات
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("خطأ"), // رسالة خطأ في حالة حدوث مشكلة
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 7, // تعيين ارتفاع مخصص لمؤشر التحميل
            child: const Center(
              child: CupertinoActivityIndicator(), // مؤشر تحميل على شكل iOS
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("لا يوجد حسومات!"), // رسالة توضح عدم وجود منتجات
          );
        }

        if (snapshot.hasData) {
          return Container(
            height: Get.height / 3,
            width: Get.width ,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length, // عدد المنتجات
              shrinkWrap: true,
              scrollDirection: Axis.horizontal, // عرض المنتجات أفقيًا
              itemBuilder: (context, index) {
                var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>; // تحويل البيانات إلى نوع Map

                // إنشاء نموذج للمنتج
                ProductModel productModel = ProductModel(
                  categoryId: docData['categoryId'],
                  categoryName: docData['categoryName'],
                  createdAt: docData['createdAt'],
                  updatedAt: docData['updatedAt'],
                  fullPrice: docData['fullPrice'],
                  salePrice: docData['salePrice'],
                  productDescription: docData['productDescription'] ?? '',
                  productId: docData['productId'],
                  productImages: List<String>.from(docData['productImages']),
                  productName: docData['productName'],
                  isSale: docData['isSale'],
                  colors: List<String>.from(docData['colors']),
                  sizes:  List<String>.from(docData['sizes']),
                );

                return Padding(
                  padding: const EdgeInsets.all(8.0), // إضافة مسافة حول كل عنصر
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: Get.height / 5, // تعيين ارتفاع محدد للصورة
                        child: GestureDetector(
                          onTap: () => Get.to(() => ProductDetailsScreen(productModel: productModel)), // الانتقال إلى شاشة تفاصيل المنتج
                          child:  ClipRRect(
                            borderRadius: BorderRadius.circular(20), // إضافة زوايا دائرية للصورة
                            child: CachedNetworkImage(
                              imageUrl: productModel.productImages[0], // تحميل الصورة من الإنترنت
                              width: Get.width / 3, // تعيين عرض محدد للصورة
                              height: Get.height / 3, // تعيين ارتفاع محدد للصورة
                              fit: BoxFit.cover, // ملء الصورة داخل الإطار
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible( // أو يمكنك استخدام Flexible بدلاً منه
                            child: Text(
                              productModel.productName,
                              textAlign:TextAlign.end,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            " ${productModel.fullPrice}ل.س  ",
                            textAlign: TextAlign.end,// السعر القديم
                            style: const TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontWeight:FontWeight.bold// خط يتوسط السعر القديم
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${productModel.salePrice}ل.س ",
                        textAlign: TextAlign.end,// السعر القديم// السعر الجديد بعد الخصم
                        style: const TextStyle(
                          shadows:[
                            Shadow(offset: Offset(0, 5),color:Colors.grey)
                          ],
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appMainColor, // لون السعر الجديد
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          );
        }

        return Container(); // إرجاع عنصر فارغ إذا لم تتطابق أي من الشروط
      },
    );
  }
}
