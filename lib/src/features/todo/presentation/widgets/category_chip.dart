import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String value;
  final void Function(dynamic)? onChanged;
  final List<DropdownMenuItem> items;
  const CategoryChip(
      {super.key,
      required this.onChanged,
      required this.value,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
