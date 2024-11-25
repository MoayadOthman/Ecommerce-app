import 'dart:math'; // استيراد مكتبة الرياضيات في دارت لاستخدام الكلاس Random لتوليد أرقام عشوائية.

String genrateOrderId() { // تعريف دالة باسم genrateOrderId تُرجع قيمة من نوع String.
  DateTime now = DateTime.now(); // الحصول على التاريخ والوقت الحاليين.

  int randomNumbers = Random().nextInt(99999); // توليد رقم عشوائي بين 0 و99999.
  String id = '${now.microsecondsSinceEpoch}_$randomNumbers'; // إنشاء معرف فريد يجمع بين الوقت الحالي والرقم العشوائي.

  return id; // إرجاع المعرف الذي تم إنشاؤه.
}
