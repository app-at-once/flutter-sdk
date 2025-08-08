import 'dart:async';
import '../common/types.dart';
import '../utils/http_client.dart';

/// Notifications module for managing notifications
class NotificationsModule {
  final HttpClient _httpClient;
  final ClientConfig _config;

  NotificationsModule(this._httpClient, this._config);

  /// Send a notification
  Future<Map<String, dynamic>> send(NotificationData notification) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/notifications/send',
      data: notification.toJson(),
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Send bulk notifications
  Future<Map<String, dynamic>> sendBulk(
    List<NotificationData> notifications,
  ) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/notifications/send-bulk',
      data: notifications.map((n) => n.toJson()).toList(),
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Create or update subscriber
  Future<Map<String, dynamic>> upsertSubscriber({
    required String subscriberId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? avatar,
    Map<String, dynamic>? data,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/notifications/subscribers',
      data: {
        'subscriberId': subscriberId,
        'email': email,
        'phone': phone,
        'firstName': firstName,
        'lastName': lastName,
        'avatar': avatar,
        'data': data,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Get subscriber preferences
  Future<Map<String, dynamic>> getPreferences(String subscriberId) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/notifications/preferences/$subscriberId',
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Update subscriber preferences
  Future<Map<String, dynamic>> updatePreferences(
    String subscriberId,
    Map<String, dynamic> preferences,
  ) async {
    final response = await _httpClient.put<Map<String, dynamic>>(
      '/notifications/preferences/$subscriberId',
      data: preferences,
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Get notification history
  Future<List<Map<String, dynamic>>> getHistory({
    String? subscriberId,
    int? limit,
    int? offset,
  }) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/notifications/history',
      params: {
        'subscriberId': subscriberId,
        'limit': limit,
        'offset': offset,
      },
    );

    return (response['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Get notification templates
  Future<List<Map<String, dynamic>>> getTemplates() async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/notifications/templates',
    );

    return (response['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Create notification template
  Future<Map<String, dynamic>> createTemplate({
    required String name,
    String? description,
    required List<String> channels,
    required Map<String, dynamic> content,
    List<String>? variables,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/notifications/workflows/templates',
      data: {
        'name': name,
        'description': description,
        'channels': channels,
        'content': content,
        'variables': variables,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Send templated notification
  Future<Map<String, dynamic>> sendTemplated({
    required String templateId,
    required List<String> recipients,
    Map<String, dynamic>? data,
    List<String>? channels,
    DateTime? schedule,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/notifications/workflows/templates/$templateId/send',
      data: {
        'recipients': recipients,
        'data': data,
        'channels': channels,
        'schedule': schedule?.toIso8601String(),
      },
    );

    return response['data'] as Map<String, dynamic>;
  }
}
