class CategoryModel {
  final int? id; // رقم التصنيف التعريفي (تلقائي من قاعدة البيانات)
  final String name; // اسم التصنيف (مثلاً: عمل، دراسة، شخصي)
  final int userId; // رقم المستخدم الذي أنشأ هذا التصنيف (مفتاح أجنبي لربطه بالمستخدم)

  // المشيد (Constructor) لبناء كائن التصنيف وتمرير البيانات المطلوبة
  CategoryModel({
    this.id,
    required this.name,
    required this.userId,
  });

  // دالة تحويل البيانات من كائن (Model) إلى خريطة (Map) لحفظها في الـ SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
    };
  }

  // دالة تحويل البيانات القادمة من قاعدة البيانات (Map) إلى كائن برمجى (Model)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
    );
  }
}
