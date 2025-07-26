import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokita/domain/entities/user.dart';
import 'package:jokita/domain/repositories/auth_repository.dart';
import 'package:jokita/core/providers/core_providers.dart';

class AuthState extends StateNotifier<User?> {
  final AuthRepository _authRepository;

  AuthState(this._authRepository) : super(null) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    state = await _authRepository.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    try {
      final user = await _authRepository.login(email, password);
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      final user = await _authRepository.register(username, email, password);
      state = user; // Langsung login setelah register
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = null;
  }

  Future<void> updateUser({String? username, String? email, String? password}) async {
    if (state == null) {
      throw Exception('User not logged in');
    }
    try {
      final updatedUser = await _authRepository.updateUser(state!.id, username: username, email: email, password: password);
      state = updatedUser;
    } catch (e) {
      rethrow;
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthState, User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthState(authRepository);
});
