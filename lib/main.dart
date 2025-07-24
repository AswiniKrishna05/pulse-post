import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziya_project/repository/location_repository.dart';
import 'package:ziya_project/viewmodels/forgot_password_viewmodel.dart';
import 'package:ziya_project/viewmodels/home_viewmodel.dart';
import 'package:ziya_project/viewmodels/location_view_model.dart';
import 'package:ziya_project/viewmodels/login_viewmodel.dart';
import 'package:ziya_project/viewmodels/otp_verification_viewmodel.dart';
import 'package:ziya_project/viewmodels/personal_info_viewmodel.dart';
import 'package:ziya_project/viewmodels/register_viewmodel.dart';
import 'package:ziya_project/viewmodels/reset_password_viewmodel.dart';
import 'package:ziya_project/viewmodels/splash_viewmodel.dart';
import 'package:ziya_project/viewmodels/social_follow_viewmodel.dart';
import 'package:ziya_project/viewmodels/district_viewmodel.dart';

import 'core/database/app_db.dart';
import 'core/navigation/app_router.dart';
import 'core/navigation/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final db = AppDatabase();                // Drift database
  final repo = LocationRepository(db);     // Repository object
  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final LocationRepository repo;
  const MyApp({super.key, required this.repo}); // repo required ആക്കി മാറ്റി

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DistrictViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => PersonalInfoViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => OTPVerificationViewModel()),
        ChangeNotifierProvider(create: (_) => SocialFollowViewModel()),
        ChangeNotifierProvider(create: (_) => LocationViewModel(repo)), // FIXED
      ],
      child: MaterialApp(
        title: 'Pulse Post',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
            elevation: 1,
          ),
          cardColor: Colors.white,
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
