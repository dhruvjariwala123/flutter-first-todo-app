class AppException implements Exception {
  final String message;
  final String prefix;
  AppException(this.message, [this.prefix = ""]);

  @override
  String toString() => "$prefix$message";
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, "Network Error: ");
}

class LocalDBException extends AppException {
  LocalDBException(String message) : super(message, "Local Database Error: ");
}

class CloudDBException extends AppException {
  CloudDBException(String message) : super(message, "Cloud Database Error: ");
}

class UnauthorizedUserException extends AppException {
  UnauthorizedUserException(String message)
      : super(message, "Unauthorized user Error: ");
}

class UserNotFoundException extends AppException {
  UserNotFoundException(String message)
      : super(message, "User not found Error: ");
}

class TodoNotFoundException extends AppException {
  TodoNotFoundException(String message)
      : super(message, "Todo not found Error: ");
}
