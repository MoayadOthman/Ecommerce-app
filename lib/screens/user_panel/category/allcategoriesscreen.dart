import 'package:cached_network_image/cached_network_image.dart'; // مكتبة لعرض الصور المخزنة مؤقتًا
import 'package:cloud_firestore/cloud_firestore.dart'; // مكتبة Firestore للوصول إلى قاعدة البيانات
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // مكتبة GetX للتحكم في التنقل والحالة
import '../../../models/categories.dart'; // استيراد موديل الفئات
import 'singlecategoryscreen.dart'; // شاشة العرض الفردي للفئة
import '../../../utils/appconstant.dart'; // استيراد الثوابت

// تعريف واجهة شاشة جميع الفئات
class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

// الحالة لشاشة AllCategoriesScreen
class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "جميع التصنيفات",
          style: TextStyle(
            color: AppConstant.appMainColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(), // الحصول على جميع الفئات من Firestore
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"), // عرض رسالة خطأ في حال فشل الحصول على البيانات
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // عرض مؤشر تحميل أثناء انتظار البيانات
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("لا يوجد تصنيفات!"), // عرض رسالة في حال عدم وجود بيانات
            );
          }
          // في حال نجاح تحميل البيانات
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الأعمدة
                crossAxisSpacing: 8, // المسافة الأفقية بين العناصر
                mainAxisSpacing: 12, // المسافة الرأسية بين العناصر
                childAspectRatio: 1.1, // نسبة العرض إلى الارتفاع لكل عنصر
              ),
              itemCount: snapshot.data!.docs.length, // عدد العناصر بناءً على البيانات المحملة
              itemBuilder: (context, index) {
                var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                // إنشاء موديل الفئة باستخدام البيانات المحملة
                CategoryModel categoryModel = CategoryModel(
                  categoryId: docData["categoryId"],
                  categoryImages: docData["categoryImages"],
                  categoryName: docData["categoryName"],
                  createdAt: docData["createdAt"],
                  updatedAt: docData["updatedAt"],
                );

                // تصميم العنصر الخاص بكل فئة
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () => Get.to(() => SingleCategoryScreen(categoryId: categoryModel.categoryId, categoryName: categoryModel.categoryName,)), // الانتقال إلى شاشة عرض الفئة الفردية عند النقر
                    child: Container(
                      width: Get.width / 2.5, // توسيع العرض ليبدو العنصر أكبر
                      height: Get.height/4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // إضافة ظل خفيف للصورة
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: categoryModel.categoryImages, // رابط الصورة
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()), // مؤشر تحميل الصورة
                          errorWidget: (context, url, error) => const Icon(Icons.error), // عرض أيقونة خطأ في حال فشل تحميل الصورة
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
