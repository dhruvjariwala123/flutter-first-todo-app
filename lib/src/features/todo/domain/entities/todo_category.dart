import 'package:flutter/material.dart';

enum TodoCategory { Completed, UnCompleted, All }

extension TodoCategoryExtention on TodoCategory {
  static TodoCategory getTodoCategoryFromName({required String name}) {
    switch (name) {
      case "All":
        return TodoCategory.All;
      case "Completed":
        return TodoCategory.Completed;
      case "UnCompleted":
        return TodoCategory.UnCompleted;
      default:
        return TodoCategory.All;
    }
  }
}
