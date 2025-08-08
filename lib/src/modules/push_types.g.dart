// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushResponse _$PushResponseFromJson(Map<String, dynamic> json) => PushResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      messageId: json['message_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PushResponseToJson(PushResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'message_id': instance.messageId,
      'created_at': instance.createdAt.toIso8601String(),
    };

PushNotificationItem _$PushNotificationItemFromJson(
        Map<String, dynamic> json) =>
    PushNotificationItem(
      to: json['to'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      notification: json['notification'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PushNotificationItemToJson(
        PushNotificationItem instance) =>
    <String, dynamic>{
      'to': instance.to,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'notification': instance.notification,
    };

BulkPushResponse _$BulkPushResponseFromJson(Map<String, dynamic> json) =>
    BulkPushResponse(
      batchId: json['batch_id'] as String,
      totalNotifications: (json['total_notifications'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BulkPushResponseToJson(BulkPushResponse instance) =>
    <String, dynamic>{
      'batch_id': instance.batchId,
      'total_notifications': instance.totalNotifications,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      model: json['model'] as String?,
      manufacturer: json['manufacturer'] as String?,
      osVersion: json['osVersion'] as String?,
      appVersion: json['appVersion'] as String?,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'model': instance.model,
      'manufacturer': instance.manufacturer,
      'osVersion': instance.osVersion,
      'appVersion': instance.appVersion,
    };

PushDevice _$PushDeviceFromJson(Map<String, dynamic> json) => PushDevice(
      id: json['id'] as String,
      token: json['token'] as String,
      platform: $enumDecode(_$DevicePlatformEnumMap, json['platform']),
      userId: json['userId'] as String?,
      info: json['info'] == null
          ? null
          : DeviceInfo.fromJson(json['info'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PushDeviceToJson(PushDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'platform': _$DevicePlatformEnumMap[instance.platform]!,
      'userId': instance.userId,
      'info': instance.info,
      'metadata': instance.metadata,
      'active': instance.active,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$DevicePlatformEnumMap = {
  DevicePlatform.ios: 'ios',
  DevicePlatform.android: 'android',
  DevicePlatform.web: 'web',
  DevicePlatform.windows: 'windows',
  DevicePlatform.macos: 'macos',
  DevicePlatform.linux: 'linux',
};

PushDeviceList _$PushDeviceListFromJson(Map<String, dynamic> json) =>
    PushDeviceList(
      devices: (json['devices'] as List<dynamic>)
          .map((e) => PushDevice.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$PushDeviceListToJson(PushDeviceList instance) =>
    <String, dynamic>{
      'devices': instance.devices,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

TemplateVariable _$TemplateVariableFromJson(Map<String, dynamic> json) =>
    TemplateVariable(
      name: json['name'] as String,
      type: json['type'] as String,
      required: json['required'] as bool,
      defaultValue: json['defaultValue'],
    );

Map<String, dynamic> _$TemplateVariableToJson(TemplateVariable instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'required': instance.required,
      'defaultValue': instance.defaultValue,
    };

PushTemplate _$PushTemplateFromJson(Map<String, dynamic> json) => PushTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      variables: (json['variables'] as List<dynamic>?)
          ?.map((e) => TemplateVariable.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PushTemplateToJson(PushTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'variables': instance.variables,
      'category': instance.category,
      'tags': instance.tags,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

PushTemplateList _$PushTemplateListFromJson(Map<String, dynamic> json) =>
    PushTemplateList(
      templates: (json['templates'] as List<dynamic>)
          .map((e) => PushTemplate.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$PushTemplateListToJson(PushTemplateList instance) =>
    <String, dynamic>{
      'templates': instance.templates,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

PushPreview _$PushPreviewFromJson(Map<String, dynamic> json) => PushPreview(
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      platformSpecific: json['platformSpecific'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PushPreviewToJson(PushPreview instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'platformSpecific': instance.platformSpecific,
    };

CampaignSegment _$CampaignSegmentFromJson(Map<String, dynamic> json) =>
    CampaignSegment(
      rules: json['rules'] as Map<String, dynamic>,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CampaignSegmentToJson(CampaignSegment instance) =>
    <String, dynamic>{
      'rules': instance.rules,
      'name': instance.name,
      'description': instance.description,
    };

PushCampaign _$PushCampaignFromJson(Map<String, dynamic> json) => PushCampaign(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      targetType: $enumDecode(_$CampaignTargetTypeEnumMap, json['targetType']),
      targetIds: (json['targetIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      segment: json['segment'] == null
          ? null
          : CampaignSegment.fromJson(json['segment'] as Map<String, dynamic>),
      status: json['status'] as String,
      scheduledAt: json['scheduled_at'] == null
          ? null
          : DateTime.parse(json['scheduled_at'] as String),
      sentAt: json['sent_at'] == null
          ? null
          : DateTime.parse(json['sent_at'] as String),
      stats: json['stats'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PushCampaignToJson(PushCampaign instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'targetType': _$CampaignTargetTypeEnumMap[instance.targetType]!,
      'targetIds': instance.targetIds,
      'segment': instance.segment,
      'status': instance.status,
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'sent_at': instance.sentAt?.toIso8601String(),
      'stats': instance.stats,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$CampaignTargetTypeEnumMap = {
  CampaignTargetType.all: 'all',
  CampaignTargetType.segment: 'segment',
  CampaignTargetType.devices: 'devices',
  CampaignTargetType.users: 'users',
  CampaignTargetType.topic: 'topic',
};

PushCampaignList _$PushCampaignListFromJson(Map<String, dynamic> json) =>
    PushCampaignList(
      campaigns: (json['campaigns'] as List<dynamic>)
          .map((e) => PushCampaign.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$PushCampaignListToJson(PushCampaignList instance) =>
    <String, dynamic>{
      'campaigns': instance.campaigns,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

CampaignLaunchResponse _$CampaignLaunchResponseFromJson(
        Map<String, dynamic> json) =>
    CampaignLaunchResponse(
      campaignId: json['campaignId'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      launchedAt: DateTime.parse(json['launched_at'] as String),
    );

Map<String, dynamic> _$CampaignLaunchResponseToJson(
        CampaignLaunchResponse instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
      'status': instance.status,
      'message': instance.message,
      'launched_at': instance.launchedAt.toIso8601String(),
    };

PushMessageStatus _$PushMessageStatusFromJson(Map<String, dynamic> json) =>
    PushMessageStatus(
      id: json['id'] as String,
      status: json['status'] as String,
      error: json['error'] as String?,
      deliveredAt: json['delivered_at'] == null
          ? null
          : DateTime.parse(json['delivered_at'] as String),
      openedAt: json['opened_at'] == null
          ? null
          : DateTime.parse(json['opened_at'] as String),
    );

Map<String, dynamic> _$PushMessageStatusToJson(PushMessageStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'error': instance.error,
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'opened_at': instance.openedAt?.toIso8601String(),
    };

PushLogEntry _$PushLogEntryFromJson(Map<String, dynamic> json) => PushLogEntry(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      userId: json['userId'] as String?,
      status: $enumDecode(_$PushStatusEnumMap, json['status']),
      error: json['error'] as String?,
      sentAt: DateTime.parse(json['sent_at'] as String),
      deliveredAt: json['delivered_at'] == null
          ? null
          : DateTime.parse(json['delivered_at'] as String),
      openedAt: json['opened_at'] == null
          ? null
          : DateTime.parse(json['opened_at'] as String),
    );

Map<String, dynamic> _$PushLogEntryToJson(PushLogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'userId': instance.userId,
      'status': _$PushStatusEnumMap[instance.status]!,
      'error': instance.error,
      'sent_at': instance.sentAt.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'opened_at': instance.openedAt?.toIso8601String(),
    };

const _$PushStatusEnumMap = {
  PushStatus.pending: 'pending',
  PushStatus.sent: 'sent',
  PushStatus.delivered: 'delivered',
  PushStatus.opened: 'opened',
  PushStatus.failed: 'failed',
};

PushLogList _$PushLogListFromJson(Map<String, dynamic> json) => PushLogList(
      logs: (json['logs'] as List<dynamic>)
          .map((e) => PushLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$PushLogListToJson(PushLogList instance) =>
    <String, dynamic>{
      'logs': instance.logs,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

PushStats _$PushStatsFromJson(Map<String, dynamic> json) => PushStats(
      totalSent: (json['total_sent'] as num).toInt(),
      totalDelivered: (json['total_delivered'] as num).toInt(),
      totalOpened: (json['total_opened'] as num).toInt(),
      totalFailed: (json['total_failed'] as num).toInt(),
      deliveryRate: (json['delivery_rate'] as num).toDouble(),
      openRate: (json['open_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$PushStatsToJson(PushStats instance) => <String, dynamic>{
      'total_sent': instance.totalSent,
      'total_delivered': instance.totalDelivered,
      'total_opened': instance.totalOpened,
      'total_failed': instance.totalFailed,
      'delivery_rate': instance.deliveryRate,
      'open_rate': instance.openRate,
    };

PushAnalytics _$PushAnalyticsFromJson(Map<String, dynamic> json) =>
    PushAnalytics(
      overview: json['overview'] as Map<String, dynamic>,
      byPlatform: json['byPlatform'] as Map<String, dynamic>,
      byDevice: json['byDevice'] as Map<String, dynamic>,
      timeline: json['timeline'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$PushAnalyticsToJson(PushAnalytics instance) =>
    <String, dynamic>{
      'overview': instance.overview,
      'byPlatform': instance.byPlatform,
      'byDevice': instance.byDevice,
      'timeline': instance.timeline,
    };

FcmConfig _$FcmConfigFromJson(Map<String, dynamic> json) => FcmConfig(
      serverKey: json['serverKey'] as String?,
      senderId: json['senderId'] as String?,
      options: json['options'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FcmConfigToJson(FcmConfig instance) => <String, dynamic>{
      'serverKey': instance.serverKey,
      'senderId': instance.senderId,
      'options': instance.options,
    };

ApnsConfig _$ApnsConfigFromJson(Map<String, dynamic> json) => ApnsConfig(
      keyId: json['keyId'] as String?,
      teamId: json['teamId'] as String?,
      bundleId: json['bundleId'] as String?,
      production: json['production'] as bool?,
      options: json['options'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ApnsConfigToJson(ApnsConfig instance) =>
    <String, dynamic>{
      'keyId': instance.keyId,
      'teamId': instance.teamId,
      'bundleId': instance.bundleId,
      'production': instance.production,
      'options': instance.options,
    };

PushDefaultSettings _$PushDefaultSettingsFromJson(Map<String, dynamic> json) =>
    PushDefaultSettings(
      sound: json['sound'] as String?,
      badge: json['badge'] as String?,
      ttl: (json['ttl'] as num?)?.toInt(),
      priority: $enumDecodeNullable(_$PushPriorityEnumMap, json['priority']),
    );

Map<String, dynamic> _$PushDefaultSettingsToJson(
        PushDefaultSettings instance) =>
    <String, dynamic>{
      'sound': instance.sound,
      'badge': instance.badge,
      'ttl': instance.ttl,
      'priority': _$PushPriorityEnumMap[instance.priority],
    };

const _$PushPriorityEnumMap = {
  PushPriority.low: 'low',
  PushPriority.normal: 'normal',
  PushPriority.high: 'high',
  PushPriority.urgent: 'urgent',
};

PushConfig _$PushConfigFromJson(Map<String, dynamic> json) => PushConfig(
      fcm: json['fcm'] == null
          ? null
          : FcmConfig.fromJson(json['fcm'] as Map<String, dynamic>),
      apns: json['apns'] == null
          ? null
          : ApnsConfig.fromJson(json['apns'] as Map<String, dynamic>),
      defaults: json['defaults'] == null
          ? null
          : PushDefaultSettings.fromJson(
              json['defaults'] as Map<String, dynamic>),
      webhooks: json['webhooks'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PushConfigToJson(PushConfig instance) =>
    <String, dynamic>{
      'fcm': instance.fcm,
      'apns': instance.apns,
      'defaults': instance.defaults,
      'webhooks': instance.webhooks,
    };

TestPushResponse _$TestPushResponseFromJson(Map<String, dynamic> json) =>
    TestPushResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>?,
      preview: json['preview'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TestPushResponseToJson(TestPushResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'details': instance.details,
      'preview': instance.preview,
    };
