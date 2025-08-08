import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'storage_types.g.dart';

/// Watermark position
enum WatermarkPosition {
  topLeft,
  topCenter,
  topRight,
  middleLeft,
  center,
  middleRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Storage usage
@JsonSerializable()
class StorageUsage extends Equatable {
  @JsonKey(name: 'used_bytes')
  final int usedBytes;
  @JsonKey(name: 'total_bytes')
  final int totalBytes;
  @JsonKey(name: 'file_count')
  final int fileCount;
  @JsonKey(name: 'bucket_count')
  final int bucketCount;

  const StorageUsage({
    required this.usedBytes,
    required this.totalBytes,
    required this.fileCount,
    required this.bucketCount,
  });

  factory StorageUsage.fromJson(Map<String, dynamic> json) =>
      _$StorageUsageFromJson(json);

  Map<String, dynamic> toJson() => _$StorageUsageToJson(this);

  @override
  List<Object?> get props => [usedBytes, totalBytes, fileCount, bucketCount];
}

/// Storage stats
@JsonSerializable()
class StorageStats extends Equatable {
  final StorageUsage usage;
  @JsonKey(name: 'bandwidth_used')
  final int bandwidthUsed;
  @JsonKey(name: 'bandwidth_limit')
  final int bandwidthLimit;
  @JsonKey(name: 'requests_count')
  final int requestsCount;
  @JsonKey(name: 'requests_limit')
  final int requestsLimit;

  const StorageStats({
    required this.usage,
    required this.bandwidthUsed,
    required this.bandwidthLimit,
    required this.requestsCount,
    required this.requestsLimit,
  });

  factory StorageStats.fromJson(Map<String, dynamic> json) =>
      _$StorageStatsFromJson(json);

  Map<String, dynamic> toJson() => _$StorageStatsToJson(this);

  @override
  List<Object?> get props => [
        usage,
        bandwidthUsed,
        bandwidthLimit,
        requestsCount,
        requestsLimit,
      ];
}

/// Storage backup
@JsonSerializable()
class StorageBackup extends Equatable {
  final String id;
  final String name;
  final String bucketId;
  @JsonKey(name: 'size_bytes')
  final int sizeBytes;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  final String? url;
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  const StorageBackup({
    required this.id,
    required this.name,
    required this.bucketId,
    required this.sizeBytes,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.url,
    this.expiresAt,
  });

  factory StorageBackup.fromJson(Map<String, dynamic> json) =>
      _$StorageBackupFromJson(json);

  Map<String, dynamic> toJson() => _$StorageBackupToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        bucketId,
        sizeBytes,
        status,
        createdAt,
        completedAt,
        url,
        expiresAt,
      ];
}

/// Backup restore response
@JsonSerializable()
class BackupRestoreResponse extends Equatable {
  final String id;
  final String status;
  final String message;
  @JsonKey(name: 'restored_count')
  final int restoredCount;
  @JsonKey(name: 'failed_count')
  final int failedCount;

  const BackupRestoreResponse({
    required this.id,
    required this.status,
    required this.message,
    required this.restoredCount,
    required this.failedCount,
  });

  factory BackupRestoreResponse.fromJson(Map<String, dynamic> json) =>
      _$BackupRestoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BackupRestoreResponseToJson(this);

  @override
  List<Object?> get props => [id, status, message, restoredCount, failedCount];
}
