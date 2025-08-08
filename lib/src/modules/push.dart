import 'dart:async';
import '../utils/http_client.dart';
import 'push_types.dart';

/// Push notification module for sending notifications to iOS, Android, and web devices
class PushModule {
  final HttpClient _httpClient;
  String? _cachedAppId;

  PushModule(this._httpClient);

  /// Get app ID from auth endpoint
  Future<String> _getAppId() async {
    if (_cachedAppId != null) return _cachedAppId!;

    final response = await _httpClient.get('/auth/me');
    _cachedAppId = response.data['appId'];
    return _cachedAppId!;
  }

  // Send push notifications

  /// Send push notification
  Future<PushResponse> send({
    required dynamic to, // String or List<String>
    required String title,
    required String body,
    Map<String, dynamic>? data,
    int? badge,
    String? sound,
    String? image,
    PushPriority priority = PushPriority.normal,
    TargetType targetType = TargetType.user,
    List<String>? tags,
    bool silent = false,
    bool mutableContent = false,
    String? category,
    String? threadId,
    int? ttl,
    DateTime? scheduledAt,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.post('/apps/$appId/push/send', data: {
      'to': to,
      'title': title,
      'body': body,
      if (data != null) 'data': data,
      if (badge != null) 'badge': badge,
      if (sound != null) 'sound': sound,
      if (image != null) 'image': image,
      'priority': priority.name,
      'targetType': targetType.name,
      if (tags != null) 'tags': tags,
      'silent': silent,
      'mutableContent': mutableContent,
      if (category != null) 'category': category,
      if (threadId != null) 'threadId': threadId,
      if (ttl != null) 'ttl': ttl,
      if (scheduledAt != null) 'scheduledAt': scheduledAt.toIso8601String(),
    });

    return PushResponse.fromJson(response.data);
  }

  /// Send bulk push notifications
  Future<BulkPushResponse> sendBulk({
    required List<PushNotificationItem> notifications,
  }) async {
    final appId = await _getAppId();

    final response =
        await _httpClient.post('/apps/$appId/push/send-bulk', data: {
      'notifications': notifications.map((n) => n.toJson()).toList(),
    });

    return BulkPushResponse.fromJson(response.data);
  }

  /// Send push with template
  Future<PushResponse> sendWithTemplate({
    required String templateId,
    required dynamic to,
    TargetType targetType = TargetType.user,
    List<String>? tags,
    Map<String, dynamic>? data,
    Map<String, dynamic>? variables,
    DateTime? scheduledAt,
  }) async {
    final appId = await _getAppId();

    final response =
        await _httpClient.post('/apps/$appId/push/send-template', data: {
      'templateId': templateId,
      'to': to,
      'targetType': targetType.name,
      if (tags != null) 'tags': tags,
      if (data != null) 'data': data,
      if (variables != null) 'variables': variables,
      if (scheduledAt != null) 'scheduledAt': scheduledAt.toIso8601String(),
    });

    return PushResponse.fromJson(response.data);
  }

  // Device management

  /// Register device for push notifications
  Future<PushDevice> registerDevice({
    required String userId,
    required String deviceToken,
    required DevicePlatform platform,
    DeviceInfo? deviceInfo,
    List<String>? tags,
  }) async {
    final appId = await _getAppId();

    final response =
        await _httpClient.post('/apps/$appId/push/device/register', data: {
      'userId': userId,
      'deviceToken': deviceToken,
      'platform': platform.name,
      if (deviceInfo != null) 'deviceInfo': deviceInfo.toJson(),
      if (tags != null) 'tags': tags,
    });

    return PushDevice.fromJson(response.data);
  }

  /// Unregister device
  Future<void> unregisterDevice(String deviceToken) async {
    final appId = await _getAppId();
    await _httpClient.delete('/apps/$appId/push/device/$deviceToken');
  }

  /// Update device information
  Future<PushDevice> updateDevice({
    required String deviceToken,
    List<String>? tags,
    Map<String, dynamic>? deviceInfo,
    bool? active,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.patch(
      '/apps/$appId/push/device/$deviceToken',
      data: {
        if (tags != null) 'tags': tags,
        if (deviceInfo != null) 'deviceInfo': deviceInfo,
        if (active != null) 'active': active,
      },
    );

    return PushDevice.fromJson(response.data);
  }

  /// Get device information
  Future<PushDevice> getDevice(String deviceToken) async {
    final appId = await _getAppId();
    final response =
        await _httpClient.get('/apps/$appId/push/device/$deviceToken');
    return PushDevice.fromJson(response.data);
  }

  /// List devices
  Future<PushDeviceList> listDevices({
    String? userId,
    DevicePlatform? platform,
    List<String>? tags,
    bool? active,
    int? limit,
    int? offset,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.get(
      '/apps/$appId/push/devices',
      params: {
        if (userId != null) 'userId': userId,
        if (platform != null) 'platform': platform.name,
        if (tags != null) 'tags': tags,
        if (active != null) 'active': active,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return PushDeviceList.fromJson(response.data);
  }

  // Push templates

  /// Create push template
  Future<PushTemplate> createTemplate({
    required String name,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? sound,
    int? badge,
    String? image,
    List<TemplateVariable>? variables,
    List<String>? tags,
    String? category,
  }) async {
    final appId = await _getAppId();

    final response =
        await _httpClient.post('/apps/$appId/push/templates', data: {
      'name': name,
      'title': title,
      'body': body,
      if (data != null) 'data': data,
      if (sound != null) 'sound': sound,
      if (badge != null) 'badge': badge,
      if (image != null) 'image': image,
      if (variables != null)
        'variables': variables.map((v) => v.toJson()).toList(),
      if (tags != null) 'tags': tags,
      if (category != null) 'category': category,
    });

    return PushTemplate.fromJson(response.data);
  }

  /// Update push template
  Future<PushTemplate> updateTemplate({
    required String templateId,
    String? name,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? sound,
    int? badge,
    String? image,
    List<TemplateVariable>? variables,
    List<String>? tags,
    String? category,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.patch(
      '/apps/$appId/push/templates/$templateId',
      data: {
        if (name != null) 'name': name,
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        if (data != null) 'data': data,
        if (sound != null) 'sound': sound,
        if (badge != null) 'badge': badge,
        if (image != null) 'image': image,
        if (variables != null)
          'variables': variables.map((v) => v.toJson()).toList(),
        if (tags != null) 'tags': tags,
        if (category != null) 'category': category,
      },
    );

    return PushTemplate.fromJson(response.data);
  }

  /// Get push template
  Future<PushTemplate> getTemplate(String templateId) async {
    final appId = await _getAppId();
    final response =
        await _httpClient.get('/apps/$appId/push/templates/$templateId');
    return PushTemplate.fromJson(response.data);
  }

  /// List push templates
  Future<PushTemplateList> listTemplates({
    String? category,
    List<String>? tags,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.get(
      '/apps/$appId/push/templates',
      params: {
        if (category != null) 'category': category,
        if (tags != null) 'tags': tags,
        if (search != null) 'search': search,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return PushTemplateList.fromJson(response.data);
  }

  /// Delete push template
  Future<void> deleteTemplate(String templateId) async {
    final appId = await _getAppId();
    await _httpClient.delete('/apps/$appId/push/templates/$templateId');
  }

  /// Preview push template
  Future<PushPreview> previewTemplate({
    required String templateId,
    Map<String, dynamic>? variables,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.post(
      '/apps/$appId/push/templates/$templateId/preview',
      data: {'variables': variables ?? {}},
    );

    return PushPreview.fromJson(response.data);
  }

  // Push campaigns

  /// Create push campaign
  Future<PushCampaign> createCampaign({
    required String name,
    required String title,
    required String body,
    required CampaignTargetType targetType,
    List<String>? tags,
    CampaignSegment? segment,
    Map<String, dynamic>? data,
    String? image,
    String? sound,
    int? badge,
    DateTime? scheduledAt,
    DateTime? expiresAt,
  }) async {
    final appId = await _getAppId();

    final response =
        await _httpClient.post('/apps/$appId/push/campaigns', data: {
      'name': name,
      'title': title,
      'body': body,
      'targetType': targetType.name,
      if (tags != null) 'tags': tags,
      if (segment != null) 'segment': segment.toJson(),
      if (data != null) 'data': data,
      if (image != null) 'image': image,
      if (sound != null) 'sound': sound,
      if (badge != null) 'badge': badge,
      if (scheduledAt != null) 'scheduledAt': scheduledAt.toIso8601String(),
      if (expiresAt != null) 'expiresAt': expiresAt.toIso8601String(),
    });

    return PushCampaign.fromJson(response.data);
  }

  /// Update push campaign
  Future<PushCampaign> updateCampaign({
    required String campaignId,
    String? name,
    String? title,
    String? body,
    CampaignTargetType? targetType,
    List<String>? tags,
    CampaignSegment? segment,
    Map<String, dynamic>? data,
    DateTime? scheduledAt,
    DateTime? expiresAt,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.patch(
      '/apps/$appId/push/campaigns/$campaignId',
      data: {
        if (name != null) 'name': name,
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        if (targetType != null) 'targetType': targetType.name,
        if (tags != null) 'tags': tags,
        if (segment != null) 'segment': segment.toJson(),
        if (data != null) 'data': data,
        if (scheduledAt != null) 'scheduledAt': scheduledAt.toIso8601String(),
        if (expiresAt != null) 'expiresAt': expiresAt.toIso8601String(),
      },
    );

    return PushCampaign.fromJson(response.data);
  }

  /// Get push campaign
  Future<PushCampaign> getCampaign(String campaignId) async {
    final appId = await _getAppId();
    final response =
        await _httpClient.get('/apps/$appId/push/campaigns/$campaignId');
    return PushCampaign.fromJson(response.data);
  }

  /// List push campaigns
  Future<PushCampaignList> listCampaigns({
    CampaignStatus? status,
    int? limit,
    int? offset,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.get(
      '/apps/$appId/push/campaigns',
      params: {
        if (status != null) 'status': status.name,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return PushCampaignList.fromJson(response.data);
  }

  /// Launch push campaign
  Future<CampaignLaunchResponse> launchCampaign(String campaignId) async {
    final appId = await _getAppId();

    final response = await _httpClient
        .post('/apps/$appId/push/campaigns/$campaignId/launch');
    return CampaignLaunchResponse.fromJson(response.data);
  }

  /// Cancel push campaign
  Future<void> cancelCampaign(String campaignId) async {
    final appId = await _getAppId();
    await _httpClient.post('/apps/$appId/push/campaigns/$campaignId/cancel');
  }

  /// Delete push campaign
  Future<void> deleteCampaign(String campaignId) async {
    final appId = await _getAppId();
    await _httpClient.delete('/apps/$appId/push/campaigns/$campaignId');
  }

  // Analytics and tracking

  /// Track push delivered
  Future<void> trackDelivered(String messageId) async {
    final appId = await _getAppId();
    await _httpClient.post('/apps/$appId/push/track/delivered/$messageId');
  }

  /// Track push opened
  Future<void> trackOpened(String messageId, {String? userId}) async {
    final appId = await _getAppId();
    await _httpClient.post(
      '/apps/$appId/push/track/opened/$messageId',
      data: {if (userId != null) 'userId': userId},
    );
  }

  /// Get message status
  Future<PushMessageStatus> getMessageStatus(String messageId) async {
    final appId = await _getAppId();
    final response =
        await _httpClient.get('/apps/$appId/push/messages/$messageId');
    return PushMessageStatus.fromJson(response.data);
  }

  /// Get push logs
  Future<PushLogList> getLogs({
    String? userId,
    String? deviceId,
    PushStatus? status,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.get(
      '/apps/$appId/push/logs',
      params: {
        if (userId != null) 'userId': userId,
        if (deviceId != null) 'deviceId': deviceId,
        if (status != null) 'status': status.name,
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return PushLogList.fromJson(response.data);
  }

  /// Get push statistics
  Future<PushStats> getStats({DateTime? from, DateTime? to}) async {
    final appId = await _getAppId();

    final response = await _httpClient.get(
      '/apps/$appId/push/stats',
      params: {
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
      },
    );

    return PushStats.fromJson(response.data);
  }

  /// Get push analytics
  Future<PushAnalytics> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.get(
      '/apps/$appId/push/analytics',
      params: {
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      },
    );

    return PushAnalytics.fromJson(response.data);
  }

  // Push configuration

  /// Get push configuration
  Future<PushConfig> getConfig() async {
    final appId = await _getAppId();
    final response = await _httpClient.get('/apps/$appId/push/config');
    return PushConfig.fromJson(response.data);
  }

  /// Update push configuration
  Future<void> updateConfig({
    FcmConfig? fcmConfig,
    ApnsConfig? apnsConfig,
    PushDefaultSettings? defaultSettings,
  }) async {
    final appId = await _getAppId();

    await _httpClient.put('/apps/$appId/push/config', data: {
      if (fcmConfig != null) 'fcmConfig': fcmConfig.toJson(),
      if (apnsConfig != null) 'apnsConfig': apnsConfig.toJson(),
      if (defaultSettings != null) 'defaultSettings': defaultSettings.toJson(),
    });
  }

  /// Send test push notification
  Future<TestPushResponse> sendTest({
    required String deviceToken,
    required DevicePlatform platform,
  }) async {
    final appId = await _getAppId();

    final response = await _httpClient.post('/apps/$appId/push/test', data: {
      'deviceToken': deviceToken,
      'platform': platform.name,
    });

    return TestPushResponse.fromJson(response.data);
  }
}
