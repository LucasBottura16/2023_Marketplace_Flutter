import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key,
    required this.text,
    required this.onPressed,
    this.colorButton = Colors.purple,

  }) : super(key: key);

  final String text;
  final Color colorButton;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(colorButton),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.fromLTRB(32, 16, 32, 16)),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
