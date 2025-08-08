import 'dart:async';
import '../common/types.dart';
import '../utils/http_client.dart';

/// Analytics module for tracking events and metrics
class AnalyticsModule {
  final HttpClient _httpClient;
  final ClientConfig _config;

  final List<AnalyticsEvent> _eventQueue = [];
  Timer? _flushTimer;
  static const int _batchSize = 50;
  static const Duration _flushInterval = Duration(seconds: 30);

  AnalyticsModule(this._httpClient, this._config) {
    _startFlushTimer();
  }

  /// Track an event
  Future<void> track({
    required String eventName,
    Map<String, dynamic>? properties,
    String? userId,
    String? sessionId,
  }) async {
    final event = AnalyticsEvent(
      name: eventName,
      properties: properties,
      userId: userId,
      sessionId: sessionId,
      timestamp: DateTime.now(),
    );

    _eventQueue.add(event);

    if (_eventQueue.length >= _batchSize) {
      await flush();
    }
  }

  /// Track page view
  Future<void> trackPageView({
    required String path,
    String? title,
    String? referrer,
    Map<String, dynamic>? properties,
    String? userId,
    String? sessionId,
  }) async {
    await track(
      eventName: 'page_view',
      properties: {
        'path': path,
        'title': title,
        'referrer': referrer,
        ...?properties,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Track API request
  Future<void> trackApiRequest({
    required String endpoint,
    required String method,
    int? statusCode,
    int? duration,
    Map<String, dynamic>? properties,
  }) async {
    await track(
      eventName: 'api_request',
      properties: {
        'endpoint': endpoint,
        'method': method,
        'status_code': statusCode,
        'duration': duration,
        ...?properties,
      },
    );
  }

  /// Identify user
  Future<void> identify({
    required String userId,
    Map<String, dynamic>? traits,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/analytics/identify',
      data: {
        'userId': userId,
        'traits': traits,
      },
    );
  }

  /// Set user properties
  Future<void> setUserProperties({
    required String userId,
    required Map<String, dynamic> properties,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/analytics/users/$userId/properties',
      data: properties,
    );
  }

  /// Increment user property
  Future<void> incrementUserProperty({
    required String userId,
    required String property,
    int value = 1,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/analytics/users/$userId/increment',
      data: {
        'property': property,
        'value': value,
      },
    );
  }

  /// Query analytics data
  Future<Map<String, dynamic>> query({
    required String metric,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? dimensions,
    Map<String, dynamic>? filters,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/analytics/query',
      data: {
        'metric': metric,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'dimensions': dimensions,
        'filters': filters,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Get funnel analysis
  Future<Map<String, dynamic>> getFunnel({
    required List<String> steps,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? filters,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/analytics/funnel',
      data: {
        'steps': steps,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'filters': filters,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Get retention analysis
  Future<Map<String, dynamic>> getRetention({
    required String cohortEvent,
    required String returnEvent,
    DateTime? startDate,
    DateTime? endDate,
    String period = 'day',
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/analytics/retention',
      data: {
        'cohortEvent': cohortEvent,
        'returnEvent': returnEvent,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'period': period,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Flush event queue
  Future<void> flush() async {
    if (_eventQueue.isEmpty) return;

    final events = List<AnalyticsEvent>.from(_eventQueue);
    _eventQueue.clear();

    try {
      await _httpClient.post<Map<String, dynamic>>(
        '/analytics/events',
        data: {
          'events': events.map((e) => e.toJson()).toList(),
        },
      );
    } catch (e) {
      // Re-add events to queue on failure
      _eventQueue.insertAll(0, events);
      rethrow;
    }
  }

  /// Start flush timer
  void _startFlushTimer() {
    _flushTimer = Timer.periodic(_flushInterval, (_) {
      flush();
    });
  }

  /// Dispose resources
  void dispose() {
    _flushTimer?.cancel();
    flush(); // Final flush
  }
}
