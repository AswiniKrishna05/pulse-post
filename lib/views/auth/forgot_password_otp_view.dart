import 'package:flutter/material.dart';

class ForgotPasswordOtpView extends StatefulWidget {
  const ForgotPasswordOtpView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordOtpView> createState() => _ForgotPasswordOtpViewState();
}

class _ForgotPasswordOtpViewState extends State<ForgotPasswordOtpView> {
  final TextEditingController _otpController = TextEditingController();
  bool _isError = false;

  void _verifyOtp(String email) {
    final otp = _otpController.text.trim();
    if (otp.length != 6 || int.tryParse(otp) == null) {
      setState(() => _isError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code')),
      );
      return;
    }
    // Proceed to next step (e.g., reset password)
    Navigator.pushNamed(context, '/reset-password', arguments: {'email': email});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the 6-digit OTP sent to $email'),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isError ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isError ? Colors.red : Colors.blue,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (_) {
                if (_isError) setState(() => _isError = false);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _verifyOtp(email),
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 