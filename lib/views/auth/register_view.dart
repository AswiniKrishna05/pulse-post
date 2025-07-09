import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_routes.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';


class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text('Register', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Image.asset('assets/images/pulse_logo.jpeg', height: 100),
              const SizedBox(height: 8),
              const Text('Pulse Post', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Please enter your details below', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'User Name',
                hint: 'Enter your username',
                onChanged: vm.updateUsername,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Email Address',
                hint: 'Enter your email address',
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
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Confirm Password',
                hint: 'Confirm your password',
                obscure: vm.obscureConfirm,
                suffixIcon: vm.obscureConfirm ? Icons.visibility : Icons.visibility_off,
                onToggleVisibility: vm.toggleConfirmPasswordVisibility,
                onChanged: vm.updateConfirmPassword,
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Sign Up',
                isLoading: vm.isLoading,
                onPressed: () => vm.register(context),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signupPersonal),

                      child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
