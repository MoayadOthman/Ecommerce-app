import 'package:cached_network_image/cached_network_image.dart'; // مكتبة لتحميل الصور من الإنترنت مع التخزين المؤقت
import 'package:carousel_slider/carousel_slider.dart'; // مكتبة لإنشاء شريط تمرير للصور (Carousel)
import 'package:cloud_firestore/cloud_firestore.dart'; // مكتبة للوصول إلى Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // مكتبة للمصادقة على المستخدمين باستخدام Firebase
import 'package:flutter/cupertino.dart'; // Widgets لنظام iOS
import 'package:flutter/material.dart'; // مكتبة Material لتصميم واجهات Android
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart'; // مكتبة GetX لإدارة الحالة والتنقل بين الصفحات
import 'package:last/models/cart.dart'; // استيراد نموذج (model) عربة التسوق
import 'package:last/models/products.dart'; // استيراد نموذج (model) المنتجات
import 'package:last/models/review.dart';
import 'package:last/utils/appconstant.dart'; // استيراد ثوابت التطبيق
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../controllers/favorite.dart';
import '../../../controllers/rating.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel; // متغير لتخزين نموذج المنتج
  ProductDetailsScreen({super.key, required this.productModel}); // Constructor لاستقبال نموذج المنتج

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState(); // إنشاء حالة الواجهة
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;// الحصول على معلومات المستخدم الحالي من Firebase
  String? selectedSize;
  String? selectedColor;
  @override

  Widget build(BuildContext context) {
    CalculateRatingController calculateRatingController=Get.put(CalculateRatingController(widget.productModel.productId));

    Future<void> toggleFavorite(ProductModel product, RxBool isFavorite) async {
      if (user != null) {
        try {
          final favoriteRef = FirebaseFirestore.instance
              .collection('favorites')
              .doc(user!.uid)
              .collection('favoriteProducts')
              .doc(product.productId);

          if (isFavorite.value) {
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

    
    RxBool isFavorite = false.obs;
    checkIfFavorite(widget.productModel.productId).then((isFav) => isFavorite.value = isFav);
    
    return Scaffold(
      appBar: AppBar(
        title:const Text('تفاصيل المنتج',style: TextStyle(color:AppConstant.appScendoryColor,fontSize: 22,fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          Obx(() => Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.3),
            ),
            child: IconButton(
              icon: Icon(isFavorite.value ? Icons.favorite : Icons.favorite_border),
              onPressed: () => toggleFavorite(widget.productModel, isFavorite),
              color: isFavorite.value ? Colors.red : Colors.grey,
            ),
          )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // شريط تمرير للصور (Carousel) للمنتج
              CarouselSlider(
                items: widget.productModel.productImages.map((imagesUrls) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: imagesUrls, // تحميل الصورة من الرابط
                    fit: BoxFit.cover, // ملائمة الصورة
                    width: Get.width - 10, // تعيين عرض الصورة
                    //اذا صورة عم تتحمل
                    placeholder: (context, url) => const ColoredBox(
                      color: Colors.white,
                      child: Center(
                        child: CupertinoActivityIndicator(), // مؤشر تحميل
                      ),
                    ),
                    //خطأ في تحميل
                    errorWidget: (context, url, error) => const Icon(Icons.error), // عرض أيقونة خطأ في حال فشل التحميل
                  ),
                )).toList(),
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal, // اتجاه التمرير أفقي
                  autoPlay: true, // تشغيل الصور تلقائيًا
                  aspectRatio: 1.8, // نسبة العرض إلى الارتفاع
                  viewportFraction: 1, // عرض جزء من الصورة
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج وسعره
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productModel.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        // تحديد السعر حسب حالة الخصم

                      ],
                    ),
                    widget.productModel.isSale == true && widget.productModel.salePrice !=""
                        ? Text(
                      "${widget.productModel.salePrice} ل.س",
                      style: const TextStyle(color: AppConstant.appScendoryColor, fontSize: 22),
                    )
                        : Text(
                      "${widget.productModel.fullPrice} ل.س",
                      style: const TextStyle(color: AppConstant.appScendoryColor, fontSize: 22),
                    ),
                    RatingBar.builder(
                      initialRating:double.parse(calculateRatingController.averageRating.toString()),
                      glow: false,
                      ignoreGestures: true,
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
                        setState(() {

                        });
                      },
                    ),
                    Text(calculateRatingController.averageRating.toString()),

                    // عرض اسم الفئة ووصف المنتج
                    Text(
                      widget.productModel.categoryName,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 22),
                    ),
                    Text(
                      widget.productModel.productDescription,
                      style: const TextStyle(fontSize: 20),
                    ),
                    // الكود المعدل
                    const Text(
                      "الألوان المتاحة:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      // جزء من الكود لرفع الألوان وعرضها
                      // مكان عرض الألوان في شاشة المنتج
                    Wrap(
                      spacing: 8.0,
                      children: widget.productModel.colors.map((color) {
                        return ChoiceChip(
                          label: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Color(int.parse("0xFF$color")), // تحويل النص إلى كود اللون (بإضافة شفافية ثابتة 0xFF)
                              shape: BoxShape.circle,
                            ),
                          ),
                          selected: selectedColor == color,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedColor = selected ? color : null; // تحديد اللون أو إلغاء تحديده
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

          // في الـ ChoiceChip الخاصة بالمقاسات:
                    const Text(
                      "المقاسات المتاحة:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: widget.productModel.sizes.map((size) {
                        return ChoiceChip(
                          label: Text(size),
                          selected: selectedSize == size,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedSize = selected ? size : null; // تحديد المقاس أو إلغاء تحديده
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // أزرار إضافة المنتج إلى عربة التسوق
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppConstant.appScendoryColor, // لون الخلفية
                              borderRadius: BorderRadius.circular(30.0), // حواف دائرية
                            ),
                            height: Get.height / 12,
                            width: Get.width/1.8,

                            child: TextButton(
                              onPressed: () async {
                                await checkProductExistence(uId: user?.uid); // استدعاء الدالة للتحقق من وجود المنتج في العربة
                              },
                              child: const Text(
                                "إضافة الى السلة",
                                style: TextStyle(color: AppConstant.appTextColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Material(
                          child: Container(
                            decoration: BoxDecoration(
                              color:Color(0xFF2D8F65), // لون الخلفية
                              borderRadius: BorderRadius.circular(30.0), // حواف دائرية
                            ),
                            height: Get.height / 12,
                            width: Get.width/5,
                            child: TextButton(
                              onPressed: () async {
                                //ارسال كل المنتج
                                sendMessageOnWhatsApp(
                                    productModel:widget.productModel
                                );
                              },
                              child: const Text(
                                textAlign: TextAlign.center,
                                "تواصل عبر الواتس آب",
                                style: TextStyle(color: AppConstant.appTextColor),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('products').doc(widget.productModel.productId).collection('reviews').get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Handle errors
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("خطأ"),
                    );
                  }

                  // Show loading indicator while waiting for data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Handle empty data case
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("ليس هنالك تقييمات !"),
                    );
                  }

                  // Display data if available
                  if (snapshot.hasData) {
                    return
                     ListView.builder(
                       physics: const BouncingScrollPhysics(),
                       shrinkWrap: true,
                       itemCount: snapshot.data!.docs.length,
                       itemBuilder:(context, index) {
                         var data=snapshot.data!.docs[index];
                       ReviewModel reviewModel=ReviewModel(
                           customerName: data['customerName'],
                           customerPhone: data['customerPhone'],
                           customerDeviceToken: data['customerDeviceToken'],
                           customerId: data['customerId'],
                           feedback: data['feedback'],
                           rating:data['rating'],
                           createdAt: data['createdAt'],);
                         return Card(
                           elevation: 5,
                           child: ListTile(
                             title: Text(reviewModel.customerName),
                             subtitle: Text(reviewModel.feedback),
                             leading: CircleAvatar(
                               child: Text(reviewModel.customerName),
                             ),
                             trailing:Text(reviewModel.rating),
                           ),
                         );

                       },);
                  }

                  return Container(); // Return empty container if none of the conditions match
                },
              )

            ],
          ),
        ),
      ),
    );
  }


  static Future<void> sendMessageOnWhatsApp({
    required ProductModel productModel
  }) async {
    // تحديد رقم الهاتف المراد إرسال الرسالة إليه عبر واتساب.
    const number = "+963966327142";

    // إنشاء الرسالة التي سيتم إرسالها، مع إدراج اسم ومعرّف المنتج.
    final message = "مرحبا\nاريد معرفة المزيد من المعلومات عن المنتج\n ${productModel.productName}\n";

    // إنشاء رابط URL باستخدام رقم الهاتف والرسالة.
    final Uri url = Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(message)}');

    // فتح الرابط باستخدام launchUrl لإرسال الرسالة عبر واتساب.
    await launchUrl(url);
  }

  Future<void> checkProductExistence({
    required String? uId,
    int? quantityIncrement = 1,
  }) async {
    // التحقق إذا كان المستخدم قد اختار اللون والمقاس قبل المتابعة.
    if (selectedColor == null || selectedSize == null) {
      // عرض رسالة للمستخدم تفيد بضرورة اختيار اللون والمقاس.
      VxToast.show(
        context,
        msg: "يرجى اختيار اللون والمقاس أولاً",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
      // إنهاء تنفيذ الدالة إذا لم يتم تحديد اللون أو المقاس.
      return;
    }

    // إنشاء مرجع الوثيقة في قاعدة بيانات Firestore بناءً على معرف المستخدم واللون والمقاس.
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection("cart")
        //لمستخدم الحالي
        .doc(uId)
        .collection("cartOrders")
        .doc("${widget.productModel.productId}");

    // الحصول على مستند البيانات من قاعدة البيانات.
    DocumentSnapshot snapshot = await documentReference.get();

    // التحقق مما إذا كانت الوثيقة موجودة في قاعدة البيانات.
    if (snapshot.exists) {
      // إذا كان المنتج موجودًا بالفعل في السلة، يتم جلب الكمية الحالية.
      int currentQuantity = snapshot["productQuantity"];

      // حساب الكمية المحدثة عن طريق زيادة الكمية الحالية.
      int updatedQuantity = currentQuantity + (quantityIncrement ?? 1);

      // حساب السعر الإجمالي بناءً على الكمية المحدثة والسعر (سواء كان سعر خصم أم كامل).
      double totalPrice = double.parse(widget.productModel.isSale
          ? widget.productModel.salePrice
          : widget.productModel.fullPrice) * updatedQuantity;

      // تحديث الكمية والسعر الإجمالي في قاعدة البيانات.
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });

      // طباعة رسالة تأكيد وتحديث الكمية في السلة.
      print("product exists and updated");

      // عرض رسالة للمستخدم تفيد بتحديث الكمية.
      VxToast.show(
        context,
        msg: "تم تحديث الكمية",
        bgColor: AppConstant.appMainColor,
        textColor: AppConstant.appTextColor,
      );
    }
    else {
      // إذا لم يكن المنتج موجودًا، يتم إنشاء وثيقة جديدة للمستخدم في قاعدة بيانات "cart".
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });

      // إنشاء نموذج يحتوي على تفاصيل المنتج المراد إضافته إلى السلة.
      CartModel cartModel = CartModel(
        categoryId: widget.productModel.categoryId,
        categoryName: widget.productModel.categoryName,
        createdAt: widget.productModel.createdAt,
        updateAt: widget.productModel.updatedAt,
        fullPrice: widget.productModel.fullPrice,
        productDescription: widget.productModel.productDescription,
        productId: widget.productModel.productId,
        productImages: widget.productModel.productImages,
        productName: widget.productModel.productName,
        salePrice: widget.productModel.salePrice,
        isSale: widget.productModel.isSale,
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.fullPrice),
        colors: [selectedColor ?? ''],
        sizes: [selectedSize ?? ''],
        selectedColor: selectedColor,
        selectedSize: selectedSize,
      );


      // إضافة المنتج الجديد إلى قاعدة البيانات.
      await documentReference.set(cartModel.toJson());

      // طباعة رسالة تأكيد إضافة المنتج.
      print("product added");

      // عرض رسالة للمستخدم تفيد بإضافة المنتج بنجاح.
      VxToast.show(
        bgColor: AppConstant.appMainColor,
        textColor: AppConstant.appTextColor,
        context,
        msg: 'تم إضافة المنتج',
      );
    }
  }

}
