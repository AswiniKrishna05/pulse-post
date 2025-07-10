import 'package:flutter/material.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/password_reset_success_view.dart';
import '../../views/auth/reset_password_view.dart';
import '../../views/home/home_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/otp_verification_view.dart';
import '../../views/personal_info/personal_info_view.dart';
import '../../views/auth/register_view.dart';
import '../../views/splash/splash_view.dart';
import '../../views/home/social_follow_view.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case AppRoutes.otp:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OTPVerificationView(
            phoneNumber: args['phoneNumber'],
            verificationId: args['verificationId'],
          ),
        );
      case AppRoutes.resetPassword:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ResetPasswordView(email: email));
      case AppRoutes.passwordResetSuccess:
        return MaterialPageRoute(builder: (_) => const PasswordResetSuccessView());
      case AppRoutes.signupPersonal:
        return MaterialPageRoute(builder: (_) => const PersonalInfoView());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case AppRoutes.socialFollow:
        return MaterialPageRoute(builder: (_) => SocialFollowView());


      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
