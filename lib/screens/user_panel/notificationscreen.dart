import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/appconstant.dart';

class NotificationScreen extends StatefulWidget {
  final RemoteMessage? message;
  const NotificationScreen({super.key,  this.message});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الإشعارات",
          style: TextStyle(
            color: AppConstant.appMainColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(user!.uid)
            .collection('notification')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            return const Center(
              child: Text("خطأ"),
            );
          }

          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 7,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          // Handle empty data case
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("ليس هنالك إشعارات!"),
            );
          }

          // Display data if available
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                String docId=snapshot.data!.docs[index].id;

                return GestureDetector(
                  onTap: ()async{
                   var collectionReference = await FirebaseFirestore.instance
                       .collection('notifications')
                       .doc(user!.uid)
                       .collection('notification')
                     ..doc(docId).update({
                      'isSeen':true,
                    });
                  },
                  child: Card(
                    color:snapshot.data!.docs[index]['isSeen']?Colors.green.withOpacity(0.3):Colors.red.withOpacity(0.3),
                    elevation:snapshot.data!.docs[index]['isSeen']? 0:5 ,
                    child: ListTile(
                      leading: CircleAvatar(
                        child:snapshot.data!.docs[index]['isSeen']?Icon(Icons.done) :Icon(Icons.notification_add),
                      ),
                      title: Text(snapshot.data!.docs[index]['title']),
                      subtitle:Text(snapshot.data!.docs[index]['body']),
                    ),
                  ),
                );

                },);
          }

          return Container(); // Return empty container if none of the conditions match
        },
      ),

    );
  }
}
