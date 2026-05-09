class TaskModel {
  final int? id; // رقم المهمة التعريفي (تلقائي من قاعدة البيانات)
  final String title; // عنوان المهمة
  final String description; // وصف المهمة
  final bool isCompleted; // حالة المهمة: true للمكتملة، و false لغير المكتملة
  final int userId; // رقم المستخدم الذي يمتلك هذه المهمة (مفتاح أجنبي)
  final int categoryId; // رقم التصنيف الذي تتبع له المهمة (مفتاح أجنبي)

  // المشيد (Constructor) لبناء الكائن وتمرير البيانات المطلوبة
  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false, // القيمة الافتراضية هي غير مكتملة
    required this.userId,
    required this.categoryId,
  });

  // دالة تحويل البيانات من كائن (Model) إلى خريطة (Map) لحفظها في الـ SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // الـ SQLite لا تدعم Boolean مباشرة، لذا نخزن 1 للمكتمل و 0 لغير المكتمل
      'isCompleted': isCompleted ? 1 : 0,
      'userId': userId,
      'categoryId': categoryId,
    };
  }

  // دالة تحويل البيانات القادمة من قاعدة البيانات (Map) إلى كائن برمجى (Model)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      // تحويل الرقم (1 أو 0) القادم من قاعدة البيانات إلى true أو false
      isCompleted: map['isCompleted'] == 1,
      userId: map['userId'],
      categoryId: map['categoryId'],
    );
  }
}
