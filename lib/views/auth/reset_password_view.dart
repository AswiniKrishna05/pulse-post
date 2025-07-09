import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/reset_password_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ResetPasswordViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomTextField(
              label: 'New Password',
              hint: 'Enter new password',
              obscure: vm.isObscureNew,
              suffixIcon: vm.isObscureNew ? Icons.visibility : Icons.visibility_off,
              onToggleVisibility: vm.toggleNewPasswordVisibility,
              onChanged: vm.updateNewPassword,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm Password',
              hint: 'Re-enter password',
              obscure: vm.isObscureConfirm,
              suffixIcon: vm.isObscureConfirm ? Icons.visibility : Icons.visibility_off,
              onToggleVisibility: vm.toggleConfirmPasswordVisibility,
              onChanged: vm.updateConfirmPassword,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Reset Password',
              isLoading: vm.isLoading,
              onPressed: () => vm.resetPassword(context, email),
            ),
          ],
        ),
      ),
    );
  }
}
