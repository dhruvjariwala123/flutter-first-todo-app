import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String text;
  final bool isSecure;
  final TextEditingController controller;
  final double? maxWidth;

  const MyTextFormField({
    super.key,
    required this.text,
    required this.isSecure,
    required this.controller,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth,
      child: TextField(
        controller: controller,
        obscureText: isSecure,
        decoration: InputDecoration(
          label: Text(text),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
