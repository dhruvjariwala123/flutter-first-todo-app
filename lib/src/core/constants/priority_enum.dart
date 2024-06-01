enum Priority { high, low, medium }

extension TodoPriorityExtention on Priority {
  static Priority getTodoPriorityFromName({required String name}) {
    switch (name) {
      case "high":
        return Priority.high;
      case "medium":
        return Priority.medium;
      case "low":
        return Priority.low;
      default:
        return Priority.high;
    }
  }
}
