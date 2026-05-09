import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// استيراد مزود الحسابات لمعرفة رقم المستخدم الحالي
import '../../../auth/presentation/providers/auth_provider.dart';
// استيراد مزود المهام للتحكم باللغات وتنفيذ الحفظ والتعديل
import '../providers/task_provider.dart';
import '../../domain/models/task_model.dart';

class TaskFormPage extends StatefulWidget {
  // استقبال بيانات المهمة كمعامل (Parameter) اختياري؛ إذا كان موجوداً فهذا يعني (تعديل)، وإذا كان فارغاً يعني (إضافة جديدة)
  final TaskModel? task; 

  const TaskFormPage({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  // كائنات التحكم لقراءة النصوص المدخلة من حقول عنوان المهمة ووصفها
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int? _selectedCategoryId; // متغير لتخزين رقم التصنيف الذي يختاره المستخدم من القائمة

  @override
  void initState() {
    super.initState();
    // إذا كان هناك بيانات مهمة مرسلة مسبقاً (في حالة التعديل)، نقوم بملء الحقول تلقائياً
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedCategoryId = widget.task!.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    // جلب بيانات مزود المهام وحالة اللغة
    final taskProvider = Provider.of<TaskProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isEn = taskProvider.isEnglish;
    
    // استخراج رقم الـ ID للمستخدم الحالي لربط المهمة بحسابه
    final userId = authProvider.currentUser!.id!;

    return Scaffold(
      appBar: AppBar(
        // يتغير عنوان الواجهة بناءً على العملية (إضافة أو تعديل) وبناءً على لغة التطبيق
        title: Text(
          widget.task == null
              ? (isEn ? 'Add Task' : 'إضافة مهمة')
              : (isEn ? 'Edit Task' : 'تعديل مهمة'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // حقل إدخال عنوان المهمة
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: isEn ? 'Title' : 'عنوان المهمة',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            // حقل إدخال وصف المهمة
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: isEn ? 'Description' : 'الوصف',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            // قائمة منسدلة (Dropdown) يختار منها المستخدم تصنيف المهمة لربط الجداول ببعضها
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              hint: Text(isEn ? 'Select Category' : 'اختر التصنيف'),
              // تحويل قائمة التصنيفات المخزنة في الـ Provider إلى عناصر داخل القائمة المنسدلة
              items: taskProvider.categories.map((cat) {
                return DropdownMenuItem<int>(
                  value: cat.id,
                  child: Text(cat.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategoryId = val; // تحديث التصنيف المختار في الذاكرة
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            // زر الحفظ النهائي
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final desc = _descriptionController.text.trim();

                // التحقق من إدخال العنوان واختيار تصنيف قبل الحفظ
                if (title.isNotEmpty && _selectedCategoryId != null) {
                  if (widget.task == null) {
                    // 1. تنفيذ عملية إضافة مهمة جديدة تماماً
                    await taskProvider.addTask(
                      TaskModel(
                        title: title,
                        description: desc,
                        userId: userId,
                        categoryId: _selectedCategoryId!,
                      ),
                    );
                  } else {
                    // 2. تنفيذ عملية تعديل مهمة موجودة مسبقاً بناءً على رقم الـ ID الخاص بها
                    await taskProvider.updateTask(
                      TaskModel(
                        id: widget.task!.id,
                        title: title,
                        description: desc,
                        isCompleted: widget.task!.isCompleted,
                        userId: userId,
                        categoryId: _selectedCategoryId!,
                      ),
                    );
                  }
                  Navigator.pop(context); // العودة التلقائية للشاشة السابقة بعد إتمام الحفظ
                }
              },
              child: Text(isEn ? 'Save' : 'حفظ'),
            )
          ],
        ),
      ),
    );
  }
}
