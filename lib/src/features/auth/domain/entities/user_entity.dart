import 'package:equatable/equatable.dart';

class User extends Equatable {
  String name;
  String uid;
  String email;
  User({
    required this.uid,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [name, uid, email];
}
