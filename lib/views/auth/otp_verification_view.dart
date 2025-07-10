import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/personal_info_viewmodel.dart';

class OTPVerificationView extends StatelessWidget {
  final String phoneNumber;
  final String? verificationId;
  const OTPVerificationView({super.key, required this.phoneNumber, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PersonalInfoViewModel>(context, listen: false);
    String otp = '';
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the OTP sent to $phoneNumber'),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (val) => otp = val,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await vm.verifyOtp(otp, context);
                if (vm.isPhoneVerified) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
