import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/forgot_password_viewmodel.dart';


class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForgotPasswordViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/images/forgot_password.png', height: 200),
              const SizedBox(height: 20),
              const Text(
                'Forgot password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your email address below to reset password.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                onChanged: vm.updateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter email address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading ? null : () => vm.sendResetLink(context),
                  child: vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Verify email address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
