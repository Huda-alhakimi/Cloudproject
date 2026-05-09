import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// استيراد مزود الحسابات لمعرفة بيانات المستخدم الحالي
import '../../../auth/presentation/providers/auth_provider.dart';
// استيراد مزود المهام للتعامل مع قائمة المهام واللغة
import '../providers/task_provider.dart';
import 'category_page.dart';
import 'task_form_page.dart';
import '../../domain/models/task_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جلب بيانات الجلسة لمعرفة من هو المستخدم المسجل حالياً
    final authProvider = Provider.of<AuthProvider>(context);
    // جلب مزود المهام للتحكم في قائمة المهام الحالية وعرضها
    final taskProvider = Provider.of<TaskProvider>(context);
    final isEn = taskProvider.isEnglish;
    final currentUser = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        // عنوان الشاشة يتغير تلقائياً حسب اللغة المحددة
        title: Text(isEn ? 'My Tasks' : 'قائمة مهامي'),
        actions: [
                    // زر تغيير اللغة
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: isEn ? 'Change Language' : 'تغيير اللغة',
            onPressed: () {
              taskProvider.toggleLanguage();
            },
          ),

          // زر ينقل المستخدم إلى واجهة إدارة التصنيفات
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: isEn ? 'Categories' : 'التصنيفات',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
            },
          ),
          // زر لتسجيل الخروج والعودة لشاشة الدخول الرئيسية
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/'); 
            },
          )
        ],
      ),
      // إذا كانت قائمة المهام فارغة تظهر رسالة، وإلا يتم عرض المهام في قائمة
      body: taskProvider.tasks.isEmpty
          ? Center(child: Text(isEn ? 'No tasks yet' : 'لا توجد مهام حالياً'))
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      // وضع خط يتوسط النص إذا كانت المهمة مكتملة ومغلقة
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // مربع الاختيار لتغيير حالة المهمة (مكتملة / غير مكتملة)
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (bool? val) {
                          // تحديث حالة المهمة في الـ Provider وقاعدة البيانات
                          taskProvider.updateTask(
                            TaskModel(
                              id: task.id,
                              title: task.title,
                              description: task.description,
                              isCompleted: val ?? false,
                              userId: task.userId,
                              categoryId: task.categoryId,
                            ),
                          );
                        },
                      ),
                      // زر تعديل المهمة: يمرر بيانات المهمة الحالية بالكامل لواجهة النموذج لتعديلها
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskFormPage(task: task),
                            ),
                          );
                        },
                      ),
                      // زر لحذف المهمة نهائياً من قاعدة البيانات
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          taskProvider.deleteTask(task.id!, currentUser!.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      // زر أسفل الشاشة عائم لإضافة مهمة جديدة
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormPage()),
          );
        },
      ),
    );
  }
}
