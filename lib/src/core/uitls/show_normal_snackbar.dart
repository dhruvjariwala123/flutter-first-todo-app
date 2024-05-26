import 'package:flutter/material.dart';

void showNormalSnackBar(
    {required BuildContext context,
    required Widget content,
    required Color backColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: content,
    backgroundColor: backColor,
  ));
}
