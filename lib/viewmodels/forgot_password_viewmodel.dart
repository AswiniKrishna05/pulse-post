import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../core/navigation/app_routes.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String email = '';
  bool isLoading = false;

  void updateEmail(String value) {
    email = value.trim();
    notifyListeners();
  }

  Future<void> sendOtpToEmail(BuildContext context) async {
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    // Mock: Always succeed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent to your email (mock).')),
    );
    Navigator.pushNamed(context, AppRoutes.otp, arguments: email);

    isLoading = false;
    notifyListeners();
  }
}
