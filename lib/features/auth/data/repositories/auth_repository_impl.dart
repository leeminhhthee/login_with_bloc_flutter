import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<User?> login(String email, String password) async {
    final users = await localDataSource.getUsers();
    final user = users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', user.email);

    return User(email: user.email);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('loggedInUser');
    if (email != null) {
      return User(email: email);
    }
    return null;
  }
}
