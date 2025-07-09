import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/otp_verification_viewmodel.dart';


class OTPVerificationView extends StatelessWidget {
  const OTPVerificationView({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OTPVerificationViewModel>(context, listen: false);
    vm.setEmail(email);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/images/verify_otp.png', height: 180),
              const SizedBox(height: 16),
              const Text(
                'Verify email address',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the four-digit OTP code sent to your email address ${_obfuscateEmail(email)}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OtpTextField(
                numberOfFields: 4,
                borderColor: Colors.deepPurple,
                showFieldAsBox: true,
                onCodeChanged: (code) {
                  vm.updateOtp(code);
                },
                onSubmit: (code) {
                  vm.verifyOtp(context);
                },
              ),



              const SizedBox(height: 24),
              Consumer<OTPVerificationViewModel>(
                builder: (_, vm, __) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: vm.isLoading ? null : () => vm.verifyOtp(context),
                    child: vm.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Verify OTP code"),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => vm.resendOtp(context),
                child: const Text("Didn't receive the email? Click to resend"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _obfuscateEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    final obfuscated = local.length <= 1
        ? "*"
        : "${local.substring(0, 1)}${'*' * (local.length - 2)}${local.substring(local.length - 1)}";
    return "$obfuscated@${parts[1]}";
  }
}
