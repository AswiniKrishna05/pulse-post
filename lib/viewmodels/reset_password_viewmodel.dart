import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

  Future<void> resetPassword(BuildContext context, String email) async {
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

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('resetPasswordWithEmail')
          .call({'email': email, 'newPassword': newPassword});

      if (result.data['success'] == true) {
        _showSnackbar(context, 'Password reset successful');
        Navigator.pushReplacementNamed(context, AppRoutes.passwordResetSuccess);
      } else {
        _showSnackbar(context, 'Reset failed');
      }
    } catch (e) {
      _showSnackbar(context, 'Error: ${e.toString()}');
    }

    isLoading = false;
    notifyListeners();
  }

  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
