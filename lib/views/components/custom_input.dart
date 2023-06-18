import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text,
    this.inputFormatters,
    this.maxlines,
    this.validators,
    this.onSaved
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxlines;
  final FormFieldValidator<String>? validators;
  final FormFieldValidator<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      autofocus: autofocus,
      keyboardType: type,
      inputFormatters: inputFormatters,
      maxLines: maxlines,
      validator: validators,
      onSaved: onSaved,
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
