class CartModel {
  // تعريف الخصائص (الحقول) الخاصة بالكائن:
  final String productId; // معرف المنتج (فريد لكل منتج).
  final String productName; // اسم المنتج.
  final List<String> productImages; // قائمة تحتوي على صور المنتج.
  final String fullPrice; // السعر الكامل للمنتج (بدون خصومات).
  final String? salePrice; // السعر المخفض للمنتج (إذا كان هناك خصم، وإلا قد يكون فارغًا).
  final String productDescription; // وصف المنتج.
  final String categoryId; // معرف الفئة التي ينتمي إليها المنتج.
  final String categoryName; // اسم الفئة.
  final int productQuantity; // الكمية الحالية للمنتج في السلة.
  final double productTotalPrice; // السعر الإجمالي للمنتج بناءً على الكمية.
  final List<String> sizes; // قائمة المقاسات المتاحة للمنتج.
  final List<String> colors; // قائمة الألوان المتاحة للمنتج.
  final String? selectedColor; // اللون الذي اختاره المستخدم (قد يكون فارغًا).
  final String? selectedSize; // المقاس الذي اختاره المستخدم (قد يكون فارغًا).

  // منشئ الكائن (Constructor):التمرير
  CartModel({
    required this.productId, // تحديد معرف المنتج (إجباري).
    required this.productName, // تحديد اسم المنتج (إجباري).
    required this.productImages, // تحديد الصور المتاحة للمنتج (إجباري).
    required this.fullPrice, // تحديد السعر الكامل (إجباري).
    required this.salePrice, // تحديد السعر المخفض (إجباري، قد يكون null).
    required this.productDescription, // تحديد وصف المنتج (إجباري).
    required this.categoryId, // تحديد معرف الفئة (إجباري).
    required this.categoryName, // تحديد اسم الفئة (إجباري).
    required this.productQuantity, // تحديد الكمية (إجباري).
    required this.productTotalPrice, // تحديد السعر الإجمالي (إجباري).
    required this.sizes, // تحديد المقاسات المتاحة (إجباري).
    required this.colors, // تحديد الألوان المتاحة (إجباري).
    this.selectedColor, // اختيار اللون المحدد (اختياري).
    this.selectedSize, // اختيار المقاس المحدد (اختياري).
    required createdAt, // المعامل الخاص بتاريخ الإنشاء (تمرير خارجي).
    required updateAt, // المعامل الخاص بتاريخ التحديث (تمرير خارجي).
    required isSale, // المعامل الخاص بكون المنتج معروضًا بسعر خاص أو لا.
  });

  // تحويل الكائن إلى صيغة JSON لإرسال البيانات إلى قاعدة البيانات.
  Map<String, dynamic> toJson() {
    return {
      'productId': productId, // تحويل معرف المنتج إلى JSON.
      'productName': productName, // تحويل اسم المنتج إلى JSON.
      'productImages': productImages, // تحويل قائمة الصور إلى JSON.
      'fullPrice': fullPrice, // تحويل السعر الكامل إلى JSON.
      'salePrice': salePrice, // تحويل السعر المخفض إلى JSON.
      'productDescription': productDescription, // تحويل وصف المنتج إلى JSON.
      'categoryId': categoryId, // تحويل معرف الفئة إلى JSON.
      'categoryName': categoryName, // تحويل اسم الفئة إلى JSON.
      'productQuantity': productQuantity, // تحويل الكمية إلى JSON.
      'productTotalPrice': productTotalPrice, // تحويل السعر الإجمالي إلى JSON.
      'sizes': sizes, // تحويل قائمة المقاسات إلى JSON.
      'colors': colors, // تحويل قائمة الألوان إلى JSON.
      'selectedColor': selectedColor, // تحويل اللون المحدد إلى JSON.
      'selectedSize': selectedSize, // تحويل المقاس المحدد إلى JSON.
    };
  }
}
