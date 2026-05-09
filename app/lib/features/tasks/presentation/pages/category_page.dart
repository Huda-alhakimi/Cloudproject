import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// استيراد مزود الحسابات لمعرفة الـ ID الخاص بالمستخدم الحالي
import '../../../auth/presentation/providers/auth_provider.dart';
// استيراد مزود المهام للتحكم في اللغات وجلب التصنيفات
import '../providers/task_provider.dart';
import '../../domain/models/category_model.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // كائن تحكم لأخذ النص المكتوب من حقل إدخال التصنيف الجديد
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // جلب بيانات مزود المهام وحالة اللغة
    final taskProvider = Provider.of<TaskProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isEn = taskProvider.isEnglish;
    
    // استخراج رقم الـ ID للمستخدم الحالي لربط التصنيف به
    final userId = authProvider.currentUser!.id!;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEn ? 'Manage Categories' : 'إدارة التصنيفات'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // حقل كتابة اسم التصنيف الجديد (مثل: عمل، دراسة، شخصي)
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: isEn ? 'New Category' : 'تصنيف جديد',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // زر الإضافة لحفظ التصنيف في قاعدة البيانات فوراً
                ElevatedButton(
                  onPressed: () {
                    final name = _categoryController.text.trim();
                    if (name.isNotEmpty) {
                      // إرسال بيانات التصنيف الجديد إلى الـ Provider
                      taskProvider.addCategory(
                        CategoryModel(name: name, userId: userId),
                      );
                      _categoryController.clear(); // مسح النص من الحقل بعد الإضافة
                    }
                  },
                  child: Text(isEn ? 'Add' : 'إضافة'),
                )
              ],
            ),
          ),
          // عرض التصنيفات المخزنة في قاعدة البيانات للمستخدم الحالي داخل قائمة
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.categories.length,
              itemBuilder: (context, index) {
                final category = taskProvider.categories[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // حذف التصنيف من قاعدة البيانات باستخدام الـ ID ورقم المستخدم
                      taskProvider.deleteCategory(category.id!, userId);
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
