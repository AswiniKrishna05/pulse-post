import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_routes.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Image.asset('assets/images/pulse_logo.jpeg', height: 120),
                const SizedBox(height: 16),
                const Text('Login Now', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Login in to continue to PulsePost', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  onChanged: vm.updateEmail,
                ),


                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  obscure: vm.obscurePassword,
                  suffixIcon: vm.obscurePassword ? Icons.visibility : Icons.visibility_off,
                  onToggleVisibility: vm.togglePasswordVisibility,
                  onChanged: vm.updatePassword,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Checkbox(value: vm.rememberMe, onChanged: vm.toggleRememberMe),
                    const Text('Remember Me'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Log In',
                    isLoading: vm.isLoading,
                    onPressed: () => vm.login(context),
                  ),

                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Register'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
