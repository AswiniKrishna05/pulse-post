import 'package:flutter/material.dart';

class OTPInputBox extends StatelessWidget {
  final void Function(String) onChanged;

  const OTPInputBox({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: onChanged,
        decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
      ),
    );
  }
}
