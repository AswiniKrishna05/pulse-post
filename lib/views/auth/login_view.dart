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
                Image.asset('assets/images/ziyalogo.jpeg', height: 120),
                const SizedBox(height: 16),
                const Text('Login Now', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Login in to continue to PulsePost', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),

                // Toggle button group for login mode with card-like background (at the top)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !vm.isPhoneMode ? Colors.white : Colors.grey[200],
                            foregroundColor: !vm.isPhoneMode ? Colors.blue : Colors.grey,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (vm.isPhoneMode) vm.toggleLoginMode();
                          },
                          child: const Text('Email Login'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vm.isPhoneMode ? Colors.white : Colors.grey[200],
                            foregroundColor: vm.isPhoneMode ? Colors.blue : Colors.grey,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (!vm.isPhoneMode) vm.toggleLoginMode();
                          },
                          child: const Text('OTP Login'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (!vm.isPhoneMode) ...[
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
                ] else ...[
                  CustomTextField(
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    onChanged: vm.updatePhone,
                    keyboardType: TextInputType.phone,
                    prefixText: '+91 ',
                  ),
                  const SizedBox(height: 16),
                  if (!vm.isOtpSent)
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Send OTP',
                        isLoading: vm.isLoading,
                        onPressed: () => vm.sendOtp(context),
                      ),
                    ),
                  if (vm.isOtpSent) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Enter OTP:'),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            onChanged: vm.updateOtp,
                            decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Verify OTP',
                        isLoading: vm.isLoading,
                        onPressed: () => vm.verifyOtp(context),
                      ),
                    ),
                  ],
                ],
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
