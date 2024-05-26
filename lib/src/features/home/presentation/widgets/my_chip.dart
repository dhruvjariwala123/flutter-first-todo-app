import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  MyChip(
      {super.key,
      required this.label,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
