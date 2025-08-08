/// Single place to manage the base URL - matches Node SDK pattern
const String APPATONCE_BASE_URL = 'https://api.appatonce.com/api/v1';

/// Default configuration values
class AppAtOnceDefaults {
  static const String baseUrl = APPATONCE_BASE_URL;
  static const String realtimeUrl = 'ws://localhost:8091';
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}
