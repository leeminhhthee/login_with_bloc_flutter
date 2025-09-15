import '../../domain/entities/user.dart';

class UserModel extends User {
  final String password;

  UserModel({required String email, required this.password})
      : super(email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}