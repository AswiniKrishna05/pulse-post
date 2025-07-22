import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../core/constants/app_strings.dart';
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
      _show(context, AppStrings.enterFourDigitOtp
      );
      return;
    }
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    // Mock: Accept '1234' as valid OTP
    if (otpCode == AppStrings.sampleOtp
    ) {
      otpVerified = true;
      _show(context, AppStrings.otpVerifiedSetPassword
      );
      // Removed navigation logic from here
    } else {
      errorMessage = AppStrings.incorrectOtp
      ;
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
    _show(context, AppStrings.otpResentToEmailMock
    );
    isLoading = false;
    notifyListeners();
  }

  Future<void> resetPasswordWithOtp(BuildContext context) async {
    if (newPassword.length < 6) {
      errorMessage = AppStrings.passwordTooShort
      ;
      _show(context, errorMessage);
      return;
    }
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    // Mock: Always succeed
    passwordReset = true;
    _show(context, AppStrings.passwordResetSuccess
    );
    isLoading = false;
    notifyListeners();
  }

  void _show(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
