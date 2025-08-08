import 'dart:async';
import 'dart:typed_data';
import '../utils/http_client.dart';
import '../common/types.dart';
import 'storage_types.dart';

/// Storage module for file operations
class StorageModule {
  final HttpClient _httpClient;

  StorageModule(this._httpClient);

  // File upload methods

  /// Upload file from bytes
  Future<StorageFile> uploadFile({
    required String bucketName,
    required Uint8List file,
    required String fileName,
    StorageUploadOptions? options,
  }) async {
    final response = await _httpClient.upload(
      '/storage/buckets/$bucketName/upload',
      bytes: file,
      filename: fileName,
      data: {
        if (options?.contentType != null) 'contentType': options!.contentType,
        if (options?.metadata != null) 'metadata': options!.metadata,
        if (options?.cacheControl != null)
          'cacheControl': options!.cacheControl,
        if (options?.acl != null) 'acl': options!.acl!.name,
        if (options?.tags != null) 'tags': options!.tags,
      },
    );

    return StorageFile.fromJson(response.data);
  }

  /// Upload file from base64
  Future<StorageFile> uploadBase64({
    required String bucketName,
    required String base64Data,
    required String fileName,
    StorageUploadOptions? options,
  }) async {
    final response = await _httpClient
        .post('/storage/buckets/$bucketName/upload-base64', data: {
      'data': base64Data,
      'fileName': fileName,
      if (options?.contentType != null) 'contentType': options!.contentType,
      if (options?.metadata != null) 'metadata': options!.metadata,
      if (options?.cacheControl != null) 'cacheControl': options!.cacheControl,
      if (options?.acl != null) 'acl': options!.acl!.name,
      if (options?.tags != null) 'tags': options!.tags,
    });

    return StorageFile.fromJson(response.data);
  }

  /// Upload file from URL
  Future<StorageFile> uploadFromUrl({
    required String bucketName,
    required String url,
    required String fileName,
    StorageUploadOptions? options,
  }) async {
    final response = await _httpClient
        .post('/storage/buckets/$bucketName/upload-url', data: {
      'url': url,
      'fileName': fileName,
      if (options?.contentType != null) 'contentType': options!.contentType,
      if (options?.metadata != null) 'metadata': options!.metadata,
      if (options?.cacheControl != null) 'cacheControl': options!.cacheControl,
      if (options?.acl != null) 'acl': options!.acl!.name,
      if (options?.tags != null) 'tags': options!.tags,
    });

    return StorageFile.fromJson(response.data);
  }

  // File download methods

  /// Download file as bytes
  Future<Uint8List> downloadFile({
    required String bucketName,
    required String fileName,
    StorageDownloadOptions? options,
  }) async {
    final bytes = await _httpClient.download(
      '/storage/buckets/$bucketName/download/$fileName',
      params: {
        if (options?.quality != null) 'quality': options!.quality,
        if (options?.width != null) 'width': options!.width,
        if (options?.height != null) 'height': options!.height,
        if (options?.format != null) 'format': options!.format,
      },
    );

    return Uint8List.fromList(bytes);
  }

  /// Get file URL
  Future<FileUrlResponse> getFileUrl({
    required String bucketName,
    required String fileName,
    int? expiresIn,
    bool? download,
    ImageTransform? transform,
  }) async {
    final response =
        await _httpClient.post('/storage/buckets/$bucketName/url', data: {
      'fileName': fileName,
      if (expiresIn != null) 'expiresIn': expiresIn,
      if (download != null) 'download': download,
      if (transform != null) 'transform': transform.toJson(),
    });

    return FileUrlResponse.fromJson(response.data);
  }

  /// Get public URL
  Future<FileUrlResponse> getPublicUrl({
    required String bucketName,
    required String fileName,
  }) async {
    final response = await _httpClient
        .get('/storage/buckets/$bucketName/public-url/$fileName');
    return FileUrlResponse.fromJson(response.data);
  }

  // File management

  /// List files in bucket
  Future<StorageFileList> listFiles({
    required String bucketName,
    String? prefix,
    int? limit,
    int? offset,
    String? search,
    StorageSortBy? sortBy,
    SortOrder? sortOrder,
  }) async {
    final response = await _httpClient.get(
      '/storage/buckets/$bucketName/files',
      params: {
        if (prefix != null) 'prefix': prefix,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (search != null) 'search': search,
        if (sortBy != null) 'sortBy': sortBy.name,
        if (sortOrder != null) 'sortOrder': sortOrder.name,
      },
    );

    return StorageFileList.fromJson(response.data);
  }

  /// Get file information
  Future<StorageFile> getFileInfo({
    required String bucketName,
    required String fileName,
  }) async {
    final response =
        await _httpClient.get('/storage/buckets/$bucketName/files/$fileName');
    return StorageFile.fromJson(response.data);
  }

  /// Delete file
  Future<void> deleteFile({
    required String bucketName,
    required String fileName,
  }) async {
    await _httpClient.delete('/storage/buckets/$bucketName/files/$fileName');
  }

  /// Delete multiple files
  Future<BatchDeleteResponse> deleteFiles({
    required String bucketName,
    required List<String> fileNames,
  }) async {
    final response = await _httpClient
        .post('/storage/buckets/$bucketName/delete-batch', data: {
      'fileNames': fileNames,
    });

    return BatchDeleteResponse.fromJson(response.data);
  }

  /// Copy file
  Future<StorageFile> copyFile({
    required String sourceBucket,
    required String sourceFile,
    required String destBucket,
    required String destFile,
  }) async {
    final response = await _httpClient.post('/storage/copy', data: {
      'sourceBucket': sourceBucket,
      'sourceFile': sourceFile,
      'destBucket': destBucket,
      'destFile': destFile,
    });

    return StorageFile.fromJson(response.data);
  }

  /// Move file
  Future<StorageFile> moveFile({
    required String sourceBucket,
    required String sourceFile,
    required String destBucket,
    required String destFile,
  }) async {
    final response = await _httpClient.post('/storage/move', data: {
      'sourceBucket': sourceBucket,
      'sourceFile': sourceFile,
      'destBucket': destBucket,
      'destFile': destFile,
    });

    return StorageFile.fromJson(response.data);
  }

  // File metadata and tags

  /// Update file metadata
  Future<StorageFile> updateFileMetadata({
    required String bucketName,
    required String fileName,
    required Map<String, String> metadata,
  }) async {
    final response = await _httpClient.patch(
      '/storage/buckets/$bucketName/files/$fileName/metadata',
      data: {'metadata': metadata},
    );

    return StorageFile.fromJson(response.data);
  }

  /// Update file tags
  Future<StorageFile> updateFileTags({
    required String bucketName,
    required String fileName,
    required Map<String, String> tags,
  }) async {
    final response = await _httpClient.patch(
      '/storage/buckets/$bucketName/files/$fileName/tags',
      data: {'tags': tags},
    );

    return StorageFile.fromJson(response.data);
  }

  /// Update file ACL
  Future<StorageFile> updateFileACL({
    required String bucketName,
    required String fileName,
    required StorageACL acl,
  }) async {
    final response = await _httpClient.patch(
      '/storage/buckets/$bucketName/files/$fileName/acl',
      data: {'acl': acl.name},
    );

    return StorageFile.fromJson(response.data);
  }

  // Bucket management

  /// Create bucket
  Future<StorageBucket> createBucket({
    required String name,
    StorageACL? acl,
    bool? versioning,
    bool? encryption,
    BucketLifecycle? lifecycle,
  }) async {
    final response = await _httpClient.post('/storage/buckets', data: {
      'name': name,
      if (acl != null) 'acl': acl.name,
      if (versioning != null) 'versioning': versioning,
      if (encryption != null) 'encryption': encryption,
      if (lifecycle != null) 'lifecycle': lifecycle.toJson(),
    });

    return StorageBucket.fromJson(response.data);
  }

  /// List buckets
  Future<List<StorageBucket>> listBuckets() async {
    final response = await _httpClient.get('/storage/buckets');
    return (response.data as List)
        .map((item) => StorageBucket.fromJson(item))
        .toList();
  }

  /// Get bucket information
  Future<StorageBucketInfo> getBucketInfo(String bucketName) async {
    final response = await _httpClient.get('/storage/buckets/$bucketName');
    return StorageBucketInfo.fromJson(response.data);
  }

  /// Update bucket
  Future<void> updateBucket({
    required String bucketName,
    StorageACL? acl,
    bool? versioning,
    bool? encryption,
    BucketLifecycle? lifecycle,
  }) async {
    await _httpClient.patch('/storage/buckets/$bucketName', data: {
      if (acl != null) 'acl': acl.name,
      if (versioning != null) 'versioning': versioning,
      if (encryption != null) 'encryption': encryption,
      if (lifecycle != null) 'lifecycle': lifecycle.toJson(),
    });
  }

  /// Delete bucket
  Future<void> deleteBucket({
    required String bucketName,
    bool force = false,
  }) async {
    await _httpClient.delete(
      '/storage/buckets/$bucketName',
      params: {'force': force},
    );
  }

  // Image processing

  /// Resize image
  Future<StorageFile> resizeImage({
    required String bucketName,
    required String fileName,
    required int width,
    required int height,
    int? quality,
    ImageFormat? format,
    ImageFit? fit,
    String? background,
    ImageGravity? gravity,
  }) async {
    final response =
        await _httpClient.post('/storage/buckets/$bucketName/resize', data: {
      'fileName': fileName,
      'width': width,
      'height': height,
      if (quality != null) 'quality': quality,
      if (format != null) 'format': format.name,
      if (fit != null) 'fit': fit.name,
      if (background != null) 'background': background,
      if (gravity != null) 'gravity': gravity.name,
    });

    return StorageFile.fromJson(response.data);
  }

  /// Optimize image
  Future<StorageFile> optimizeImage({
    required String bucketName,
    required String fileName,
    int? quality,
    ImageFormat? format,
    bool? progressive,
    bool? lossless,
  }) async {
    final response =
        await _httpClient.post('/storage/buckets/$bucketName/optimize', data: {
      'fileName': fileName,
      if (quality != null) 'quality': quality,
      if (format != null) 'format': format.name,
      if (progressive != null) 'progressive': progressive,
      if (lossless != null) 'lossless': lossless,
    });

    return StorageFile.fromJson(response.data);
  }

  /// Add watermark to image
  Future<StorageFile> addWatermark({
    required String bucketName,
    required String fileName,
    required String watermarkText,
    WatermarkPosition? position,
    double? opacity,
    int? fontSize,
    String? fontColor,
    String? fontFamily,
  }) async {
    final response =
        await _httpClient.post('/storage/buckets/$bucketName/watermark', data: {
      'fileName': fileName,
      'watermarkText': watermarkText,
      if (position != null) 'position': position.name,
      if (opacity != null) 'opacity': opacity,
      if (fontSize != null) 'fontSize': fontSize,
      if (fontColor != null) 'fontColor': fontColor,
      if (fontFamily != null) 'fontFamily': fontFamily,
    });

    return StorageFile.fromJson(response.data);
  }

  // Analytics and usage

  /// Get storage usage
  Future<StorageUsage> getStorageUsage() async {
    final response = await _httpClient.get('/storage/usage');
    return StorageUsage.fromJson(response.data);
  }

  /// Get storage statistics
  Future<StorageStats> getStorageStats({
    String? bucketName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final url = bucketName != null
        ? '/storage/buckets/$bucketName/stats'
        : '/storage/stats';

    final response = await _httpClient.get(
      url,
      params: {
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      },
    );

    return StorageStats.fromJson(response.data);
  }

  // Backup and sync

  /// Create backup
  Future<StorageBackup> createBackup({
    required String bucketName,
    String? name,
    String? description,
    String? schedule,
    int? retentionDays,
  }) async {
    final response =
        await _httpClient.post('/storage/buckets/$bucketName/backup', data: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (schedule != null) 'schedule': schedule,
      if (retentionDays != null) 'retention_days': retentionDays,
    });

    return StorageBackup.fromJson(response.data);
  }

  /// List backups
  Future<List<StorageBackup>> listBackups(String bucketName) async {
    final response =
        await _httpClient.get('/storage/buckets/$bucketName/backups');
    return (response.data as List)
        .map((item) => StorageBackup.fromJson(item))
        .toList();
  }

  /// Restore backup
  Future<BackupRestoreResponse> restoreBackup({
    required String bucketName,
    required String backupId,
  }) async {
    final response =
        await _httpClient.post('/storage/buckets/$bucketName/restore', data: {
      'backupId': backupId,
    });

    return BackupRestoreResponse.fromJson(response.data);
  }

  /// Delete backup
  Future<void> deleteBackup({
    required String bucketName,
    required String backupId,
  }) async {
    await _httpClient.delete('/storage/buckets/$bucketName/backups/$backupId');
  }
}
