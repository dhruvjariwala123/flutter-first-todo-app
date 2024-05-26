import 'package:equatable/equatable.dart';
import 'package:first_todo_app/src/core/constants/priority_enum.dart';
import 'package:first_todo_app/src/core/uitls/get_prioriry.dart';

import '../../domain/entities/todo_entity.dart';

class TodoModel extends Todo with EquatableMixin {
  bool isPresentOnCloud;
  TodoModel({
    required super.task,
    required super.isCompleted,
    required super.priority,
    required super.id,
    required this.isPresentOnCloud,
  });
  factory TodoModel.fromEntity(Todo todo, bool isPresentOnCloud) {
    return TodoModel(
      id: todo.id,
      task: todo.task,
      isCompleted: todo.isCompleted,
      priority: todo.priority,
      isPresentOnCloud: isPresentOnCloud,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "task": task,
      "priority": priority.name,
      "isCompleted": isCompleted,
      "isPresentOnCloud": isPresentOnCloud,
    };
  }

  static TodoModel fromJson(Map<String, dynamic> json) {
    return TodoModel(
        id: json["id"],
        task: json["task"],
        isCompleted: json["isCompleted"],
        priority: getPriorityFromName(json["priority"]),
        isPresentOnCloud: json["isPresentOnCloud"] ?? false);
  }

  @override
  String toString() {
    return 'TodoModel(id: $id, task: $task, priority: ${priority.name}, isCompleted: $isCompleted, isPresentOnCloud: $isPresentOnCloud)';
  }

  @override
  List<Object?> get props =>
      [id, isCompleted, priority, isPresentOnCloud, task];
}
