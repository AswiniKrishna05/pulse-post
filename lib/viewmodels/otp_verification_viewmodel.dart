import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../core/navigation/app_routes.dart';

class OTPVerificationViewModel extends ChangeNotifier {
  String email = '';
  String otpCode = '';
  String newPassword = '';
  bool isLoading = false;
  bool otpVerified = false;
  bool passwordReset = false;
  String errorMessage = '';

  void setEmail(String e) => email = e;
  void updateOtp(String code) => otpCode = code;
  void updateNewPassword(String pwd) => newPassword = pwd;

  Future<void> verifyOtp(BuildContext context) async {
    if (otpCode.length != 4) {
      _show(context, 'Please enter the 4-digit OTP');
      return;
    }
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    // Mock: Accept '1234' as valid OTP
    if (otpCode == '1234') {
      otpVerified = true;
      _show(context, 'OTP verified! Please set your new password.');
      // Removed navigation logic from here
    } else {
      errorMessage = 'Incorrect OTP';
      _show(context, errorMessage);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> resendOtp(BuildContext context) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    // Mock: Always succeed
    _show(context, 'OTP resent to email. (Mock)');
    isLoading = false;
    notifyListeners();
  }

  Future<void> resetPasswordWithOtp(BuildContext context) async {
    if (newPassword.length < 6) {
      errorMessage = 'Password must be at least 6 characters.';
      _show(context, errorMessage);
      return;
    }
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    // Mock: Always succeed
    passwordReset = true;
    _show(context, 'Password reset successful!');
    isLoading = false;
    notifyListeners();
  }

  void _show(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
