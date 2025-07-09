import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/reset_password_viewmodel.dart';


class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ResetPasswordViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/images/reset_password.png', height: 180),
              const SizedBox(height: 16),
              const Text(
                'Reset Your Password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'The password must be different than before',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              TextField(
                onChanged: vm.updateNewPassword,
                obscureText: vm.isObscureNew,
                decoration: InputDecoration(
                  labelText: 'New password',
                  hintText: 'Enter your mobile Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(vm.isObscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: vm.toggleNewPasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                onChanged: vm.updateConfirmPassword,
                obscureText: vm.isObscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Enter your mobile Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(vm.isObscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: vm.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading ? null : () => vm.resetPassword(context),
                  child: vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
