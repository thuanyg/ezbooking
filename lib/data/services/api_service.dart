import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    // Optional: Add interceptors for logging and error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error: ${e.response?.statusCode} ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  static const String baseUrl = "http://127.0.0.1:8080/ezbooking/api";

  // Method to make a GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get('$baseUrl$endpoint');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  // Method to make a POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '$baseUrl$endpoint',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to create resource: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  // Method to make a PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '$baseUrl$endpoint',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update resource: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  // Method to make a DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete('$baseUrl$endpoint');
      if (response.statusCode == 204) {
        return 'Resource deleted successfully'; // No content on successful deletion
      } else {
        throw Exception('Failed to delete resource: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }
}
