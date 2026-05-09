import '../../../../core/database/db_helper.dart';
import '../../domain/models/user_models.dart';

class AuthRepository {
  final DBHelper _dbHelper = DBHelper(); // جلب نسخة من قاعدة البيانات المجهزة سابقاً

  // دالة لتسجيل مستخدم جديد في قاعدة البيانات
  Future<int> registerUser(UserModel user) async {
    final db = await _dbHelper.database;
    // نقوم بتحويل بيانات المستخدم إلى Map وحفظها في جدول المستخدمين
    return await db.insert('users', user.toMap());
  }

  // دالة للتحقق من بيانات تسجيل الدخول
  Future<UserModel?> loginUser(String username, String password) async {
    final db = await _dbHelper.database;
    // نبحث في جدول المستخدمين عن تطابق الاسم وكلمة المرور
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    // إذا وجدنا تطابقاً نعيد بيانات المستخدم بعد تحويلها من Map إلى Model
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null; // إذا لم نجد تطابقاً نعيد قيمة فارغة
  }
}
