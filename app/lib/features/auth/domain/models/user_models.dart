class UserModel {
  final int? id; // رقم تعريف المستخدم الفريد (تلقائي الزيادة)
  final String username; // اسم المستخدم المعتمد لتسجيل الدخول
  final String password; // كلمة المرور الخاصة بالمستخدم

  // مشيّد الكلاس لتمرير البيانات عند إنشاء مستخدم جديد
  UserModel({
    this.id,
    required this.username,
    required this.password,
  });

  // هذه الدالة لتحويل بيانات المستخدم إلى Map ليتم حفظها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // هذه الدالة لتحويل البيانات القادمة من قاعدة البيانات إلى كائن Model نستخدمه في Flutter
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
