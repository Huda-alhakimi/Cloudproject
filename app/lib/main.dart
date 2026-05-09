import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/tasks/presentation/providers/task_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(
    // نقوم بربط الـ Providers هنا لكي نتمكن من الوصول للبيانات من أي مكان في التطبيق
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء شريط التجربة المزعج في أعلى الشاشة
      title: 'To Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // تفعيل التصميم الحديث
      ),
      home: const LoginPage(), // جعل شاشة تسجيل الدخول هي الشاشة الأولى عند تشغيل التطبيق
    );
  }
}
