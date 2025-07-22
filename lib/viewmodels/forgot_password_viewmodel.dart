import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../core/constants/app_strings.dart';
import '../core/navigation/app_routes.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String email = '';
  bool isLoading = false;

  void updateEmail(String value) {
    email = value.trim();
    notifyListeners();
  }

  Future<void> sendOtpToEmail(BuildContext context) async {
    if (email.isEmpty || !email.contains(AppStrings.atSymbol
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.invalidEmail)),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable(AppStrings.sendOtpForForgotPassword
      )
          .call({AppStrings.email
          : email});

      if (result.data[AppStrings.success
      ] == true) {
        Navigator.pushNamed(context, AppRoutes.otp, arguments: email);
      } else {
        throw Exception(AppStrings.otpSendFailed
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: \\${e.toString()}')),
      );
    }

    isLoading = false;
    notifyListeners();
  }
}
