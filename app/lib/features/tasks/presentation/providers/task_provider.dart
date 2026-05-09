import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/category_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<TaskModel> _tasks = []; // قائمة المهام الحالية
  List<CategoryModel> _categories = []; // قائمة التصنيفات الحالية
  
  // لغات التطبيق: false تعني لغة عربية، و true تعني لغة إنجليزية
  bool _isEnglish = false; 

  // دوال الـ Getters للوصول للبيانات من الواجهات
  List<TaskModel> get tasks => _tasks;
  List<CategoryModel> get categories => _categories;
  bool get isEnglish => _isEnglish;

  // 1. دالة تغيير لغة التطبيق وتحديث الواجهات فوراً
  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners(); // إشعار الواجهات بالتحديث لتغيير النصوص فوراً
  }

  // 2. دالة جلب المهام من قاعدة البيانات بناءً على رقم المستخدم
  Future<void> fetchTasks(int userId) async {
    _tasks = await _taskRepository.getTasks(userId);
    notifyListeners();
  }

  // 3. دالة جلب التصنيفات بناءً على رقم المستخدم
  Future<void> fetchCategories(int userId) async {
    _categories = await _taskRepository.getCategories(userId);
    notifyListeners();
  }

  // 4. دالة إضافة مهمة جديدة
  Future<void> addTask(TaskModel task) async {
    await _taskRepository.addTask(task);
    await fetchTasks(task.userId); // إعادة جلب المهام لتحديث القائمة فوراً
  }

  // 5. دالة تعديل مهمة موجودة مسبقاً
  Future<void> updateTask(TaskModel task) async {
    await _taskRepository.updateTask(task);
    await fetchTasks(task.userId);
  }

  // 6. دالة حذف مهمة معينة
  Future<void> deleteTask(int taskId, int userId) async {
    await _taskRepository.deleteTask(taskId);
    await fetchTasks(userId);
  }

  // 7. دالة إضافة تصنيف جديد
  Future<void> addCategory(CategoryModel category) async {
    await _taskRepository.addCategory(category);
    await fetchCategories(category.userId); // تحديث قائمة التصنيفات فوراً
  }

  // 8. دالة حذف تصنيف معين
  Future<void> deleteCategory(int categoryId, int userId) async {
    await _taskRepository.deleteCategory(categoryId);
    await fetchCategories(userId);
  }
}
