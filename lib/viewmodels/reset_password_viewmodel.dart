import 'package:flutter/material.dart';
// import 'package:cloud_functions/cloud_functions.dart'; // Removed for local-only logic
import '../core/navigation/app_routes.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  String newPassword = '';
  String confirmPassword = '';
  bool isObscureNew = true;
  bool isObscureConfirm = true;
  bool isLoading = false;
  bool showPasswordMismatchError = false;

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

  String get passwordStrength {
    if (newPassword.length < 6) return 'Weak';
    final hasUpper = newPassword.contains(RegExp(r'[A-Z]'));
    final hasSpecial = newPassword.contains(RegExp(r'[&@#]'));
    final hasNumber = newPassword.contains(RegExp(r'[0-9]'));
    if (hasUpper && hasSpecial && hasNumber && newPassword.length >= 8) return 'Strong';
    if ((hasUpper || hasSpecial) && newPassword.length >= 6) return 'Medium';
    return 'Weak';
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar(context, 'Please fill in both fields');
      return;
    }

    if (newPassword != confirmPassword) {
      showPasswordMismatchError = true;
      notifyListeners();
      _showSnackbar(context, 'Passwords do not match. Please enter correctly');
      return;
    } else {
      showPasswordMismatchError = false;
      notifyListeners();
    }

    if (!newPassword.contains(RegExp(r'[A-Z]'))) {
      _showSnackbar(context, 'Please add at least one capital letter');
      return;
    }

    if (!newPassword.contains(RegExp(r'[&@#]'))) {
      _showSnackbar(context, 'Password must include at least one special character: & @ #');
      return;
    }

    if (newPassword.length < 6) {
      _showSnackbar(context, 'Password must be at least 6 characters long');
      return;
    }

    isLoading = true;
    notifyListeners();

    // Local-only: No backend call, just show success and navigate
    await Future.delayed(const Duration(seconds: 1)); // Simulate a short delay
    _showSnackbar(context, 'Password reset successfully. Please log in');
    Navigator.pushReplacementNamed(context, AppRoutes.login);

    isLoading = false;
    notifyListeners();
  }

  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
