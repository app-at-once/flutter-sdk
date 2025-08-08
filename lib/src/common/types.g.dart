// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientConfig _$ClientConfigFromJson(Map<String, dynamic> json) => ClientConfig(
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      realtimeUrl: json['realtimeUrl'] as String?,
      debug: json['debug'] as bool? ?? false,
      timeout: json['timeout'] == null
          ? const Duration(seconds: 30)
          : Duration(microseconds: (json['timeout'] as num).toInt()),
      retries: (json['retries'] as num?)?.toInt() ?? 3,
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$ClientConfigToJson(ClientConfig instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'realtimeUrl': instance.realtimeUrl,
      'debug': instance.debug,
      'timeout': instance.timeout.inMicroseconds,
      'retries': instance.retries,
      'headers': instance.headers,
    };

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      success: json['success'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      error: json['error'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'error': instance.error,
      'metadata': instance.metadata,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

QueryOptions _$QueryOptionsFromJson(Map<String, dynamic> json) => QueryOptions(
      where: json['where'] as Map<String, dynamic>?,
      select:
          (json['select'] as List<dynamic>?)?.map((e) => e as String).toList(),
      orderBy: (json['orderBy'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
      include:
          (json['include'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QueryOptionsToJson(QueryOptions instance) =>
    <String, dynamic>{
      'where': instance.where,
      'select': instance.select,
      'orderBy': instance.orderBy,
      'limit': instance.limit,
      'offset': instance.offset,
      'include': instance.include,
    };

RealtimeMessage _$RealtimeMessageFromJson(Map<String, dynamic> json) =>
    RealtimeMessage(
      channel: json['channel'] as String,
      event: json['event'] as String,
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$RealtimeMessageToJson(RealtimeMessage instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'event': instance.event,
      'data': instance.data,
      'timestamp': instance.timestamp.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      emailVerified: json['email_verified'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar': instance.avatar,
      'metadata': instance.metadata,
      'email_verified': instance.emailVerified,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

SignUpCredentials _$SignUpCredentialsFromJson(Map<String, dynamic> json) =>
    SignUpCredentials(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SignUpCredentialsToJson(SignUpCredentials instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'metadata': instance.metadata,
    };

SignInCredentials _$SignInCredentialsFromJson(Map<String, dynamic> json) =>
    SignInCredentials(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignInCredentialsToJson(SignInCredentials instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
      'expires_at': instance.expiresAt.toIso8601String(),
    };

StorageObject _$StorageObjectFromJson(Map<String, dynamic> json) =>
    StorageObject(
      id: json['id'] as String,
      key: json['key'] as String,
      bucket: json['bucket'] as String,
      size: (json['size'] as num).toInt(),
      contentType: json['contentType'] as String,
      lastModified: DateTime.parse(json['lastModified'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StorageObjectToJson(StorageObject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'bucket': instance.bucket,
      'size': instance.size,
      'contentType': instance.contentType,
      'lastModified': instance.lastModified.toIso8601String(),
      'metadata': instance.metadata,
    };

AIGenerationResult _$AIGenerationResultFromJson(Map<String, dynamic> json) =>
    AIGenerationResult(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'],
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AIGenerationResultToJson(AIGenerationResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'content': instance.content,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };

AnalyticsEvent _$AnalyticsEventFromJson(Map<String, dynamic> json) =>
    AnalyticsEvent(
      name: json['name'] as String,
      properties: json['properties'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
      sessionId: json['sessionId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$AnalyticsEventToJson(AnalyticsEvent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'properties': instance.properties,
      'userId': instance.userId,
      'sessionId': instance.sessionId,
      'timestamp': instance.timestamp.toIso8601String(),
    };

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      template: json['template'] as String,
      recipients: (json['recipients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      data: json['data'] as Map<String, dynamic>?,
      channels: (json['channels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      overrides: json['overrides'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'template': instance.template,
      'recipients': instance.recipients,
      'data': instance.data,
      'channels': instance.channels,
      'overrides': instance.overrides,
    };

StorageFile _$StorageFileFromJson(Map<String, dynamic> json) => StorageFile(
      id: json['id'] as String,
      key: json['key'] as String,
      bucket: json['bucket'] as String,
      size: (json['size'] as num).toInt(),
      contentType: json['contentType'] as String,
      url: json['url'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$StorageFileToJson(StorageFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'bucket': instance.bucket,
      'size': instance.size,
      'contentType': instance.contentType,
      'url': instance.url,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
      'tags': instance.tags,
    };

StorageUploadOptions _$StorageUploadOptionsFromJson(
        Map<String, dynamic> json) =>
    StorageUploadOptions(
      contentType: json['contentType'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      cacheControl: json['cacheControl'] as String?,
      contentDisposition: json['contentDisposition'] as String?,
      contentEncoding: json['contentEncoding'] as String?,
      acl: $enumDecodeNullable(_$StorageACLEnumMap, json['acl']),
    );

Map<String, dynamic> _$StorageUploadOptionsToJson(
        StorageUploadOptions instance) =>
    <String, dynamic>{
      'contentType': instance.contentType,
      'metadata': instance.metadata,
      'tags': instance.tags,
      'cacheControl': instance.cacheControl,
      'contentDisposition': instance.contentDisposition,
      'contentEncoding': instance.contentEncoding,
      'acl': _$StorageACLEnumMap[instance.acl],
    };

const _$StorageACLEnumMap = {
  StorageACL.private: 'private',
  StorageACL.publicRead: 'public-read',
  StorageACL.publicReadWrite: 'public-read-write',
};

StorageDownloadOptions _$StorageDownloadOptionsFromJson(
        Map<String, dynamic> json) =>
    StorageDownloadOptions(
      quality: (json['quality'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      format: json['format'] as String?,
    );

Map<String, dynamic> _$StorageDownloadOptionsToJson(
        StorageDownloadOptions instance) =>
    <String, dynamic>{
      'quality': instance.quality,
      'width': instance.width,
      'height': instance.height,
      'format': instance.format,
    };

FileUrlResponse _$FileUrlResponseFromJson(Map<String, dynamic> json) =>
    FileUrlResponse(
      url: json['url'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$FileUrlResponseToJson(FileUrlResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'headers': instance.headers,
    };

ImageTransform _$ImageTransformFromJson(Map<String, dynamic> json) =>
    ImageTransform(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      quality: (json['quality'] as num?)?.toInt(),
      format: $enumDecodeNullable(_$ImageFormatEnumMap, json['format']),
      fit: $enumDecodeNullable(_$ImageFitEnumMap, json['fit']),
      gravity: $enumDecodeNullable(_$ImageGravityEnumMap, json['gravity']),
      background: json['background'] as String?,
      blur: json['blur'] as bool?,
      grayscale: json['grayscale'] as bool?,
    );

Map<String, dynamic> _$ImageTransformToJson(ImageTransform instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'quality': instance.quality,
      'format': _$ImageFormatEnumMap[instance.format],
      'fit': _$ImageFitEnumMap[instance.fit],
      'gravity': _$ImageGravityEnumMap[instance.gravity],
      'background': instance.background,
      'blur': instance.blur,
      'grayscale': instance.grayscale,
    };

const _$ImageFormatEnumMap = {
  ImageFormat.jpeg: 'jpeg',
  ImageFormat.jpg: 'jpg',
  ImageFormat.png: 'png',
  ImageFormat.webp: 'webp',
  ImageFormat.avif: 'avif',
  ImageFormat.heic: 'heic',
};

const _$ImageFitEnumMap = {
  ImageFit.contain: 'contain',
  ImageFit.cover: 'cover',
  ImageFit.fill: 'fill',
  ImageFit.inside: 'inside',
  ImageFit.outside: 'outside',
};

const _$ImageGravityEnumMap = {
  ImageGravity.center: 'center',
  ImageGravity.north: 'north',
  ImageGravity.northeast: 'northeast',
  ImageGravity.east: 'east',
  ImageGravity.southeast: 'southeast',
  ImageGravity.south: 'south',
  ImageGravity.southwest: 'southwest',
  ImageGravity.west: 'west',
  ImageGravity.northwest: 'northwest',
};

StorageFileList _$StorageFileListFromJson(Map<String, dynamic> json) =>
    StorageFileList(
      files: (json['files'] as List<dynamic>)
          .map((e) => StorageFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      nextToken: json['nextToken'] as String?,
    );

Map<String, dynamic> _$StorageFileListToJson(StorageFileList instance) =>
    <String, dynamic>{
      'files': instance.files,
      'total': instance.total,
      'nextToken': instance.nextToken,
    };

BatchDeleteResponse _$BatchDeleteResponseFromJson(Map<String, dynamic> json) =>
    BatchDeleteResponse(
      deleted:
          (json['deleted'] as List<dynamic>).map((e) => e as String).toList(),
      failed:
          (json['failed'] as List<dynamic>).map((e) => e as String).toList(),
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$BatchDeleteResponseToJson(
        BatchDeleteResponse instance) =>
    <String, dynamic>{
      'deleted': instance.deleted,
      'failed': instance.failed,
      'errors': instance.errors,
    };

StorageBucket _$StorageBucketFromJson(Map<String, dynamic> json) =>
    StorageBucket(
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acl: $enumDecodeNullable(_$StorageACLEnumMap, json['acl']),
      metadata: json['metadata'] as Map<String, dynamic>?,
      lifecycle: json['lifecycle'] == null
          ? null
          : BucketLifecycle.fromJson(json['lifecycle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StorageBucketToJson(StorageBucket instance) =>
    <String, dynamic>{
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'acl': _$StorageACLEnumMap[instance.acl],
      'metadata': instance.metadata,
      'lifecycle': instance.lifecycle,
    };

StorageBucketInfo _$StorageBucketInfoFromJson(Map<String, dynamic> json) =>
    StorageBucketInfo(
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      objectCount: (json['objectCount'] as num).toInt(),
      totalSize: (json['totalSize'] as num).toInt(),
      acl: $enumDecodeNullable(_$StorageACLEnumMap, json['acl']),
      metadata: json['metadata'] as Map<String, dynamic>?,
      lifecycle: json['lifecycle'] == null
          ? null
          : BucketLifecycle.fromJson(json['lifecycle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StorageBucketInfoToJson(StorageBucketInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'objectCount': instance.objectCount,
      'totalSize': instance.totalSize,
      'acl': _$StorageACLEnumMap[instance.acl],
      'metadata': instance.metadata,
      'lifecycle': instance.lifecycle,
    };

BucketLifecycle _$BucketLifecycleFromJson(Map<String, dynamic> json) =>
    BucketLifecycle(
      expireDays: (json['expireDays'] as num?)?.toInt(),
      transitionDays: (json['transitionDays'] as num?)?.toInt(),
      transitionClass: json['transitionClass'] as String?,
    );

Map<String, dynamic> _$BucketLifecycleToJson(BucketLifecycle instance) =>
    <String, dynamic>{
      'expireDays': instance.expireDays,
      'transitionDays': instance.transitionDays,
      'transitionClass': instance.transitionClass,
    };

EmailTemplate _$EmailTemplateFromJson(Map<String, dynamic> json) =>
    EmailTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      html: json['html'] as String?,
      text: json['text'] as String?,
      variables: json['variables'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EmailTemplateToJson(EmailTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subject': instance.subject,
      'html': instance.html,
      'text': instance.text,
      'variables': instance.variables,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

EmailMessage _$EmailMessageFromJson(Map<String, dynamic> json) => EmailMessage(
      id: json['id'] as String,
      to: (json['to'] as List<dynamic>)
          .map((e) => EmailRecipient.fromJson(e as Map<String, dynamic>))
          .toList(),
      cc: (json['cc'] as List<dynamic>?)
          ?.map((e) => EmailRecipient.fromJson(e as Map<String, dynamic>))
          .toList(),
      bcc: (json['bcc'] as List<dynamic>?)
          ?.map((e) => EmailRecipient.fromJson(e as Map<String, dynamic>))
          .toList(),
      subject: json['subject'] as String,
      html: json['html'] as String?,
      text: json['text'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => EmailAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      headers: json['headers'] as Map<String, dynamic>?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$EmailMessageToJson(EmailMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'to': instance.to,
      'cc': instance.cc,
      'bcc': instance.bcc,
      'subject': instance.subject,
      'html': instance.html,
      'text': instance.text,
      'attachments': instance.attachments,
      'headers': instance.headers,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };

EmailRecipient _$EmailRecipientFromJson(Map<String, dynamic> json) =>
    EmailRecipient(
      email: json['email'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$EmailRecipientToJson(EmailRecipient instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
    };

EmailAttachment _$EmailAttachmentFromJson(Map<String, dynamic> json) =>
    EmailAttachment(
      filename: json['filename'] as String,
      content: json['content'] as String,
      contentType: json['contentType'] as String?,
      contentId: json['contentId'] as String?,
    );

Map<String, dynamic> _$EmailAttachmentToJson(EmailAttachment instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'content': instance.content,
      'contentType': instance.contentType,
      'contentId': instance.contentId,
    };

EmailCampaign _$EmailCampaignFromJson(Map<String, dynamic> json) =>
    EmailCampaign(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      templateId: json['templateId'] as String?,
      lists: (json['lists'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      recipientCount: (json['recipientCount'] as num).toInt(),
      sentCount: (json['sentCount'] as num).toInt(),
      deliveredCount: (json['deliveredCount'] as num).toInt(),
      openedCount: (json['openedCount'] as num).toInt(),
      clickedCount: (json['clickedCount'] as num).toInt(),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$EmailCampaignToJson(EmailCampaign instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subject': instance.subject,
      'templateId': instance.templateId,
      'lists': instance.lists,
      'status': instance.status,
      'recipientCount': instance.recipientCount,
      'sentCount': instance.sentCount,
      'deliveredCount': instance.deliveredCount,
      'openedCount': instance.openedCount,
      'clickedCount': instance.clickedCount,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

EmailContact _$EmailContactFromJson(Map<String, dynamic> json) => EmailContact(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      lists: (json['lists'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EmailContactToJson(EmailContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'attributes': instance.attributes,
      'lists': instance.lists,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

EmailList _$EmailListFromJson(Map<String, dynamic> json) => EmailList(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      contactCount: (json['contactCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EmailListToJson(EmailList instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'contactCount': instance.contactCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

EmailAnalytics _$EmailAnalyticsFromJson(Map<String, dynamic> json) =>
    EmailAnalytics(
      totalSent: (json['totalSent'] as num).toInt(),
      totalDelivered: (json['totalDelivered'] as num).toInt(),
      totalOpened: (json['totalOpened'] as num).toInt(),
      totalClicked: (json['totalClicked'] as num).toInt(),
      totalBounced: (json['totalBounced'] as num).toInt(),
      totalUnsubscribed: (json['totalUnsubscribed'] as num).toInt(),
      deliveryRate: (json['deliveryRate'] as num).toDouble(),
      openRate: (json['openRate'] as num).toDouble(),
      clickRate: (json['clickRate'] as num).toDouble(),
      bounceRate: (json['bounceRate'] as num).toDouble(),
      unsubscribeRate: (json['unsubscribeRate'] as num).toDouble(),
    );

Map<String, dynamic> _$EmailAnalyticsToJson(EmailAnalytics instance) =>
    <String, dynamic>{
      'totalSent': instance.totalSent,
      'totalDelivered': instance.totalDelivered,
      'totalOpened': instance.totalOpened,
      'totalClicked': instance.totalClicked,
      'totalBounced': instance.totalBounced,
      'totalUnsubscribed': instance.totalUnsubscribed,
      'deliveryRate': instance.deliveryRate,
      'openRate': instance.openRate,
      'clickRate': instance.clickRate,
      'bounceRate': instance.bounceRate,
      'unsubscribeRate': instance.unsubscribeRate,
    };

DomainReputation _$DomainReputationFromJson(Map<String, dynamic> json) =>
    DomainReputation(
      domain: json['domain'] as String,
      score: (json['score'] as num).toDouble(),
      status: json['status'] as String,
      checks: json['checks'] as Map<String, dynamic>,
      lastChecked: DateTime.parse(json['lastChecked'] as String),
    );

Map<String, dynamic> _$DomainReputationToJson(DomainReputation instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'score': instance.score,
      'status': instance.status,
      'checks': instance.checks,
      'lastChecked': instance.lastChecked.toIso8601String(),
    };

SuppressionList _$SuppressionListFromJson(Map<String, dynamic> json) =>
    SuppressionList(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => SuppressionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      nextToken: json['nextToken'] as String?,
    );

Map<String, dynamic> _$SuppressionListToJson(SuppressionList instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'total': instance.total,
      'nextToken': instance.nextToken,
    };

SuppressionEntry _$SuppressionEntryFromJson(Map<String, dynamic> json) =>
    SuppressionEntry(
      email: json['email'] as String,
      type: $enumDecode(_$SuppressionTypeEnumMap, json['type']),
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SuppressionEntryToJson(SuppressionEntry instance) =>
    <String, dynamic>{
      'email': instance.email,
      'type': _$SuppressionTypeEnumMap[instance.type]!,
      'reason': instance.reason,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SuppressionTypeEnumMap = {
  SuppressionType.bounce: 'bounce',
  SuppressionType.complaint: 'complaint',
  SuppressionType.unsubscribe: 'unsubscribe',
  SuppressionType.manual: 'manual',
};
