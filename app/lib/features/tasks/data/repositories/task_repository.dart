import '../../../../core/database/db_helper.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/category_model.dart'; // استيراد موديل التصنيفات الجديد

class TaskRepository {
  final DBHelper _dbHelper = DBHelper(); // أخذ نسخة من قاعدة البيانات للتعامل معها

  // 1. دالة لجلب كل المهام الخاصة بمستخدم معين
  Future<List<TaskModel>> getTasks(int userId) async {
    final db = await _dbHelper.database; // فتح الاتصال بقاعدة البيانات
    // جلب المهام التي تتطابق مع رقم المستخدم المسجل حالياً
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    // تحويل قائمة الـ Maps القادمة من قاعدة البيانات إلى قائمة من الـ TaskModel
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  // 2. دالة لإضافة مهمة جديدة إلى قاعدة البيانات
  Future<int> addTask(TaskModel task) async {
    final db = await _dbHelper.database;
    // إدخال بيانات المهمة وإرجاع رقم الـ ID الذي تم إنشاؤه لها تلقائياً
    return await db.insert('tasks', task.toMap());
  }

  // 3. دالة لتعديل بيانات مهمة موجودة مسبقاً
  Future<int> updateTask(TaskModel task) async {
    final db = await _dbHelper.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // 4. دالة لحذف مهمة معينة
  Future<int> deleteTask(int taskId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // ==================== دوال التصنيفات الجديدة ====================

  // 5. دالة لجلب كافة التصنيفات الخاصة بمستخدم معين
  Future<List<CategoryModel>> getCategories(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  // 6. دالة لإضافة تصنيف جديد
  Future<int> addCategory(CategoryModel category) async {
    final db = await _dbHelper.database;
    return await db.insert('categories', category.toMap());
  }

  // 7. دالة لحذف تصنيف معين
  Future<int> deleteCategory(int categoryId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }
}
