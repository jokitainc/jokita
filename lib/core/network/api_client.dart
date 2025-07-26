import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient(this._secureStorage) : dio = Dio() {
    dio.options.baseUrl = 'http://localhost:8080/api'; // Sesuaikan dengan URL backend Anda
    dio.options.connectTimeout = const Duration(seconds: 5); // 5 detik
    dio.options.receiveTimeout = const Duration(seconds: 3); // 3 detik

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // Lanjutkan permintaan
      },
      onResponse: (response, handler) {
        // Wrap the successful response
        final newResponseData = {
          'rc': response.data['rc'] ?? 500,
          'message': response.data['message'] ?? 'Success',
          'data': response.data['data'] ?? {},
        };
        response.data = newResponseData;
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // Handle auth errors
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          await _secureStorage.delete(key: 'jwt_token');
          // TODO: Redirect user to login page (e.g., using AutoRouter)
        }

        String errorMessage = e.message ?? 'An unknown error occurred';

        // Safely extract error message from response data
        if (e.response?.data is Map<String, dynamic>) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        } else if (e.response?.data is String && e.response!.data.isNotEmpty) {
          errorMessage = e.response!.data;
        }

        // Create the standardized error response
        final errorResponseData = {
          'rc': e.response?.statusCode ?? 500,
          'message': errorMessage,
          'data': <String, dynamic>{},
        };

        // It's safer to create a new response object than to modify the existing one
        e.response?.data = errorResponseData;

        return handler.next(e);
      },
    ));
  }
}