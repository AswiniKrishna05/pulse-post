import 'package:flutter/material.dart';

import '../core/navigation/app_routes.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  String newPassword = '';
  String confirmPassword = '';
  bool isObscureNew = true;
  bool isObscureConfirm = true;
  bool isLoading = false;

  void toggleNewPasswordVisibility() {
    isObscureNew = !isObscureNew;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isObscureConfirm = !isObscureConfirm;
    notifyListeners();
  }

  void updateNewPassword(String value) {
    newPassword = value;
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
  }

  Future<void> resetPassword(BuildContext context) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar(context, 'Please fill in both fields');
      return;
    }
    if (newPassword != confirmPassword) {
      _showSnackbar(context, 'Passwords do not match');
      return;
    }

    isLoading = true;
    notifyListeners();

    // TODO: Replace with backend call
    await Future.delayed(const Duration(seconds: 2));

    _showSnackbar(context, 'Password reset successful');
    Navigator.pushReplacementNamed(context, AppRoutes.passwordResetSuccess);

    isLoading = false;
    notifyListeners();
  }

  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
