import 'dart:typed_data';
import '../common/types.dart';
import '../utils/http_client.dart';

/// Content item class
class ContentItem {
  final String id;
  final String resourceId;
  final String resourceType;
  final String contentType;
  final String title;
  final dynamic content;
  final Map<String, dynamic>? metadata;
  final String status;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final String? updatedBy;

  ContentItem({
    required this.id,
    required this.resourceId,
    required this.resourceType,
    required this.contentType,
    required this.title,
    required this.content,
    this.metadata,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.updatedBy,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'],
      resourceId: json['resourceId'],
      resourceType: json['resourceType'],
      contentType: json['contentType'],
      title: json['title'],
      content: json['content'],
      metadata: json['metadata'],
      status: json['status'],
      version: json['version'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resourceId': resourceId,
      'resourceType': resourceType,
      'contentType': contentType,
      'title': title,
      'content': content,
      'metadata': metadata,
      'status': status,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'updatedBy': updatedBy,
    };
  }
}

/// Content list response
class ContentListResponse {
  final List<ContentItem> items;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  ContentListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory ContentListResponse.fromJson(Map<String, dynamic> json) {
    return ContentListResponse(
      items: (json['items'] as List)
          .map((item) => ContentItem.fromJson(item))
          .toList(),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      hasMore: json['hasMore'],
    );
  }
}

/// Content version history
class ContentVersion {
  final int version;
  final dynamic content;
  final Map<String, dynamic>? metadata;
  final String? updatedBy;
  final DateTime updatedAt;

  ContentVersion({
    required this.version,
    required this.content,
    this.metadata,
    this.updatedBy,
    required this.updatedAt,
  });

  factory ContentVersion.fromJson(Map<String, dynamic> json) {
    return ContentVersion(
      version: json['version'],
      content: json['content'],
      metadata: json['metadata'],
      updatedBy: json['updatedBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

/// Content module for content management
class ContentModule {
  final HttpClient _httpClient;
  final ClientConfig _config;

  ContentModule(this._httpClient, this._config);

  /// Create content item
  Future<ContentItem> create({
    required String resourceId,
    required String resourceType,
    required String contentType,
    required String title,
    required dynamic content,
    Map<String, dynamic>? metadata,
    String status = 'draft',
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content',
      data: {
        'resourceId': resourceId,
        'resourceType': resourceType,
        'contentType': contentType,
        'title': title,
        'content': content,
        'metadata': metadata,
        'status': status,
      },
    );

    return ContentItem.fromJson(response);
  }

  /// Update content item
  Future<ContentItem> update(
    String id, {
    String? title,
    dynamic content,
    Map<String, dynamic>? metadata,
    String? status,
  }) async {
    final response = await _httpClient.patch<Map<String, dynamic>>(
      '/content/$id',
      data: {
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (metadata != null) 'metadata': metadata,
        if (status != null) 'status': status,
      },
    );

    return ContentItem.fromJson(response);
  }

  /// Get content item by ID
  Future<ContentItem> getById(String id) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/content/$id',
    );

    return ContentItem.fromJson(response);
  }

  /// List content items
  Future<ContentListResponse> list({
    String? resourceId,
    String? resourceType,
    String? contentType,
    String? status,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortOrder,
  }) async {
    final queryParams = <String, dynamic>{};

    if (resourceId != null) queryParams['resourceId'] = resourceId;
    if (resourceType != null) queryParams['resourceType'] = resourceType;
    if (contentType != null) queryParams['contentType'] = contentType;
    if (status != null) queryParams['status'] = status;
    queryParams['page'] = page;
    queryParams['limit'] = limit;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

    final response = await _httpClient.get<Map<String, dynamic>>(
      '/content',
      params: queryParams,
    );

    return ContentListResponse.fromJson(response);
  }

  /// Delete content item
  Future<void> delete(String id) async {
    await _httpClient.delete('/content/$id');
  }

  /// Publish content item
  Future<ContentItem> publish(String id) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/$id/publish',
    );

    return ContentItem.fromJson(response);
  }

  /// Unpublish content item
  Future<ContentItem> unpublish(String id) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/$id/unpublish',
    );

    return ContentItem.fromJson(response);
  }

  /// Archive content item
  Future<ContentItem> archive(String id) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/$id/archive',
    );

    return ContentItem.fromJson(response);
  }

  /// Restore content item
  Future<ContentItem> restore(String id) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/$id/restore',
    );

    return ContentItem.fromJson(response);
  }

  /// Search content
  Future<ContentListResponse> search(
    String query, {
    String? resourceId,
    String? resourceType,
    String? contentType,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'q': query,
      'page': page,
      'limit': limit,
    };

    if (resourceId != null) queryParams['resourceId'] = resourceId;
    if (resourceType != null) queryParams['resourceType'] = resourceType;
    if (contentType != null) queryParams['contentType'] = contentType;

    final response = await _httpClient.get<Map<String, dynamic>>(
      '/content/search',
      params: queryParams,
    );

    return ContentListResponse.fromJson(response);
  }

  /// Get content version history
  Future<List<ContentVersion>> getVersionHistory(String id) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/content/$id/versions',
    );

    final versions = response['versions'] as List;
    return versions.map((v) => ContentVersion.fromJson(v)).toList();
  }

  /// Restore content to specific version
  Future<ContentItem> restoreVersion(String id, int version) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/$id/restore/$version',
    );

    return ContentItem.fromJson(response);
  }

  /// Duplicate content item
  Future<ContentItem> duplicate(
    String id, {
    String? title,
    String? resourceId,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/$id/duplicate',
      data: {
        if (title != null) 'title': title,
        if (resourceId != null) 'resourceId': resourceId,
      },
    );

    return ContentItem.fromJson(response);
  }

  /// Bulk operations
  Future<Map<String, dynamic>> bulkUpdate(
    List<String> ids, {
    String? status,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/bulk/update',
      data: {
        'ids': ids,
        if (status != null) 'status': status,
        if (metadata != null) 'metadata': metadata,
      },
    );

    return response;
  }

  /// Bulk delete
  Future<Map<String, dynamic>> bulkDelete(List<String> ids) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/content/bulk/delete',
      data: {
        'ids': ids,
      },
    );

    return response;
  }

  /// Upload content attachment
  Future<Map<String, dynamic>> uploadAttachment(
    String contentId,
    Uint8List bytes,
    String filename, {
    String? contentType,
  }) async {
    final response = await _httpClient.upload<Map<String, dynamic>>(
      '/content/$contentId/attachments',
      bytes: bytes,
      filename: filename,
      data: {
        if (contentType != null) 'contentType': contentType,
      },
    );

    return response;
  }

  /// Delete content attachment
  Future<void> deleteAttachment(String contentId, String attachmentId) async {
    await _httpClient.delete('/content/$contentId/attachments/$attachmentId');
  }
}
