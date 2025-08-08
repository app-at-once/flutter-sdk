/// Base exception for AppAtOnce SDK
class AppAtOnceException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppAtOnceException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'AppAtOnceException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Authentication exception
class AuthException extends AppAtOnceException {
  const AuthException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Network exception
class NetworkException extends AppAtOnceException {
  final int? statusCode;

  const NetworkException(
    String message, {
    this.statusCode,
    String? code,
    dynamic details,
  }) : super(message, code: code, details: details);
}

/// Validation exception
class ValidationException extends AppAtOnceException {
  final Map<String, List<String>>? errors;

  const ValidationException(
    String message, {
    this.errors,
    String? code,
    dynamic details,
  }) : super(message, code: code, details: details);
}

/// Storage exception
class StorageException extends AppAtOnceException {
  const StorageException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Realtime exception
class RealtimeException extends AppAtOnceException {
  const RealtimeException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Timeout exception
class TimeoutException extends AppAtOnceException {
  const TimeoutException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}
