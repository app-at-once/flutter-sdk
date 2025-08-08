import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../common/types.dart';
import '../common/exceptions.dart';

/// HTTP client wrapper for API requests
class HttpClient {
  final Dio _dio;
  final ClientConfig _config;

  HttpClient(this._dio, this._config);

  /// Make a GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    return _request<T>(
      () => _dio.get(
        path,
        queryParameters: params,
        options: Options(headers: headers),
      ),
    );
  }

  /// Make a POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    return _request<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: params,
        options: Options(headers: headers),
      ),
    );
  }

  /// Make a PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    return _request<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: params,
        options: Options(headers: headers),
      ),
    );
  }

  /// Make a PATCH request
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    return _request<T>(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: params,
        options: Options(headers: headers),
      ),
    );
  }

  /// Make a DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    return _request<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: params,
        options: Options(headers: headers),
      ),
    );
  }

  /// Upload a file
  Future<T> upload<T>(
    String path, {
    required List<int> bytes,
    required String filename,
    String? field = 'file',
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    void Function(int, int)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      field!: MultipartFile.fromBytes(
        bytes,
        filename: filename,
      ),
    });

    return _request<T>(
      () => _dio.post(
        path,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: onProgress,
      ),
    );
  }

  /// Download a file
  Future<List<int>> download(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    void Function(int, int)? onProgress,
  }) async {
    final response = await _dio.get<List<int>>(
      path,
      queryParameters: params,
      options: Options(
        headers: headers,
        responseType: ResponseType.bytes,
      ),
      onReceiveProgress: onProgress,
    );

    return response.data!;
  }

  /// Make a request with retry logic
  Future<T> _request<T>(Future<Response> Function() request) async {
    int attempts = 0;
    Duration delay = const Duration(seconds: 1);

    while (attempts < _config.retries) {
      try {
        final response = await request();

        if (response.data is Map && response.data['success'] == false) {
          throw AppAtOnceException(
            response.data['error'] ?? 'Request failed',
            code: response.data['code'],
            details: response.data,
          );
        }

        if (T == dynamic || T == Object) {
          return response.data;
        }

        if (T == String) {
          return response.data.toString() as T;
        }

        if (T == bool) {
          return (response.data == true) as T;
        }

        return response.data as T;
      } on DioException catch (e) {
        attempts++;

        if (attempts >= _config.retries) {
          throw _handleDioError(e);
        }

        // Exponential backoff
        await Future.delayed(delay);
        delay *= 2;
      } catch (e) {
        throw AppAtOnceException(
          'Unexpected error: ${e.toString()}',
          details: e,
        );
      }
    }

    throw AppAtOnceException('Max retries exceeded');
  }

  /// Handle Dio errors
  AppAtOnceException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Request timeout',
          details: error.message,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        if (statusCode == 401) {
          return AuthException(
            data?['message'] ?? 'Unauthorized',
            code: 'auth/unauthorized',
            details: data,
          );
        }

        if (statusCode == 400 && data?['errors'] != null) {
          return ValidationException(
            data['message'] ?? 'Validation failed',
            errors: Map<String, List<String>>.from(data['errors']),
            details: data,
          );
        }

        return NetworkException(
          data?['message'] ?? 'Request failed',
          statusCode: statusCode,
          code: data?['code'],
          details: data,
        );

      case DioExceptionType.cancel:
        return AppAtOnceException(
          'Request cancelled',
          details: error.message,
        );

      default:
        return NetworkException(
          error.message ?? 'Network error',
          details: error.toString(),
        );
    }
  }

  /// Set authorization header
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Update API key
  void updateApiKey(String apiKey) {
    _dio.options.headers['X-API-Key'] = apiKey;
  }
}
