import 'package:flutter/material.dart';
import '../../../core/navigation/app_routes.dart';


class PasswordResetSuccessView extends StatelessWidget {
  const PasswordResetSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.pop(context))),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Password reset successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Image.asset('assets/images/success_check.png', height: 100),
                const SizedBox(height: 24),
                const Text(
                  'You have successfully reset your password.\nClick below to log in with your new password.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                            (route) => false,
                      );
                    },
                    child: const Text('Log in'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
