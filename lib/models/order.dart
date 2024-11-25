// استيراد مكتبة Firestore من Firebase، تُستخدم للتفاعل مع قاعدة بيانات Firestore.
import 'package:cloud_firestore/cloud_firestore.dart';

// تعريف نموذج بيانات الطلب (OrderModel) الذي يمثل تفاصيل الطلبات في التطبيق.
class OrderModel {
  // الحقول التي تصف خصائص الطلب.
  final String orderDate; // تاريخ الطلب
  final List<Map<String, dynamic>>
  orderItems; // قائمة العناصر المضمنة في الطلب، كل عنصر ممثل كمجموعة من المفاتيح والقيم
  final bool orderStatus; // حالة الطلب (مثلاً: تم إنجازه، معلق، إلخ)
  final String userId; // معرف المستخدم الذي قام بالطلب
  final String userName; // اسم المستخدم
  final String userPhone; // رقم هاتف المستخدم
  final String userAddress; // عنوان المستخدم
  final String userToken; // رمز المستخدم (قد يُستخدم للإشعارات أو الأمان)

  // المُنشئ (constructor) لإنشاء كائنات OrderModel جديدة.
  OrderModel({
    required this.orderDate,
    required this.orderItems,
    required this.orderStatus,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.userToken,
  });

  // دالة لتحويل كائن OrderModel إلى صيغة JSON (خريطة) يمكن استخدامها مع قاعدة البيانات.
  Map<String, dynamic> toJson() {
    return {
      'orderDate': orderDate, // تحويل تاريخ الطلب إلى قيمة في صيغة JSON
      'orderItems': orderItems, // تحويل قائمة العناصر إلى صيغة JSON
      'orderStatus': orderStatus, // تحويل حالة الطلب إلى قيمة في صيغة JSON
      'userId': userId, // تحويل معرف المستخدم إلى قيمة في صيغة JSON
      'userName': userName, // تحويل اسم المستخدم إلى قيمة في صيغة JSON
      'userPhone': userPhone, // تحويل رقم الهاتف إلى قيمة في صيغة JSON
      'userAddress': userAddress, // تحويل عنوان المستخدم إلى قيمة في صيغة JSON
      'userToken': userToken, // تحويل رمز المستخدم إلى قيمة في صيغة JSON
    };
  }

  // دالة مصنع (factory constructor) لإنشاء كائن OrderModel جديد من بيانات JSON (خريطة).
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderDate: json['orderDate'] as String, // تحويل الحقل orderDate من صيغة JSON إلى سلسلة نصية
      orderItems: List<Map<String, dynamic>>.from(json['orderItems'] as List), // تحويل الحقل orderItems إلى قائمة من الخرائط
      orderStatus: json['orderStatus'] as bool, // تحويل الحقل orderStatus إلى قيمة منطقية (bool)
      userId: json['userId'] as String, // تحويل الحقل userId إلى سلسلة نصية
      userName: json['userName'] as String, // تحويل الحقل userName إلى سلسلة نصية
      userPhone: json['userPhone'] as String, // تحويل الحقل userPhone إلى سلسلة نصية
      userAddress: json['userAddress'] as String, // تحويل الحقل userAddress إلى سلسلة نصية
      userToken: json['userToken'] as String, // تحويل الحقل userToken إلى سلسلة نصية
    );
  }
}
