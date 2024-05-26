import '../constants/priority_enum.dart';

Priority getPriorityFromName(String name) {
  switch (name) {
    case "low":
      return Priority.low;

    case "medium":
      return Priority.medium;
    case "high":
      return Priority.high;
    default:
      return Priority.low;
  }
}
