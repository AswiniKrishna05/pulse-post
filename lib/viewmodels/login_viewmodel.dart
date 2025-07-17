import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isPhoneMode = false;

  // OTP login fields and logic
  String phone = '';
  String otp = '';
  bool isOtpSent = false;
  String? verificationId;

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

  void toggleLoginMode() {
    isPhoneMode = !isPhoneMode;
    notifyListeners();
  }

  void updatePhone(String value) => phone = value;
  void updateOtp(String value) => otp = value;

  String _formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'\s+|-'), '');
    if (!phone.startsWith('+')) {
      phone = '+91$phone';
    }
    return phone;
  }

  Future<void> sendOtp(BuildContext context) async {
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      String formattedPhone = _formatPhoneNumber(phone);
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          isOtpSent = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent to your phone')),
          );
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (otp.isEmpty || verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, AppRoutes.socialFollow);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacementNamed(context, AppRoutes.socialFollow);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
