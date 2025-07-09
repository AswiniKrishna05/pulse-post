import 'package:flutter/material.dart';

import '../core/navigation/app_routes.dart';

class SplashViewModel extends ChangeNotifier{
  Future<void>initializeApp(BuildContext context)async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}