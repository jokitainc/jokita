import 'package:jokita/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String username, String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<User> updateUser(String id, {String? username, String? email, String? password});
}
