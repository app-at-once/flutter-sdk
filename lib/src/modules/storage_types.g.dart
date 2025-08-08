// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageUsage _$StorageUsageFromJson(Map<String, dynamic> json) => StorageUsage(
      usedBytes: (json['used_bytes'] as num).toInt(),
      totalBytes: (json['total_bytes'] as num).toInt(),
      fileCount: (json['file_count'] as num).toInt(),
      bucketCount: (json['bucket_count'] as num).toInt(),
    );

Map<String, dynamic> _$StorageUsageToJson(StorageUsage instance) =>
    <String, dynamic>{
      'used_bytes': instance.usedBytes,
      'total_bytes': instance.totalBytes,
      'file_count': instance.fileCount,
      'bucket_count': instance.bucketCount,
    };

StorageStats _$StorageStatsFromJson(Map<String, dynamic> json) => StorageStats(
      usage: StorageUsage.fromJson(json['usage'] as Map<String, dynamic>),
      bandwidthUsed: (json['bandwidth_used'] as num).toInt(),
      bandwidthLimit: (json['bandwidth_limit'] as num).toInt(),
      requestsCount: (json['requests_count'] as num).toInt(),
      requestsLimit: (json['requests_limit'] as num).toInt(),
    );

Map<String, dynamic> _$StorageStatsToJson(StorageStats instance) =>
    <String, dynamic>{
      'usage': instance.usage,
      'bandwidth_used': instance.bandwidthUsed,
      'bandwidth_limit': instance.bandwidthLimit,
      'requests_count': instance.requestsCount,
      'requests_limit': instance.requestsLimit,
    };

StorageBackup _$StorageBackupFromJson(Map<String, dynamic> json) =>
    StorageBackup(
      id: json['id'] as String,
      name: json['name'] as String,
      bucketId: json['bucketId'] as String,
      sizeBytes: (json['size_bytes'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      url: json['url'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$StorageBackupToJson(StorageBackup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bucketId': instance.bucketId,
      'size_bytes': instance.sizeBytes,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'url': instance.url,
      'expires_at': instance.expiresAt?.toIso8601String(),
    };

BackupRestoreResponse _$BackupRestoreResponseFromJson(
        Map<String, dynamic> json) =>
    BackupRestoreResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      restoredCount: (json['restored_count'] as num).toInt(),
      failedCount: (json['failed_count'] as num).toInt(),
    );

Map<String, dynamic> _$BackupRestoreResponseToJson(
        BackupRestoreResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'message': instance.message,
      'restored_count': instance.restoredCount,
      'failed_count': instance.failedCount,
    };
