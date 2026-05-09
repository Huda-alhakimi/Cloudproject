import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// استيراد مزود الحسابات للتحقق من بيانات الدخول
import '../providers/auth_provider.dart'; 
// استيراد مزود المهام للتحكم في اللغات وجلب البيانات
import '../../../tasks/presentation/providers/task_provider.dart';
import 'register_page.dart';
import '../../../tasks/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super .key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // كائنات التحكم لقراءة النصوص المدخلة من حقول اسم المستخدم وكلمة المرور
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // جلب مزود المهام لتغيير اللغات وجلب مهام المستخدم بعد تسجيل دخوله
    final taskProvider = Provider.of<TaskProvider>(context);
    // جلب مزود الحسابات للتحقق من صحة المستخدم المسجل
    final authProvider = Provider.of<AuthProvider>(context);
    // متغير لمعرفة ما إذا كانت اللغة الحالية إنجليزية أم عربية
    final isEn = taskProvider.isEnglish;

    return Scaffold(
            appBar: AppBar(
        title: Text(isEn ? 'Sign In' : 'تسجيل الدخول'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              taskProvider.toggleLanguage(); 
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // حقل إدخال اسم المستخدم
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: isEn ? 'Username' : 'اسم المستخدم',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            // حقل إدخال كلمة المرور
            TextField(
              controller: _passwordController,
              obscureText: true, // إخفاء الحروف المدخلة لحماية كلمة المرور
              decoration: InputDecoration(
                labelText: isEn ? 'Password' : 'كلمة المرور',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // زر تسجيل الدخول
            ElevatedButton(
              onPressed: () async {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();

                if (username.isNotEmpty && password.isNotEmpty) {
                  // استدعاء دالة التحقق من الحساب وكلمة المرور في قاعدة البيانات
                  bool success = await authProvider.login(username, password);
                  if (success) {
                    // استخراج رقم الـ ID للمتصفح الذي نجح في تسجيل الدخول
                    final userId = authProvider.currentUser!.id!;
                    
                    // تمرير رقم الـ ID لجلب المهام والتصنيفات الخاصة بهذا المستخدم فقط
                    await taskProvider.fetchTasks(userId);
                    await taskProvider.fetchCategories(userId);

                    // الانتقال إلى الواجهة الرئيسية واستبدال شاشة الدخول بها
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  } else {
                    // في حال كانت البيانات غير صحيحة أو غير موجودة
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEn ? 'Invalid data!' : 'بيانات الدخول خاطئة!')),
                    );
                  }
                }
              },
              child: Text(isEn ? 'Login' : 'دخول'),
            ),
            // رابط أسفل الزر لنقل المستخدم لواجهة إنشاء حساب جديد
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
              child: Text(isEn ? "Don't have an account? Sign Up" : 'ليس لديك حساب؟ سجل الآن'),
            )
          ],
        ),
      ),
    );
  }
}
