import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/navigation/app_routes.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> initializeApp(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection(AppStrings.users).doc(uid).get();
      final data = doc.data() ?? {};

      final isCompletedInfo = data[AppStrings.isCompletedInfo
      ] == true;
      final isProfileComplete = data[AppStrings.isProfileComplete] == true;

      if (!isCompletedInfo) {
        Navigator.pushReplacementNamed(context, AppRoutes.signupPersonal);
      } else if (!isProfileComplete) {
        Navigator.pushReplacementNamed(context, AppRoutes.socialFollow);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
    else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
    //   Navigator.pushReplacementNamed(context, AppRoutes.home);
    // } else {
    //     Navigator.pushReplacementNamed(context, AppRoutes.signupPersonal);
    //   }
  }
}
