// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:last/models/products.dart';
// import 'package:get/get.dart';
// import 'package:last/screens/user_panel/productsdetailsscreen.dart';
// import 'package:last/utils/appconstant.dart';
//
// class ProductSearchScreen extends StatefulWidget {
//   @override
//   _ProductSearchScreenState createState() => _ProductSearchScreenState();
// }
//
// class _ProductSearchScreenState extends State<ProductSearchScreen> {
//   String searchQuery = ""; // متغير لتخزين استعلام البحث
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("البحث عن منتج",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: AppConstant.appMainColor),),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: const InputDecoration(
//                 enabledBorder: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(30)
//                   ),
//                 ),
//                 focusedBorder:const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                         Radius.circular(30)
//                     )
//                 ) ,
//                 hintText: "ادخل اسم المنتج",
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   searchQuery = value.trim(); // تحديث استعلام البحث عند إدخال المستخدم
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: searchQuery.isEmpty
//                 ? const Center(child: Text("لا يوجد بحث"))
//                 : StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('products')
//                   .where('productName', isGreaterThanOrEqualTo: searchQuery)
//                   .where('productName', isLessThan: searchQuery + 'z')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("حدث خطأ ما!"));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("المنتج غير موجود"));
//                 }
//
//                 return ListView(
//                   children: snapshot.data!.docs.map((doc) {
//                     ProductModel product = ProductModel.fromSnapshot(doc); // تحويل المستند إلى نموذج المنتج
//                     return Card(
//                       elevation: 5,
//                       color:Colors.white54,
//                       child: ListTile(
//                         title: Text(product.productName,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
//                         subtitle:Text(product.categoryName,style: const TextStyle(color:Colors.black45,fontSize:16),),
//                       trailing:Text("${product.salePrice} ل.س",style: const TextStyle(color: AppConstant.appMainColor,fontSize: 16),),
//                         leading: product.productImages.isNotEmpty
//                             ? Image.network(product.productImages[0], width: 50, height: 50)
//                             : const Icon(Icons.image),
//                         onTap: () {
//                           Get.to(ProductDetailsScreen(productModel: product)); // الانتقال إلى صفحة تفاصيل المنتج
//                         },
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
