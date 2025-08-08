import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_types.g.dart';

/// Push priority levels
enum PushPriority {
  low,
  normal,
  high,
  urgent,
}

/// Target types for push notifications
enum TargetType {
  user,
  device,
  segment,
  topic,
  all,
}

/// Device platforms
enum DevicePlatform {
  ios,
  android,
  web,
  windows,
  macos,
  linux,
}

/// Campaign status
enum CampaignStatus {
  draft,
  scheduled,
  sending,
  sent,
  paused,
  cancelled,
  failed,
}

/// Campaign target type
enum CampaignTargetType {
  all,
  segment,
  devices,
  users,
  topic,
}

/// Push response
@JsonSerializable()
class PushResponse extends Equatable {
  final String id;
  final String status;
  @JsonKey(name: 'message_id')
  final String? messageId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const PushResponse({
    required this.id,
    required this.status,
    this.messageId,
    required this.createdAt,
  });

  factory PushResponse.fromJson(Map<String, dynamic> json) =>
      _$PushResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PushResponseToJson(this);

  @override
  List<Object?> get props => [id, status, messageId, createdAt];
}

/// Push notification item for bulk send
@JsonSerializable()
class PushNotificationItem extends Equatable {
  final String to;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? notification;

  const PushNotificationItem({
    required this.to,
    required this.title,
    required this.body,
    this.data,
    this.notification,
  });

  factory PushNotificationItem.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationItemFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationItemToJson(this);

  @override
  List<Object?> get props => [to, title, body, data, notification];
}

/// Bulk push response
@JsonSerializable()
class BulkPushResponse extends Equatable {
  @JsonKey(name: 'batch_id')
  final String batchId;
  @JsonKey(name: 'total_notifications')
  final int totalNotifications;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const BulkPushResponse({
    required this.batchId,
    required this.totalNotifications,
    required this.status,
    required this.createdAt,
  });

  factory BulkPushResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkPushResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BulkPushResponseToJson(this);

  @override
  List<Object?> get props => [batchId, totalNotifications, status, createdAt];
}

/// Device info
@JsonSerializable()
class DeviceInfo extends Equatable {
  final String? model;
  final String? manufacturer;
  final String? osVersion;
  final String? appVersion;

  const DeviceInfo({
    this.model,
    this.manufacturer,
    this.osVersion,
    this.appVersion,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  @override
  List<Object?> get props => [model, manufacturer, osVersion, appVersion];
}

/// Push device
@JsonSerializable()
class PushDevice extends Equatable {
  final String id;
  final String token;
  final DevicePlatform platform;
  final String? userId;
  final DeviceInfo? info;
  final Map<String, dynamic>? metadata;
  final bool active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PushDevice({
    required this.id,
    required this.token,
    required this.platform,
    this.userId,
    this.info,
    this.metadata,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PushDevice.fromJson(Map<String, dynamic> json) =>
      _$PushDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$PushDeviceToJson(this);

  @override
  List<Object?> get props => [
        id,
        token,
        platform,
        userId,
        info,
        metadata,
        active,
        createdAt,
        updatedAt,
      ];
}

/// Push device list
@JsonSerializable()
class PushDeviceList extends Equatable {
  final List<PushDevice> devices;
  final int total;
  final int limit;
  final int offset;

  const PushDeviceList({
    required this.devices,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory PushDeviceList.fromJson(Map<String, dynamic> json) =>
      _$PushDeviceListFromJson(json);

  Map<String, dynamic> toJson() => _$PushDeviceListToJson(this);

  @override
  List<Object?> get props => [devices, total, limit, offset];
}

/// Template variable
@JsonSerializable()
class TemplateVariable extends Equatable {
  final String name;
  final String type;
  final bool required;
  final dynamic defaultValue;

  const TemplateVariable({
    required this.name,
    required this.type,
    required this.required,
    this.defaultValue,
  });

  factory TemplateVariable.fromJson(Map<String, dynamic> json) =>
      _$TemplateVariableFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateVariableToJson(this);

  @override
  List<Object?> get props => [name, type, required, defaultValue];
}

/// Push template
@JsonSerializable()
class PushTemplate extends Equatable {
  final String id;
  final String name;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final List<TemplateVariable>? variables;
  final String? category;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PushTemplate({
    required this.id,
    required this.name,
    required this.title,
    required this.body,
    this.data,
    this.variables,
    this.category,
    this.tags,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PushTemplate.fromJson(Map<String, dynamic> json) =>
      _$PushTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$PushTemplateToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        title,
        body,
        data,
        variables,
        category,
        tags,
        metadata,
        createdAt,
        updatedAt,
      ];
}

/// Push template list
@JsonSerializable()
class PushTemplateList extends Equatable {
  final List<PushTemplate> templates;
  final int total;
  final int limit;
  final int offset;

  const PushTemplateList({
    required this.templates,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory PushTemplateList.fromJson(Map<String, dynamic> json) =>
      _$PushTemplateListFromJson(json);

  Map<String, dynamic> toJson() => _$PushTemplateListToJson(this);

  @override
  List<Object?> get props => [templates, total, limit, offset];
}

/// Push preview
@JsonSerializable()
class PushPreview extends Equatable {
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? platformSpecific;

  const PushPreview({
    required this.title,
    required this.body,
    this.data,
    this.platformSpecific,
  });

  factory PushPreview.fromJson(Map<String, dynamic> json) =>
      _$PushPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$PushPreviewToJson(this);

  @override
  List<Object?> get props => [title, body, data, platformSpecific];
}

/// Campaign segment
@JsonSerializable()
class CampaignSegment extends Equatable {
  final Map<String, dynamic> rules;
  final String? name;
  final String? description;

  const CampaignSegment({
    required this.rules,
    this.name,
    this.description,
  });

  factory CampaignSegment.fromJson(Map<String, dynamic> json) =>
      _$CampaignSegmentFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignSegmentToJson(this);

  @override
  List<Object?> get props => [rules, name, description];
}

/// Push campaign
@JsonSerializable()
class PushCampaign extends Equatable {
  final String id;
  final String name;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final CampaignTargetType targetType;
  final List<String>? targetIds;
  final CampaignSegment? segment;
  final String status;
  @JsonKey(name: 'scheduled_at')
  final DateTime? scheduledAt;
  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;
  final Map<String, dynamic>? stats;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PushCampaign({
    required this.id,
    required this.name,
    required this.title,
    required this.body,
    this.data,
    required this.targetType,
    this.targetIds,
    this.segment,
    required this.status,
    this.scheduledAt,
    this.sentAt,
    this.stats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PushCampaign.fromJson(Map<String, dynamic> json) =>
      _$PushCampaignFromJson(json);

  Map<String, dynamic> toJson() => _$PushCampaignToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        title,
        body,
        data,
        targetType,
        targetIds,
        segment,
        status,
        scheduledAt,
        sentAt,
        stats,
        createdAt,
        updatedAt,
      ];
}

/// Push campaign list
@JsonSerializable()
class PushCampaignList extends Equatable {
  final List<PushCampaign> campaigns;
  final int total;
  final int limit;
  final int offset;

  const PushCampaignList({
    required this.campaigns,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory PushCampaignList.fromJson(Map<String, dynamic> json) =>
      _$PushCampaignListFromJson(json);

  Map<String, dynamic> toJson() => _$PushCampaignListToJson(this);

  @override
  List<Object?> get props => [campaigns, total, limit, offset];
}

/// Campaign launch response (for push)
@JsonSerializable()
class CampaignLaunchResponse extends Equatable {
  final String campaignId;
  final String status;
  final String message;
  @JsonKey(name: 'launched_at')
  final DateTime launchedAt;

  const CampaignLaunchResponse({
    required this.campaignId,
    required this.status,
    required this.message,
    required this.launchedAt,
  });

  factory CampaignLaunchResponse.fromJson(Map<String, dynamic> json) =>
      _$CampaignLaunchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignLaunchResponseToJson(this);

  @override
  List<Object?> get props => [campaignId, status, message, launchedAt];
}

/// Push message status
@JsonSerializable()
class PushMessageStatus extends Equatable {
  final String id;
  final String status;
  final String? error;
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;
  @JsonKey(name: 'opened_at')
  final DateTime? openedAt;

  const PushMessageStatus({
    required this.id,
    required this.status,
    this.error,
    this.deliveredAt,
    this.openedAt,
  });

  factory PushMessageStatus.fromJson(Map<String, dynamic> json) =>
      _$PushMessageStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PushMessageStatusToJson(this);

  @override
  List<Object?> get props => [id, status, error, deliveredAt, openedAt];
}

/// Push status enum
enum PushStatus {
  pending,
  sent,
  delivered,
  opened,
  failed,
}

/// Push log entry
@JsonSerializable()
class PushLogEntry extends Equatable {
  final String id;
  final String deviceId;
  final String? userId;
  final PushStatus status;
  final String? error;
  @JsonKey(name: 'sent_at')
  final DateTime sentAt;
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;
  @JsonKey(name: 'opened_at')
  final DateTime? openedAt;

  const PushLogEntry({
    required this.id,
    required this.deviceId,
    this.userId,
    required this.status,
    this.error,
    required this.sentAt,
    this.deliveredAt,
    this.openedAt,
  });

  factory PushLogEntry.fromJson(Map<String, dynamic> json) =>
      _$PushLogEntryFromJson(json);

  Map<String, dynamic> toJson() => _$PushLogEntryToJson(this);

  @override
  List<Object?> get props => [
        id,
        deviceId,
        userId,
        status,
        error,
        sentAt,
        deliveredAt,
        openedAt,
      ];
}

/// Push log list
@JsonSerializable()
class PushLogList extends Equatable {
  final List<PushLogEntry> logs;
  final int total;
  final int limit;
  final int offset;

  const PushLogList({
    required this.logs,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory PushLogList.fromJson(Map<String, dynamic> json) =>
      _$PushLogListFromJson(json);

  Map<String, dynamic> toJson() => _$PushLogListToJson(this);

  @override
  List<Object?> get props => [logs, total, limit, offset];
}

/// Push stats
@JsonSerializable()
class PushStats extends Equatable {
  @JsonKey(name: 'total_sent')
  final int totalSent;
  @JsonKey(name: 'total_delivered')
  final int totalDelivered;
  @JsonKey(name: 'total_opened')
  final int totalOpened;
  @JsonKey(name: 'total_failed')
  final int totalFailed;
  @JsonKey(name: 'delivery_rate')
  final double deliveryRate;
  @JsonKey(name: 'open_rate')
  final double openRate;

  const PushStats({
    required this.totalSent,
    required this.totalDelivered,
    required this.totalOpened,
    required this.totalFailed,
    required this.deliveryRate,
    required this.openRate,
  });

  factory PushStats.fromJson(Map<String, dynamic> json) =>
      _$PushStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PushStatsToJson(this);

  @override
  List<Object?> get props => [
        totalSent,
        totalDelivered,
        totalOpened,
        totalFailed,
        deliveryRate,
        openRate,
      ];
}

/// Push analytics
@JsonSerializable()
class PushAnalytics extends Equatable {
  final Map<String, dynamic> overview;
  final Map<String, dynamic> byPlatform;
  final Map<String, dynamic> byDevice;
  final Map<String, dynamic> timeline;

  const PushAnalytics({
    required this.overview,
    required this.byPlatform,
    required this.byDevice,
    required this.timeline,
  });

  factory PushAnalytics.fromJson(Map<String, dynamic> json) =>
      _$PushAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$PushAnalyticsToJson(this);

  @override
  List<Object?> get props => [overview, byPlatform, byDevice, timeline];
}

/// FCM config
@JsonSerializable()
class FcmConfig extends Equatable {
  final String? serverKey;
  final String? senderId;
  final Map<String, dynamic>? options;

  const FcmConfig({
    this.serverKey,
    this.senderId,
    this.options,
  });

  factory FcmConfig.fromJson(Map<String, dynamic> json) =>
      _$FcmConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FcmConfigToJson(this);

  @override
  List<Object?> get props => [serverKey, senderId, options];
}

/// APNS config
@JsonSerializable()
class ApnsConfig extends Equatable {
  final String? keyId;
  final String? teamId;
  final String? bundleId;
  final bool? production;
  final Map<String, dynamic>? options;

  const ApnsConfig({
    this.keyId,
    this.teamId,
    this.bundleId,
    this.production,
    this.options,
  });

  factory ApnsConfig.fromJson(Map<String, dynamic> json) =>
      _$ApnsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ApnsConfigToJson(this);

  @override
  List<Object?> get props => [keyId, teamId, bundleId, production, options];
}

/// Push default settings
@JsonSerializable()
class PushDefaultSettings extends Equatable {
  final String? sound;
  final String? badge;
  final int? ttl;
  final PushPriority? priority;

  const PushDefaultSettings({
    this.sound,
    this.badge,
    this.ttl,
    this.priority,
  });

  factory PushDefaultSettings.fromJson(Map<String, dynamic> json) =>
      _$PushDefaultSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PushDefaultSettingsToJson(this);

  @override
  List<Object?> get props => [sound, badge, ttl, priority];
}

/// Push config
@JsonSerializable()
class PushConfig extends Equatable {
  final FcmConfig? fcm;
  final ApnsConfig? apns;
  final PushDefaultSettings? defaults;
  final Map<String, dynamic>? webhooks;

  const PushConfig({
    this.fcm,
    this.apns,
    this.defaults,
    this.webhooks,
  });

  factory PushConfig.fromJson(Map<String, dynamic> json) =>
      _$PushConfigFromJson(json);

  Map<String, dynamic> toJson() => _$PushConfigToJson(this);

  @override
  List<Object?> get props => [fcm, apns, defaults, webhooks];
}

/// Test push response
@JsonSerializable()
class TestPushResponse extends Equatable {
  final bool success;
  final String message;
  final Map<String, dynamic>? details;
  final Map<String, dynamic>? preview;

  const TestPushResponse({
    required this.success,
    required this.message,
    this.details,
    this.preview,
  });

  factory TestPushResponse.fromJson(Map<String, dynamic> json) =>
      _$TestPushResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TestPushResponseToJson(this);

  @override
  List<Object?> get props => [success, message, details, preview];
}
