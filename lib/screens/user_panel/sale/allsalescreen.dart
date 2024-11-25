import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last/screens/user_panel/product/productsdetailsscreen.dart';
import 'package:last/utils/appconstant.dart';
import '../../../models/products.dart';

class AllSaleScreen extends StatefulWidget {
  const AllSaleScreen({Key? key}) : super(key: key);

  @override
  State<AllSaleScreen> createState() => _AllSaleScreenState();
}

class _AllSaleScreenState extends State<AllSaleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "جميع الحسومات",
          style: TextStyle(
            color: AppConstant.appScendoryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where("isSale", isEqualTo: true)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا يوجد حسومات!"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58, // Adjusted for better layout
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
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
                sizes: List<String>.from(docData['sizes']),
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => ProductDetailsScreen(productModel: productModel)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: productModel.productImages.isNotEmpty
                              ? productModel.productImages[0]
                              : '', // Check for empty list
                          width: Get.width / 2.5,
                          height: Get.height / 4,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      productModel.productName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${productModel.fullPrice} S.P",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      "${productModel.salePrice} S.P",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.appMainColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
