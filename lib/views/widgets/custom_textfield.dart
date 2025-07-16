import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool obscure;
  final IconData? suffixIcon;
  final Function()? onToggleVisibility;
  final ValueChanged<String> onChanged;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? prefixText;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.obscure = false,
    this.suffixIcon,
    this.onToggleVisibility,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.prefixText,
    this.borderColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        prefixText: widget.prefixText,
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: _toggleVisibility,
              )
            : (widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(widget.suffixIcon),
                    onPressed: widget.onToggleVisibility,
                  )
                : null),
      ),
    );
  }
}
