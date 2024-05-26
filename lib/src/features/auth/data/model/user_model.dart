import '../../domain/entities/user_entity.dart';

class UserModel extends User {
  UserModel({
    required super.uid,
    required super.name,
    required super.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
    };
  }
}
