import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

/// Client configuration
@JsonSerializable()
class ClientConfig extends Equatable {
  final String apiKey;
  final String? baseUrl;
  final String? realtimeUrl;
  final bool debug;
  final Duration timeout;
  final int retries;
  final Map<String, String> headers;

  const ClientConfig({
    required this.apiKey,
    this.baseUrl,
    this.realtimeUrl,
    this.debug = false,
    this.timeout = const Duration(seconds: 30),
    this.retries = 3,
    this.headers = const {},
  });

  factory ClientConfig.fromJson(Map<String, dynamic> json) =>
      _$ClientConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ClientConfigToJson(this);

  @override
  List<Object?> get props =>
      [apiKey, baseUrl, realtimeUrl, debug, timeout, retries, headers];
}

/// Response types
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends Equatable {
  final bool success;
  final T? data;
  final String? error;
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.metadata,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [success, data, error, metadata];
}

/// Query options
@JsonSerializable()
class QueryOptions extends Equatable {
  final Map<String, dynamic>? where;
  final List<String>? select;
  final Map<String, String>? orderBy;
  final int? limit;
  final int? offset;
  final List<String>? include;

  const QueryOptions({
    this.where,
    this.select,
    this.orderBy,
    this.limit,
    this.offset,
    this.include,
  });

  factory QueryOptions.fromJson(Map<String, dynamic> json) =>
      _$QueryOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$QueryOptionsToJson(this);

  @override
  List<Object?> get props => [where, select, orderBy, limit, offset, include];
}

/// Realtime types
enum RealtimeEvent {
  connect,
  disconnect,
  error,
  message,
  subscribe,
  unsubscribe,
  presence,
}

@JsonSerializable()
class RealtimeMessage extends Equatable {
  final String channel;
  final String event;
  final dynamic data;
  final DateTime timestamp;

  const RealtimeMessage({
    required this.channel,
    required this.event,
    required this.data,
    required this.timestamp,
  });

  factory RealtimeMessage.fromJson(Map<String, dynamic> json) =>
      _$RealtimeMessageFromJson(json);

  Map<String, dynamic> toJson() => _$RealtimeMessageToJson(this);

  @override
  List<Object?> get props => [channel, event, data, timestamp];
}

/// User types
@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props =>
      [id, email, name, avatarUrl, metadata, createdAt, updatedAt];
}

/// Auth user type (extends User with auth-specific fields)
@JsonSerializable()
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    this.metadata,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  @override
  List<Object?> get props =>
      [id, email, name, avatar, metadata, emailVerified, createdAt, updatedAt];
}

/// Sign up credentials
@JsonSerializable()
class SignUpCredentials extends Equatable {
  final String email;
  final String password;
  final String? name;
  final Map<String, dynamic>? metadata;

  const SignUpCredentials({
    required this.email,
    required this.password,
    this.name,
    this.metadata,
  });

  factory SignUpCredentials.fromJson(Map<String, dynamic> json) =>
      _$SignUpCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpCredentialsToJson(this);

  @override
  List<Object?> get props => [email, password, name, metadata];
}

/// Sign in credentials
@JsonSerializable()
class SignInCredentials extends Equatable {
  final String email;
  final String password;

  const SignInCredentials({
    required this.email,
    required this.password,
  });

  factory SignInCredentials.fromJson(Map<String, dynamic> json) =>
      _$SignInCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$SignInCredentialsToJson(this);

  @override
  List<Object?> get props => [email, password];
}

/// Session types
@JsonSerializable()
class Session extends Equatable {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  final AuthUser user;
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  const Session({
    required this.accessToken,
    this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [accessToken, refreshToken, user, expiresAt];
}

/// Storage types
@JsonSerializable()
class StorageObject extends Equatable {
  final String id;
  final String key;
  final String bucket;
  final int size;
  final String contentType;
  final DateTime lastModified;
  final Map<String, dynamic>? metadata;

  const StorageObject({
    required this.id,
    required this.key,
    required this.bucket,
    required this.size,
    required this.contentType,
    required this.lastModified,
    this.metadata,
  });

  factory StorageObject.fromJson(Map<String, dynamic> json) =>
      _$StorageObjectFromJson(json);

  Map<String, dynamic> toJson() => _$StorageObjectToJson(this);

  @override
  List<Object?> get props =>
      [id, key, bucket, size, contentType, lastModified, metadata];
}

/// AI types
@JsonSerializable()
class AIGenerationResult extends Equatable {
  final String id;
  final String type;
  final dynamic content;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const AIGenerationResult({
    required this.id,
    required this.type,
    required this.content,
    this.metadata,
    required this.createdAt,
  });

  factory AIGenerationResult.fromJson(Map<String, dynamic> json) =>
      _$AIGenerationResultFromJson(json);

  Map<String, dynamic> toJson() => _$AIGenerationResultToJson(this);

  @override
  List<Object?> get props => [id, type, content, metadata, createdAt];
}

/// Analytics types
@JsonSerializable()
class AnalyticsEvent extends Equatable {
  final String name;
  final Map<String, dynamic>? properties;
  final String? userId;
  final String? sessionId;
  final DateTime timestamp;

  const AnalyticsEvent({
    required this.name,
    this.properties,
    this.userId,
    this.sessionId,
    required this.timestamp,
  });

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEventFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsEventToJson(this);

  @override
  List<Object?> get props => [name, properties, userId, sessionId, timestamp];
}

/// Notification types
@JsonSerializable()
class NotificationData extends Equatable {
  final String template;
  final List<String> recipients;
  final Map<String, dynamic>? data;
  final List<String>? channels;
  final Map<String, dynamic>? overrides;

  const NotificationData({
    required this.template,
    required this.recipients,
    this.data,
    this.channels,
    this.overrides,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

  @override
  List<Object?> get props => [template, recipients, data, channels, overrides];
}

/// Storage types
@JsonSerializable()
class StorageFile extends Equatable {
  final String id;
  final String key;
  final String bucket;
  final int size;
  final String contentType;
  final String? url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  final Map<String, String>? tags;

  const StorageFile({
    required this.id,
    required this.key,
    required this.bucket,
    required this.size,
    required this.contentType,
    this.url,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
    this.tags,
  });

  factory StorageFile.fromJson(Map<String, dynamic> json) =>
      _$StorageFileFromJson(json);

  Map<String, dynamic> toJson() => _$StorageFileToJson(this);

  @override
  List<Object?> get props => [
        id,
        key,
        bucket,
        size,
        contentType,
        url,
        createdAt,
        updatedAt,
        metadata,
        tags,
      ];
}

@JsonSerializable()
class StorageUploadOptions extends Equatable {
  final String? contentType;
  final Map<String, String>? metadata;
  final Map<String, String>? tags;
  final String? cacheControl;
  final String? contentDisposition;
  final String? contentEncoding;
  final StorageACL? acl;

  const StorageUploadOptions({
    this.contentType,
    this.metadata,
    this.tags,
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.acl,
  });

  factory StorageUploadOptions.fromJson(Map<String, dynamic> json) =>
      _$StorageUploadOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$StorageUploadOptionsToJson(this);

  @override
  List<Object?> get props => [
        contentType,
        metadata,
        tags,
        cacheControl,
        contentDisposition,
        contentEncoding,
        acl,
      ];
}

@JsonSerializable()
class StorageDownloadOptions extends Equatable {
  final int? quality;
  final int? width;
  final int? height;
  final String? format;

  const StorageDownloadOptions({
    this.quality,
    this.width,
    this.height,
    this.format,
  });

  factory StorageDownloadOptions.fromJson(Map<String, dynamic> json) =>
      _$StorageDownloadOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$StorageDownloadOptionsToJson(this);

  @override
  List<Object?> get props => [quality, width, height, format];
}

@JsonSerializable()
class FileUrlResponse extends Equatable {
  final String url;
  final DateTime expiresAt;
  final Map<String, String>? headers;

  const FileUrlResponse({
    required this.url,
    required this.expiresAt,
    this.headers,
  });

  factory FileUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileUrlResponseToJson(this);

  @override
  List<Object?> get props => [url, expiresAt, headers];
}

@JsonSerializable()
class ImageTransform extends Equatable {
  final int? width;
  final int? height;
  final int? quality;
  final ImageFormat? format;
  final ImageFit? fit;
  final ImageGravity? gravity;
  final String? background;
  final bool? blur;
  final bool? grayscale;

  const ImageTransform({
    this.width,
    this.height,
    this.quality,
    this.format,
    this.fit,
    this.gravity,
    this.background,
    this.blur,
    this.grayscale,
  });

  factory ImageTransform.fromJson(Map<String, dynamic> json) =>
      _$ImageTransformFromJson(json);

  Map<String, dynamic> toJson() => _$ImageTransformToJson(this);

  @override
  List<Object?> get props => [
        width,
        height,
        quality,
        format,
        fit,
        gravity,
        background,
        blur,
        grayscale,
      ];
}

@JsonSerializable()
class StorageFileList extends Equatable {
  final List<StorageFile> files;
  final int total;
  final String? nextToken;

  const StorageFileList({
    required this.files,
    required this.total,
    this.nextToken,
  });

  factory StorageFileList.fromJson(Map<String, dynamic> json) =>
      _$StorageFileListFromJson(json);

  Map<String, dynamic> toJson() => _$StorageFileListToJson(this);

  @override
  List<Object?> get props => [files, total, nextToken];
}

@JsonSerializable()
class BatchDeleteResponse extends Equatable {
  final List<String> deleted;
  final List<String> failed;
  final Map<String, String>? errors;

  const BatchDeleteResponse({
    required this.deleted,
    required this.failed,
    this.errors,
  });

  factory BatchDeleteResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchDeleteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BatchDeleteResponseToJson(this);

  @override
  List<Object?> get props => [deleted, failed, errors];
}

@JsonSerializable()
class StorageBucket extends Equatable {
  final String name;
  final DateTime createdAt;
  final StorageACL? acl;
  final Map<String, dynamic>? metadata;
  final BucketLifecycle? lifecycle;

  const StorageBucket({
    required this.name,
    required this.createdAt,
    this.acl,
    this.metadata,
    this.lifecycle,
  });

  factory StorageBucket.fromJson(Map<String, dynamic> json) =>
      _$StorageBucketFromJson(json);

  Map<String, dynamic> toJson() => _$StorageBucketToJson(this);

  @override
  List<Object?> get props => [name, createdAt, acl, metadata, lifecycle];
}

@JsonSerializable()
class StorageBucketInfo extends Equatable {
  final String name;
  final DateTime createdAt;
  final int objectCount;
  final int totalSize;
  final StorageACL? acl;
  final Map<String, dynamic>? metadata;
  final BucketLifecycle? lifecycle;

  const StorageBucketInfo({
    required this.name,
    required this.createdAt,
    required this.objectCount,
    required this.totalSize,
    this.acl,
    this.metadata,
    this.lifecycle,
  });

  factory StorageBucketInfo.fromJson(Map<String, dynamic> json) =>
      _$StorageBucketInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StorageBucketInfoToJson(this);

  @override
  List<Object?> get props =>
      [name, createdAt, objectCount, totalSize, acl, metadata, lifecycle];
}

@JsonSerializable()
class BucketLifecycle extends Equatable {
  final int? expireDays;
  final int? transitionDays;
  final String? transitionClass;

  const BucketLifecycle({
    this.expireDays,
    this.transitionDays,
    this.transitionClass,
  });

  factory BucketLifecycle.fromJson(Map<String, dynamic> json) =>
      _$BucketLifecycleFromJson(json);

  Map<String, dynamic> toJson() => _$BucketLifecycleToJson(this);

  @override
  List<Object?> get props => [expireDays, transitionDays, transitionClass];
}

/// Storage enums
enum StorageACL {
  @JsonValue('private')
  private,
  @JsonValue('public-read')
  publicRead,
  @JsonValue('public-read-write')
  publicReadWrite,
}

enum StorageSortBy {
  @JsonValue('name')
  name,
  @JsonValue('size')
  size,
  @JsonValue('created_at')
  createdAt,
  @JsonValue('updated_at')
  updatedAt,
}

enum SortOrder {
  @JsonValue('asc')
  asc,
  @JsonValue('desc')
  desc,
}

enum ImageFormat {
  @JsonValue('jpeg')
  jpeg,
  @JsonValue('jpg')
  jpg,
  @JsonValue('png')
  png,
  @JsonValue('webp')
  webp,
  @JsonValue('avif')
  avif,
  @JsonValue('heic')
  heic,
}

enum ImageFit {
  @JsonValue('contain')
  contain,
  @JsonValue('cover')
  cover,
  @JsonValue('fill')
  fill,
  @JsonValue('inside')
  inside,
  @JsonValue('outside')
  outside,
}

enum ImageGravity {
  @JsonValue('center')
  center,
  @JsonValue('north')
  north,
  @JsonValue('northeast')
  northeast,
  @JsonValue('east')
  east,
  @JsonValue('southeast')
  southeast,
  @JsonValue('south')
  south,
  @JsonValue('southwest')
  southwest,
  @JsonValue('west')
  west,
  @JsonValue('northwest')
  northwest,
}

/// Email types
@JsonSerializable()
class EmailTemplate extends Equatable {
  final String id;
  final String name;
  final String subject;
  final String? html;
  final String? text;
  final Map<String, dynamic>? variables;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmailTemplate({
    required this.id,
    required this.name,
    required this.subject,
    this.html,
    this.text,
    this.variables,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmailTemplate.fromJson(Map<String, dynamic> json) =>
      _$EmailTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$EmailTemplateToJson(this);

  @override
  List<Object?> get props =>
      [id, name, subject, html, text, variables, createdAt, updatedAt];
}

@JsonSerializable()
class EmailMessage extends Equatable {
  final String id;
  final List<EmailRecipient> to;
  final List<EmailRecipient>? cc;
  final List<EmailRecipient>? bcc;
  final String subject;
  final String? html;
  final String? text;
  final List<EmailAttachment>? attachments;
  final Map<String, dynamic>? headers;
  final String status;
  final DateTime createdAt;

  const EmailMessage({
    required this.id,
    required this.to,
    this.cc,
    this.bcc,
    required this.subject,
    this.html,
    this.text,
    this.attachments,
    this.headers,
    required this.status,
    required this.createdAt,
  });

  factory EmailMessage.fromJson(Map<String, dynamic> json) =>
      _$EmailMessageFromJson(json);

  Map<String, dynamic> toJson() => _$EmailMessageToJson(this);

  @override
  List<Object?> get props => [
        id,
        to,
        cc,
        bcc,
        subject,
        html,
        text,
        attachments,
        headers,
        status,
        createdAt,
      ];
}

@JsonSerializable()
class EmailRecipient extends Equatable {
  final String email;
  final String? name;

  const EmailRecipient({
    required this.email,
    this.name,
  });

  factory EmailRecipient.fromJson(Map<String, dynamic> json) =>
      _$EmailRecipientFromJson(json);

  Map<String, dynamic> toJson() => _$EmailRecipientToJson(this);

  @override
  List<Object?> get props => [email, name];
}

@JsonSerializable()
class EmailAttachment extends Equatable {
  final String filename;
  final String content;
  final String? contentType;
  final String? contentId;

  const EmailAttachment({
    required this.filename,
    required this.content,
    this.contentType,
    this.contentId,
  });

  factory EmailAttachment.fromJson(Map<String, dynamic> json) =>
      _$EmailAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$EmailAttachmentToJson(this);

  @override
  List<Object?> get props => [filename, content, contentType, contentId];
}

@JsonSerializable()
class EmailCampaign extends Equatable {
  final String id;
  final String name;
  final String subject;
  final String? templateId;
  final List<String> lists;
  final String status;
  final int recipientCount;
  final int sentCount;
  final int deliveredCount;
  final int openedCount;
  final int clickedCount;
  final DateTime? scheduledAt;
  final DateTime createdAt;

  const EmailCampaign({
    required this.id,
    required this.name,
    required this.subject,
    this.templateId,
    required this.lists,
    required this.status,
    required this.recipientCount,
    required this.sentCount,
    required this.deliveredCount,
    required this.openedCount,
    required this.clickedCount,
    this.scheduledAt,
    required this.createdAt,
  });

  factory EmailCampaign.fromJson(Map<String, dynamic> json) =>
      _$EmailCampaignFromJson(json);

  Map<String, dynamic> toJson() => _$EmailCampaignToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        subject,
        templateId,
        lists,
        status,
        recipientCount,
        sentCount,
        deliveredCount,
        openedCount,
        clickedCount,
        scheduledAt,
        createdAt,
      ];
}

@JsonSerializable()
class EmailContact extends Equatable {
  final String id;
  final String email;
  final String? name;
  final Map<String, dynamic>? attributes;
  final List<String> lists;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmailContact({
    required this.id,
    required this.email,
    this.name,
    this.attributes,
    required this.lists,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmailContact.fromJson(Map<String, dynamic> json) =>
      _$EmailContactFromJson(json);

  Map<String, dynamic> toJson() => _$EmailContactToJson(this);

  @override
  List<Object?> get props =>
      [id, email, name, attributes, lists, status, createdAt, updatedAt];
}

@JsonSerializable()
class EmailList extends Equatable {
  final String id;
  final String name;
  final String? description;
  final int contactCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmailList({
    required this.id,
    required this.name,
    this.description,
    required this.contactCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmailList.fromJson(Map<String, dynamic> json) =>
      _$EmailListFromJson(json);

  Map<String, dynamic> toJson() => _$EmailListToJson(this);

  @override
  List<Object?> get props =>
      [id, name, description, contactCount, createdAt, updatedAt];
}

@JsonSerializable()
class EmailAnalytics extends Equatable {
  final int totalSent;
  final int totalDelivered;
  final int totalOpened;
  final int totalClicked;
  final int totalBounced;
  final int totalUnsubscribed;
  final double deliveryRate;
  final double openRate;
  final double clickRate;
  final double bounceRate;
  final double unsubscribeRate;

  const EmailAnalytics({
    required this.totalSent,
    required this.totalDelivered,
    required this.totalOpened,
    required this.totalClicked,
    required this.totalBounced,
    required this.totalUnsubscribed,
    required this.deliveryRate,
    required this.openRate,
    required this.clickRate,
    required this.bounceRate,
    required this.unsubscribeRate,
  });

  factory EmailAnalytics.fromJson(Map<String, dynamic> json) =>
      _$EmailAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$EmailAnalyticsToJson(this);

  @override
  List<Object?> get props => [
        totalSent,
        totalDelivered,
        totalOpened,
        totalClicked,
        totalBounced,
        totalUnsubscribed,
        deliveryRate,
        openRate,
        clickRate,
        bounceRate,
        unsubscribeRate,
      ];
}

@JsonSerializable()
class DomainReputation extends Equatable {
  final String domain;
  final double score;
  final String status;
  final Map<String, dynamic> checks;
  final DateTime lastChecked;

  const DomainReputation({
    required this.domain,
    required this.score,
    required this.status,
    required this.checks,
    required this.lastChecked,
  });

  factory DomainReputation.fromJson(Map<String, dynamic> json) =>
      _$DomainReputationFromJson(json);

  Map<String, dynamic> toJson() => _$DomainReputationToJson(this);

  @override
  List<Object?> get props => [domain, score, status, checks, lastChecked];
}

@JsonSerializable()
class SuppressionList extends Equatable {
  final List<SuppressionEntry> entries;
  final int total;
  final String? nextToken;

  const SuppressionList({
    required this.entries,
    required this.total,
    this.nextToken,
  });

  factory SuppressionList.fromJson(Map<String, dynamic> json) =>
      _$SuppressionListFromJson(json);

  Map<String, dynamic> toJson() => _$SuppressionListToJson(this);

  @override
  List<Object?> get props => [entries, total, nextToken];
}

@JsonSerializable()
class SuppressionEntry extends Equatable {
  final String email;
  final SuppressionType type;
  final String reason;
  final DateTime createdAt;

  const SuppressionEntry({
    required this.email,
    required this.type,
    required this.reason,
    required this.createdAt,
  });

  factory SuppressionEntry.fromJson(Map<String, dynamic> json) =>
      _$SuppressionEntryFromJson(json);

  Map<String, dynamic> toJson() => _$SuppressionEntryToJson(this);

  @override
  List<Object?> get props => [email, type, reason, createdAt];
}

/// Email enums
enum SuppressionType {
  @JsonValue('bounce')
  bounce,
  @JsonValue('complaint')
  complaint,
  @JsonValue('unsubscribe')
  unsubscribe,
  @JsonValue('manual')
  manual,
}
