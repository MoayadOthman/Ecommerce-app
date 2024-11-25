import 'package:cached_network_image/cached_network_image.dart'; // مكتبة لتحميل الصور من الإنترنت مع التخزين المؤقت
import 'package:cloud_firestore/cloud_firestore.dart'; // مكتبة للوصول إلى Firebase Firestore
import 'package:flutter/cupertino.dart'; // Widgets لنظام iOS
import 'package:flutter/material.dart'; // مكتبة Material لتصميم واجهات Android
import 'package:get/get.dart'; // مكتبة GetX لإدارة الحالة والتنقل بين الصفحات
import 'singlecategoryscreen.dart'; // استيراد شاشة لعرض فئة واحدة
import '../../../models/categories.dart'; // استيراد النموذج الخاص بالفئات (categories)

class CustomCategories extends StatelessWidget {
  const CustomCategories({super.key}); // إنشاء واجهة مخصصة للفئات

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //خطأ في البيانات القادمة
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }
        //البيانات قيد التحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 5,
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        //الملفات فارغة
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("لا يوجد تصنيفات!"),
          );
        }
        //هنالك بيانات ارجاعها على شكل ListView.builder
        if (snapshot.hasData) {
          return SizedBox(
            height: Get.height / 6, // ضبط الارتفاع لعرض البطاقات بشكل أفضل
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                //لتحزين الببانات على شكل خريطة للاستفادة منها لاحثة ضمن نموذج
                var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                //نستحدم نموذج لسهولة الوصول للبيانات القادمة من النت
                CategoryModel categoryModel = CategoryModel(
                  categoryId: docData["categoryId"],
                  categoryImages: docData["categoryImages"],
                  categoryName: docData["categoryName"],
                  createdAt: docData["createdAt"],
                  updatedAt: docData["updatedAt"],
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    //لانتقال تاى صفحة محنوى التصنيف محدد و يتم معرفة ذلك من خلال معرف
                    onTap: () => Get.to(() => SingleCategoryScreen(categoryId: categoryModel.categoryId, categoryName: categoryModel.categoryName,)),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: CachedNetworkImageProvider( categoryModel.categoryImages),
                        ),
                        Text(
                          categoryModel.categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
