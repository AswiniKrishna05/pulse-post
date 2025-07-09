import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/navigation/app_routes.dart';
import '../core/services/firebase_auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  String email = '';
  String password = '';
  bool isLoading = false;
  bool rememberMe = false;
  bool obscurePassword = true;

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void updateEmail(String value) => email = value;

  void updatePassword(String value) {
    password = value;
  }

  Future<void> login(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
        Navigator.pushReplacementNamed(context,AppRoutes.signupPersonal);
      }
     catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    isLoading = false;
    notifyListeners();
  }
}
