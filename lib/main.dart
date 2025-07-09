import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziya_project/viewmodels/forgot_password_viewmodel.dart';
import 'package:ziya_project/viewmodels/home_viewmodel.dart';
import 'package:ziya_project/viewmodels/login_viewmodel.dart';
import 'package:ziya_project/viewmodels/otp_verification_viewmodel.dart';
import 'package:ziya_project/viewmodels/personal_info_viewmodel.dart';
import 'package:ziya_project/viewmodels/register_viewmodel.dart';
import 'package:ziya_project/viewmodels/reset_password_viewmodel.dart';
import 'package:ziya_project/viewmodels/splash_viewmodel.dart';
import 'package:ziya_project/viewmodels/social_follow_viewmodel.dart';
import 'package:ziya_project/views/auth/forgot_password_view.dart';
import 'package:ziya_project/views/auth/login_view.dart';
import 'package:ziya_project/views/auth/otp_verification_view.dart';
import 'package:ziya_project/views/splash/splash_view.dart';

import 'core/navigation/app_router.dart';
import 'core/navigation/app_routes.dart';

void main ()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> SplashViewModel()),
          ChangeNotifierProvider(create: (_)=> LoginViewModel()),
          ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
          ChangeNotifierProvider(create: (_) => RegisterViewModel()),
          ChangeNotifierProvider(create: (_) => PersonalInfoViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
          ChangeNotifierProvider(create: (_) => OTPVerificationViewModel()),
          ChangeNotifierProvider(create: (_) => SocialFollowViewModel()),
    ],
    child: MaterialApp(
      title: 'Pulse Post',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    ),
    );
  }
}
