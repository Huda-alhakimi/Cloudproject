import 'package:flutter/material.dart';
import '../../domain/models/user_models.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser; // لحفظ بيانات المستخدم المسجل حالياً في التطبيق

  UserModel? get currentUser => _currentUser; // دالة للوصول لبيانات المستخدم الحالي من أي واجهة

  // دالة لتسجيل مستخدم جديد وحفظه
  Future<bool> register(String username, String password) async {
    try {
      final user = UserModel(username: username, password: password);
      await _authRepository.registerUser(user);
      return true; // تمت العملية بنجاح
    } catch (e) {
      return false; // فشلت العملية
    }
  }

  // دالة للتحقق من بيانات تسجيل الدخول وحفظ الجلسة
  Future<bool> login(String username, String password) async {
    final user = await _authRepository.loginUser(username, password);
    if (user != null) {
      _currentUser = user; // حفظ بيانات المستخدم في الذاكرة
      notifyListeners(); // إشعار الواجهات لتحديث البيانات فوراً
      return true;
    }
    return false;
  }

  // دالة لتسجيل الخروج ومسح بيانات الجلسة
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
