import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/navigation/app_routes.dart';

class RegisterViewModel extends ChangeNotifier {
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  void updateUsername(String val) => username = val;
  void updateEmail(String val) => email = val;
  void updatePassword(String val) => password = val;
  void updateConfirmPassword(String val) => confirmPassword = val;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(context, "All fields are required");
      return;
    }

    if (password != confirmPassword) {
      _showMessage(context, "Passwords do not match");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      //  THIS IS WHERE YOU REGISTER USER IN FIREBASE
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After success, go to login
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? "Registration failed");
    } catch (e) {
      _showMessage(context, "Something went wrong");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
