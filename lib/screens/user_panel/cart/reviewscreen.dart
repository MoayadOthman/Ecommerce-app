import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:last/models/order.dart';
import 'package:last/models/review.dart';
import '../../../utils/appconstant.dart';

class ReviewScreen extends StatefulWidget {
  final OrderModel orderModel;
  const ReviewScreen({super.key, required  this.orderModel});
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController feedController=TextEditingController();
  double productRating=0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة تقييم",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:AppConstant.appMainColor),),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin:const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("تقييمك و رأيك يسعدنا"),
            SizedBox(
              height: Get.width/12,
            ),
        RatingBar.builder(
        initialRating: 0,
          glow:true,
          ignoreGestures: false,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
          productRating=rating;
          setState(() {

          });
            print(productRating);
          },
        ),
            SizedBox(
              height: Get.width/12,
            ),
            TextFormField(
              controller: feedController,
              decoration: const InputDecoration(
                label: Text("شاركنا رأيك")
              ),
            ),
            SizedBox(
              height: Get.width/12,
            ),
            Material(
                shadowColor:const Color(0xff4a2664) ,
                borderRadius: BorderRadius.circular(40),
                color:AppConstant.appMainColor ,
                child:SizedBox(
                  width: Get.width/5,
                  height: Get.width/12,

                  child: TextButton(onPressed: ()async{
                    EasyLoading.show(status: "انتظر قليلا");
                    String feedback=feedController.text.trim();
                    User? user=FirebaseAuth.instance.currentUser;
                    ReviewModel reviewModel=ReviewModel(
                        customerName: widget.orderModel.userName,
                        customerPhone: widget.orderModel.userPhone,
                        customerDeviceToken: widget.orderModel.userToken,
                        customerId: widget.orderModel.userId,
                        feedback: feedback,
                        rating: productRating.toString(),
                        createdAt:DateTime.now());
                    String? productId = widget.orderModel.orderItems.isNotEmpty ? widget.orderModel.orderItems[0]['productId'] : null;

                    if (productId != null) {
                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(productId)  // استخدم الـ productId هنا
                          .collection('reviews')
                          .doc(user!.uid)
                          .set(reviewModel.toJson());
                    } else {
                      // معالجة الحالة عندما لا يكون productId موجودًا
                      print('Product ID not found');
                    }
                    EasyLoading.dismiss();
                  },
                    child:const Text("تقييم",style: TextStyle(color:AppConstant.appTextColor)),),
                )
            )
        ],
        ),
      ),
    );
  }
}
