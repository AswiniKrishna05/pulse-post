import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/reset_password_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';
import 'dart:async';

class ResetPasswordView extends StatefulWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  bool _passwordDirty = false;
  Timer? _passwordStrengthTimer;
  bool _showPasswordStrength = false;

  @override
  void dispose() {
    _passwordStrengthTimer?.cancel();
    super.dispose();
  }

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
              onChanged: (val) {
                if (!_passwordDirty) {
                  setState(() {
                    _passwordDirty = true;
                  });
                }
                vm.updateNewPassword(val);
                _passwordStrengthTimer?.cancel();
                setState(() {
                  _showPasswordStrength = false;
                });
                _passwordStrengthTimer = Timer(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() {
                      _showPasswordStrength = true;
                    });
                  }
                });
              },
              borderColor: vm.showPasswordMismatchError ? Colors.red : null,
            ),
            if (_passwordDirty && _showPasswordStrength)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    'Strength: ${vm.passwordStrength}',
                    style: TextStyle(
                      color: vm.passwordStrength == 'Strong'
                          ? Colors.green
                          : vm.passwordStrength == 'Medium'
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm Password',
              hint: 'Re-enter password',
              obscure: vm.isObscureConfirm,
              suffixIcon: vm.isObscureConfirm ? Icons.visibility : Icons.visibility_off,
              onToggleVisibility: vm.toggleConfirmPasswordVisibility,
              onChanged: vm.updateConfirmPassword,
              borderColor: vm.showPasswordMismatchError ? Colors.red : null,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Reset Password',
              isLoading: vm.isLoading,
              onPressed: () => vm.resetPassword(context, widget.email),
            ),
          ],
        ),
      ),
    );
  }
}
