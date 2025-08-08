import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'common/types.dart';
import 'common/config.dart';
import 'modules/auth.dart';
import 'modules/data.dart';
import 'modules/storage.dart';
import 'modules/realtime.dart';
import 'modules/functions.dart';
import 'modules/ai.dart';
import 'modules/notifications.dart';
import 'modules/analytics.dart';
import 'modules/search.dart';
import 'modules/workflows.dart';
import 'modules/logic.dart';
import 'modules/schema.dart';
import 'modules/push.dart';
import 'modules/email.dart';
import 'modules/oauth.dart';
import 'modules/project_oauth.dart';
import 'modules/project_auth.dart';
import 'modules/triggers.dart';
import 'modules/payment.dart';
import 'modules/image_processing.dart';
import 'modules/pdf.dart';
import 'modules/ocr.dart';
import 'modules/document_conversion.dart';
import 'modules/content.dart';
import 'utils/http_client.dart';
import 'utils/session_manager.dart';

/// Main AppAtOnce client
class AppAtOnceClient {
  final ClientConfig config;
  late final Dio _dio;
  late final HttpClient _httpClient;
  late final SessionManager _sessionManager;
  late final FlutterSecureStorage _secureStorage;

  // Modules
  late final AuthModule auth;
  late final DataModule data;
  late final StorageModule storage;
  late final RealtimeModule realtime;
  late final FunctionsModule functions;
  late final AIModule ai;
  late final NotificationsModule notifications;
  late final AnalyticsModule analytics;
  late final SearchModule search;
  late final WorkflowsModule workflows;
  late final LogicModule logic;
  late final SchemaModule schema;
  late final PushModule push;
  late final EmailModule email;
  late final OAuthModule oauth;
  late final ProjectOAuthModule projectOAuth;
  late final ProjectAuthModule projectAuth;
  late final TriggersModule triggers;
  late final PaymentModule payment;
  late final ImageProcessingModule imageProcessing;
  late final PDFModule pdf;
  late final OCRModule ocr;
  late final DocumentConversionModule documentConversion;
  late final ContentModule content;

  /// Creates a new AppAtOnce client instance - matches Node SDK pattern
  /// Only apiKey is required, timeout and debug are optional
  AppAtOnceClient({
    required String apiKey,
    Duration? timeout,
    bool debug = false,
  }) : config = ClientConfig(
          apiKey: apiKey,
          baseUrl: APPATONCE_BASE_URL,
          realtimeUrl: AppAtOnceDefaults.realtimeUrl,
          debug: debug,
          timeout: timeout ?? AppAtOnceDefaults.timeout,
          retries: AppAtOnceDefaults.maxRetries,
          headers: {},
        ) {
    _initialize();
  }

  /// Factory constructor matching Node SDK create pattern
  factory AppAtOnceClient.create(String apiKey,
      {Duration? timeout, bool debug = false}) {
    return AppAtOnceClient(apiKey: apiKey, timeout: timeout, debug: debug);
  }

  /// Initialize the client and all modules
  void _initialize() {
    // Setup secure storage
    _secureStorage = const FlutterSecureStorage();

    // Setup HTTP client
    _dio = Dio(BaseOptions(
      baseUrl: config.baseUrl ?? AppAtOnceDefaults.baseUrl,
      connectTimeout: config.timeout,
      receiveTimeout: config.timeout,
      headers: {
        'X-API-Key': config.apiKey,
        ...config.headers,
      },
    ));

    // Add interceptors
    if (config.debug) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    // Setup retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            final refreshed = await _sessionManager.refreshSession();
            if (refreshed) {
              // Retry the request
              final opts = error.requestOptions;
              opts.headers['Authorization'] =
                  'Bearer ${_sessionManager.currentSession?.accessToken}';
              final response = await _dio.fetch(opts);
              return handler.resolve(response);
            }
          }
          return handler.next(error);
        },
      ),
    );

    _httpClient = HttpClient(_dio, config);
    _sessionManager = SessionManager(_secureStorage, _httpClient);

    // Initialize modules
    auth = AuthModule(_httpClient, _sessionManager);
    data = DataModule(_httpClient, config);
    storage = StorageModule(_httpClient);
    realtime = RealtimeModule(config, _sessionManager);
    functions = FunctionsModule(_httpClient, config);
    ai = AIModule(_httpClient, config);
    notifications = NotificationsModule(_httpClient, config);
    analytics = AnalyticsModule(_httpClient, config);
    search = SearchModule(_httpClient, config);
    workflows = WorkflowsModule(_httpClient, config);
    logic = LogicModule(_httpClient);
    schema = SchemaModule(_httpClient);
    push = PushModule(_httpClient);
    email = EmailModule(_httpClient);
    oauth = OAuthModule(_httpClient);
    projectOAuth = ProjectOAuthModule(_httpClient);
    projectAuth = ProjectAuthModule(_httpClient);
    triggers = TriggersModule(_httpClient);
    payment = PaymentModule(_httpClient);
    imageProcessing = ImageProcessingModule(_httpClient);
    pdf = PDFModule(_httpClient);
    ocr = OCRModule(_httpClient);
    documentConversion = DocumentConversionModule(_httpClient);
    content = ContentModule(_httpClient, config);
  }

  /// Dispose of resources
  Future<void> dispose() async {
    await realtime.disconnect();
    _dio.close();
  }

  /// Get current session
  Session? get currentSession => _sessionManager.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => _sessionManager.isAuthenticated;

  /// Sign out and clear session
  Future<void> signOut() async {
    await auth.signOut();
    await realtime.disconnect();
  }

  /// Update configuration
  void updateConfig({
    String? baseUrl,
    String? realtimeUrl,
    Map<String, String>? headers,
    bool? debug,
  }) {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }

    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }

    if (debug != null && debug != config.debug) {
      if (debug) {
        _dio.interceptors.add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));
      } else {
        _dio.interceptors.removeWhere((i) => i is LogInterceptor);
      }
    }
  }

  // Core database operations - fluent query builder API (matches Node SDK)
  QueryBuilder<T> table<T>(String tableName) {
    return data.table<T>(tableName);
  }

  // Convenience methods for common operations (matches Node SDK)
  Future<List<T>> select<T>(String tableName) async {
    final result = await table<T>(tableName).execute();
    return result.data;
  }

  Future<T> insert<T>(String tableName, Map<String, dynamic> insertData) async {
    return await table<T>(tableName).insert(insertData);
  }

  Future<List<T>> update<T>(String tableName, Map<String, dynamic> where,
      Map<String, dynamic> updateData) async {
    var query = table<T>(tableName);

    // Apply where conditions
    where.forEach((field, value) {
      query = query.eq(field, value);
    });

    return await query.update(updateData);
  }

  Future<Map<String, int>> delete(
      String tableName, Map<String, dynamic> where) async {
    var query = table(tableName);

    // Apply where conditions
    where.forEach((field, value) {
      query = query.eq(field, value);
    });

    return await query.delete();
  }

  Future<int> count(String tableName, {Map<String, dynamic>? where}) async {
    var query = table(tableName);

    // Apply where conditions if provided
    if (where != null) {
      where.forEach((field, value) {
        query = query.eq(field, value);
      });
    }

    return await query.count();
  }

  // Connection and utility methods (matches Node SDK)
  Future<Map<String, dynamic>> ping() async {
    final response = await _httpClient.get('/health');
    return response;
  }

  void updateApiKey(String apiKey) {
    _httpClient.updateApiKey(apiKey);
  }

  String getApiKey() {
    return config.apiKey;
  }

  // Batch operations (matches Node SDK)
  Future<List<Map<String, dynamic>>> batch(
      List<Map<String, dynamic>> operations) async {
    final response =
        await _httpClient.post('/batch', data: {'operations': operations});
    return (response['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  // Connection state callbacks (matches Node SDK pattern)
  void onConnectionChange(Function(bool connected) callback) {
    // Implementation would integrate with realtime module
  }

  void onError(Function(dynamic error) callback) {
    // Implementation would integrate with realtime module
  }

  /// Cleanup resources
  Future<void> disconnect() async {
    await realtime.disconnect();
  }
}
