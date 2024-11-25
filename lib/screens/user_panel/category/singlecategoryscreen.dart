import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/cart.dart';
import '../../../models/products.dart';
import '../../../utils/appconstant.dart';
import '../product/productsdetailsscreen.dart';

class SingleCategoryScreen extends StatefulWidget {
  String? categoryId;
  String? categoryName;
  SingleCategoryScreen({super.key, required this.categoryId,required this.categoryName});

  @override
  State<SingleCategoryScreen> createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  // إضافة المنتج إلى المفضلة
  Future<void> toggleFavorite(ProductModel product, RxBool isFavorite) async {
    if (user != null) {
      try {
        final favoriteRef = FirebaseFirestore.instance
            .collection('favorites')
        //حسب المستخدم الحالي
            .doc(user!.uid)
            .collection('favoriteProducts')
        //حسب المنتج الحالي
            .doc(product.productId);

        //في قيمة true
        if (isFavorite.value==true) {
          await favoriteRef.delete();
          isFavorite.value = false;
        } else {
          await favoriteRef.set({
            'productId': product.productId,
            'productName': product.productName,
            'productImages': product.productImages,
            'salePrice': product.salePrice,
            'fullPrice': product.fullPrice,
            'categoryId': product.categoryId,
            'categoryName': product.categoryName,
            'createdAt': product.createdAt,
            'updateAt': product.updatedAt,
            'productDescription': product.productDescription,
            'isSale': product.isSale,
          });
          isFavorite.value = true;
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  // التحقق إذا كان المنتج في المفضلة
  Future<bool> checkIfFavorite(String productId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .collection('favoriteProducts')
          .doc(productId)
          .get();
      return doc.exists;
    }
      return false;
  }


  // دالة لإضافة المنتج إلى السلة
  Future<void> checkProductExistence({
    required String? uId,
    int? quantityIncrement = 1,
    required ProductModel product,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection("cart")
        .doc(uId)
        .collection("cartOrders")
        .doc(product.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot["productQuantity"];
      int updatedQuantity = currentQuantity + quantityIncrement!;
      double totalPrice = double.parse(product.isSale
          ? product.salePrice
          : product.fullPrice) * updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });
      print("Product quantity updated in cart");
    } else {
      CartModel cartModel = CartModel(
        categoryId: product.categoryId,
        categoryName: product.categoryName,
        createdAt: product.createdAt,
        updateAt: product.updatedAt,
        fullPrice: product.fullPrice,
        productDescription: product.productDescription,
        productId: product.productId,
        productImages: product.productImages,
        productName: product.productName,
        salePrice: product.salePrice,
        isSale: product.isSale,
        sizes: product.sizes,
        colors: product.colors,
        productQuantity: 1,
        productTotalPrice: double.parse(product.fullPrice),
      );

      await documentReference.set(cartModel.toJson());
      print("Product added to cart");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName??'', // عرض اسم التصنيف إذا كان متوفراً
          style: const TextStyle(
            color: AppConstant.appMainColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where("categoryId",isEqualTo:widget.categoryId).get(), // تعديل الاستعلام
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 7,
              child: const Center(child: CupertinoActivityIndicator()),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لم يتم العثور على منتجات!"));
          }

          if (snapshot.hasData) {
            return Container(
              height: Get.height / 2.1,
              width: Get.width ,
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.1, // ضبط نسبة العرض إلى الارتفاع
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  //لان المنتج الذي نريد عرضه
                  ProductModel productModel = ProductModel(
                    categoryId: docData['categoryId'],
                    categoryName: docData['categoryName'],
                    createdAt: docData['createdAt'],
                    updatedAt: docData['updatedAt'],
                    fullPrice: docData['fullPrice'],
                    salePrice: docData['salePrice'],
                    productDescription: docData['productDescription']??'',
                    productId: docData['productId'],
                    productImages: List<String>.from(docData['productImages']),
                    productName: docData['productName'],
                    isSale: docData['isSale'],
                    sizes: List<String>.from(docData['sizes']),
                    colors:  List<String>.from(docData['colors']),
                  );

                  RxBool isFavorite = false.obs;
                  checkIfFavorite(productModel.productId).then((isFav) => isFavorite.value = isFav);


                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(() => ProductDetailsScreen(productModel: productModel)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: productModel.productImages[0],
                                      fit: BoxFit.fill,
                                      height: Get.height / 4,
                                      width: Get.width,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),

                                  Positioned(
                                    child: Obx(() => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      child: IconButton(
                                        icon: Icon(isFavorite.value ? Icons.favorite : Icons.favorite_border),
                                        onPressed: () => toggleFavorite(productModel, isFavorite),
                                        color: isFavorite.value ? Colors.red : Colors.grey,
                                      ),
                                    )),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible( // أو يمكنك استخدام Flexible بدلاً منه
                              child: Text(
                                productModel.productName,
                                textAlign:TextAlign.end,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.visible, // يمكنك ضبط هذا إذا أردت التقطيع أو الإظهار الكامل
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${productModel.fullPrice} ل.س",
                              style: const TextStyle(fontSize: 20, color:AppConstant.appMainColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
