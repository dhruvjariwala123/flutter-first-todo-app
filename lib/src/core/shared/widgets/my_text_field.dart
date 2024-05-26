import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String text;
  final bool isSecure;
  final TextEditingController controller;
  const MyTextFormField(
      {super.key,
      required this.text,
      required this.isSecure,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isSecure,
      decoration: InputDecoration(
        label: Text(text),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
