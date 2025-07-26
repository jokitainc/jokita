import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jokita/core/network/api_client.dart';
import 'package:jokita/domain/entities/user.dart';
import 'package:jokita/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl(this._apiClient, this._secureStorage);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data['data']['token'] as String;
      await _secureStorage.write(key: 'jwt_token', value: token);

      final parts = token.split('.');
      final payload = String.fromCharCodes(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> decodedPayload = jsonDecode(payload);

      return User.fromJson(decodedPayload);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<User> register(String username, String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Registration failed');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) {
      return null;
    }

    try {
      _apiClient.dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _apiClient.dio.get('/auth/me');
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await _secureStorage.delete(key: 'jwt_token');
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> updateUser(String id, {String? username, String? email, String? password}) async {
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      if (token == null) {
        throw Exception('Not authenticated');
      }

      _apiClient.dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _apiClient.dio.put(
        '/auth/update',
        data: {
          if (username != null) 'username': username,
          if (email != null) 'email': email,
          if (password != null) 'password': password,
        },
      );
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Update failed');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
