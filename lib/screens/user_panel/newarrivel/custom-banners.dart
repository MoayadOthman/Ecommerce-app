import 'package:cached_network_image/cached_network_image.dart'; // مكتبة لتحميل الصور من الإنترنت مع التخزين المؤقت
import 'package:cloud_firestore/cloud_firestore.dart'; // مكتبة للوصول إلى Firebase Firestore
import 'package:flutter/cupertino.dart'; // Widgets لنظام iOS
import 'package:flutter/material.dart'; // مكتبة Material لتصميم واجهات Android
import 'package:get/get.dart'; // مكتبة GetX لإدارة الحالة والتنقل بين الصفحات
import 'package:carousel_slider/carousel_slider.dart'; // مكتبة لعرض الصور المتحركة (السلايدر)
import '../../../models/arrivelmodel.dart';

class CustomArrival extends StatelessWidget {
  const CustomArrival({Key? key}) : super(key: key); // واجهة مخصصة لعرض العناصر القادمة

  @override
  Widget build(BuildContext context) {
    // FutureBuilder لبناء الواجهة باستخدام البيانات القادمة من Firestore
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('newArrival').get(), // استعلام للحصول على بيانات المجموعة "newArrival"
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // في حالة وجود خطأ في البيانات القادمة
        if (snapshot.hasError) {
          return const Center(
            child: Text("حدث خطأ أثناء جلب البيانات."), // رسالة خطأ
          );
        }

        // عرض مؤشر أثناء تحميل البيانات
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.height / 5, // تحديد ارتفاع الحاوية أثناء التحميل
            child: const Center(
              child: CupertinoActivityIndicator(), // مؤشر تحميل
            ),
          );
        }

        // في حال كانت البيانات فارغة
        if (snapshot.data!.docs.isEmpty) {
          return   const Center(
            child: Text("لا يوجد البيانات."), // رسالة خطأ
          );
        }

        // عرض البيانات على شكل ListView.builder في حال نجاح الجلب
        if (snapshot.hasData) {
          return SizedBox(
            height: Get.height / 4, // ضبط الارتفاع لعرض البطاقات
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length, // عدد العناصر المسترجعة
              shrinkWrap: true,
              scrollDirection: Axis.horizontal, // تمرير أفقي
              itemBuilder: (context, index) {

                // تحويل البيانات القادمة جيسون إلى خريطة (Map)
                var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;


                // استخدام نموذج (Model) للوصول للبيانات
                ArrivelModel arrivalModel = ArrivelModel(
                  arrivalName: docData['arrivalName'],
                  arrivalId: docData['arrivalId'],
                  categoryImages: docData['categoryImages'],
                  createdAt: docData['createdAt'],
                  updatedAt: docData['updatedAt'],
                );

                // عرض الصور باستخدام CarouselSlider
                // عرض الصور باستخدام CarouselSlider


                return CarouselSlider(
                  items: arrivalModel.categoryImages.map<Widget>
                    ((imageUrl) => ClipRRect(
                    borderRadius: BorderRadius.circular(0), // إضافة زوايا دائرية
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,// تحميل الصورة
                      height:Get.height,// ضبط حجم الصورة
                      width: Get.width , // تحديد عرض الصورة
                      placeholder: (context, url) =>
                      const ColoredBox(
                        color: Colors.white,
                        child: Center(
                          child: CupertinoActivityIndicator(), // مؤشر تحميل
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error), // عرض أيقونة عند الخطأ
                    ),
                  )).toList(),
                  options: CarouselOptions(
                    scrollDirection: Axis.horizontal, // تمرير أفقي
                    autoPlay: true, // تشغيل تلقائي
                    aspectRatio: 1.8, // نسبة العرض إلى الارتفاع
                    viewportFraction: 1, // عرض عنصر واحد
                  ),
                );
              },
            ),
          );
        }

        return Container(); // حاوية فارغة في حالة عدم تطابق أي من الحالات
      },
    );
  }
}
