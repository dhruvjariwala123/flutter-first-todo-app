import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  void Function(String?)? onChanged;
  CategoryChip({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: "All",
        items: [
          DropdownMenuItem(value: "All", child: Text("All")),
          DropdownMenuItem(value: "Completed", child: Text("Completed")),
          DropdownMenuItem(value: "UnCompleted", child: Text("Un Completed")),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
