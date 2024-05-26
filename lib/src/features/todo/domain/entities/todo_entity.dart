import '../../../../core/constants/priority_enum.dart';

class Todo {
  String id;
  String task;
  bool isCompleted;
  Priority priority;
  Todo(
      {required this.id,
      required this.task,
      required this.isCompleted,
      required this.priority});
}
