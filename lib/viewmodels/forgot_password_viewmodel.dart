import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/navigation/app_routes.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  bool isLoading = false;

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  Future<void> sendResetLink(BuildContext context) async {
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link sent to email')),
      );
      Navigator.pushNamed(context, AppRoutes.otp, arguments: email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    isLoading = false;
    notifyListeners();
  }
}
