import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final IconData? suffixIcon;
  final Function()? onToggleVisibility;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.obscure = false,
    this.suffixIcon,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: Icon(suffixIcon),
          onPressed: onToggleVisibility,
        )
            : null,
      ),
    );
  }
}
