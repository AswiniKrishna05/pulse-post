import 'package:flutter/material.dart';

class OTPVerificationViewModel extends ChangeNotifier {
  String otpCode = '';
  bool isLoading = false;
  String email = '';

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updateOtp(String value) {
    otpCode = value;
    notifyListeners();
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (otpCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the 4-digit code.")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulated verify

    // TODO: Replace with real OTP verification from backend
    if (otpCode == '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified!')),
      );
      Navigator.pushReplacementNamed(context, '/reset-password'); // Or home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> resendOtp(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resend link clicked')),
    );
    // TODO: Call API to resend OTP
  }
}
