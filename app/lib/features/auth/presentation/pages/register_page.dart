import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// استيراد مزود الحسابات لتسجيل البيانات في قاعدة البيانات
import '../providers/auth_provider.dart'; 
// استيراد مزود المهام لمعرفة لغة التطبيق الحالية (عربي أم إنجليزي)
import '../../../tasks/presentation/providers/task_provider.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // كائنات التحكم (Controllers) لقراءة النصوص المكتوبة داخل الحقول
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // جلب حالة اللغة من TaskProvider لتحديد النصوص (عربي أم إنجليزي)
    final taskProvider = Provider.of<TaskProvider>(context);
    final isEn = taskProvider.isEnglish;

    // جلب مزود الحسابات لتنفيذ عملية حفظ المستخدم الجديد
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // تحديد عنوان الشاشة بناءً على لغة التطبيق
        title: Text(isEn ? 'Register' : 'إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // حقل إدخال اسم المستخدم الجديد
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: isEn ? 'Username' : 'اسم المستخدم',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            // حقل إدخال كلمة المرور للمستخدم الجديد
            TextField(
              controller: _passwordController,
              obscureText: true, // لإخفاء الحروف واستبدالها بنقاط للأمان
              decoration: InputDecoration(
                labelText: isEn ? 'Password' : 'كلمة المرور',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // زر التسجيل
            ElevatedButton(
              onPressed: () async {
                // استخراج النصوص المدخلة وحذف أي مسافات زائدة
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();

                // التحقق من أن المستخدم لم يترك الحقول فارغة
                if (username.isNotEmpty && password.isNotEmpty) {
                  // استدعاء دالة التسجيل داخل مزود الحسابات لحفظ البيانات في قاعدة البيانات
                  bool success = await authProvider.register(username, password);
                  if (success) {
                    // إظهار رسالة نجاح منبثقة للمستخدم في أسفل الشاشة
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEn ? 'Registration Successful!' : 'تم إنشاء الحساب بنجاح!')),
                    );
                    Navigator.pop(context); // العودة التلقائية لصفحة تسجيل الدخول
                  } else {
                    // في حال فشل التسجيل (مثلاً إذا كان الاسم موجوداً مسبقاً)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEn ? 'Registration Failed!' : 'فشل إنشاء الحساب!')),
                    );
                  }
                }
              },
              child: Text(isEn ? 'Sign Up' : 'إنشاء الحساب'),
            ),
          ],
        ),
      ),
    );
  }
}
