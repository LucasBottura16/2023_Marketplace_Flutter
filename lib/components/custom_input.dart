import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      autofocus: autofocus,
      keyboardType: type,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: hint,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6)
          )
      ),
      controller: controller,
    );
  }
}
