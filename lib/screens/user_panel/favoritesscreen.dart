import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last/utils/appconstant.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المنتجات المفضلة",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:AppConstant.appMainColor),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .doc(user!.uid)
            .collection('favoriteProducts')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("خطأ في تحميل المنتجات المفضلة"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("قائمتك المفضلة فارغة!"),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return Card(
                  elevation: 5,
                  color:Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: docData['productImages'][0] ?? '', // التأكد من وجود 'productImage' وليس 'productImages'
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    title: Text(
                      docData['productName'] , // Assuming 'productName' field
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${docData['fullPrice']?.toString()} ل.س', // Assuming 'productPrice' field
                      style: const TextStyle(fontSize: 16, color:AppConstant.appMainColor),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: AppConstant.appMainColor),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('favorites')
                            .doc(user!.uid)
                            .collection('favoriteProducts')
                            .doc(docData['productId']) // Assuming 'productId' field
                            .delete();
                      },
                    ),
                  ),
                );
              },
            );
          }

          return Container(); // Return empty container if none of the conditions match
        },
      ),
    );
  }
}
