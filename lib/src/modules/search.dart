import 'dart:async';
import '../common/types.dart';
import '../utils/http_client.dart';

/// Search result
class SearchResult {
  final String id;
  final String table;
  final Map<String, dynamic> data;
  final double? score;
  final Map<String, dynamic>? highlights;

  SearchResult({
    required this.id,
    required this.table,
    required this.data,
    this.score,
    this.highlights,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      table: json['table'],
      data: json['data'],
      score: json['score'],
      highlights: json['highlights'],
    );
  }
}

/// Vector search result
class VectorSearchResult {
  final String id;
  final Map<String, dynamic> payload;
  final double score;

  VectorSearchResult({
    required this.id,
    required this.payload,
    required this.score,
  });

  factory VectorSearchResult.fromJson(Map<String, dynamic> json) {
    return VectorSearchResult(
      id: json['id'],
      payload: json['payload'],
      score: json['score'],
    );
  }
}

/// Search module for full-text and vector search
class SearchModule {
  final HttpClient _httpClient;
  final ClientConfig _config;

  SearchModule(this._httpClient, this._config);

  /// Full-text search
  Future<List<SearchResult>> search({
    required String query,
    List<String>? tables,
    List<String>? fields,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
    bool includeHighlights = true,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/search',
      data: {
        'query': query,
        'tables': tables,
        'fields': fields,
        'filters': filters,
        'limit': limit,
        'offset': offset,
        'includeHighlights': includeHighlights,
      },
    );

    return (response['results'] as List)
        .map((item) => SearchResult.fromJson(item))
        .toList();
  }

  /// Vector search
  Future<List<VectorSearchResult>> vectorSearch({
    required List<double> vector,
    required String collection,
    int limit = 10,
    double? threshold,
    Map<String, dynamic>? filter,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/search/vector',
      data: {
        'vector': vector,
        'collection': collection,
        'limit': limit,
        'threshold': threshold,
        'filter': filter,
      },
    );

    return (response['results'] as List)
        .map((item) => VectorSearchResult.fromJson(item))
        .toList();
  }

  /// Search by embedding
  Future<List<VectorSearchResult>> searchByEmbedding({
    required String text,
    required String collection,
    String? model,
    int limit = 10,
    double? threshold,
    Map<String, dynamic>? filter,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/search/embedding',
      data: {
        'text': text,
        'collection': collection,
        'model': model,
        'limit': limit,
        'threshold': threshold,
        'filter': filter,
      },
    );

    return (response['results'] as List)
        .map((item) => VectorSearchResult.fromJson(item))
        .toList();
  }

  /// Index a document
  Future<void> indexDocument({
    required String table,
    required String id,
    required Map<String, dynamic> document,
    List<String>? fields,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/search/index',
      data: {
        'table': table,
        'id': id,
        'document': document,
        'fields': fields,
      },
    );
  }

  /// Index multiple documents
  Future<int> indexDocuments({
    required String table,
    required List<Map<String, dynamic>> documents,
    List<String>? fields,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/search/index/bulk',
      data: {
        'table': table,
        'documents': documents,
        'fields': fields,
      },
    );

    return response['indexed'] as int;
  }

  /// Store vector
  Future<void> storeVector({
    required String collection,
    required String id,
    required List<double> vector,
    Map<String, dynamic>? payload,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/search/vector/store',
      data: {
        'collection': collection,
        'id': id,
        'vector': vector,
        'payload': payload,
      },
    );
  }

  /// Store multiple vectors
  Future<int> storeVectors({
    required String collection,
    required List<Map<String, dynamic>> vectors,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/search/vector/store/bulk',
      data: {
        'collection': collection,
        'vectors': vectors,
      },
    );

    return response['stored'] as int;
  }

  /// Delete from index
  Future<void> deleteFromIndex({
    required String table,
    required String id,
  }) async {
    await _httpClient.delete<Map<String, dynamic>>(
      '/search/index/$table/$id',
    );
  }

  /// Delete vector
  Future<void> deleteVector({
    required String collection,
    required String id,
  }) async {
    await _httpClient.delete<Map<String, dynamic>>(
      '/search/vector/$collection/$id',
    );
  }

  /// Get search suggestions
  Future<List<String>> getSuggestions({
    required String query,
    List<String>? tables,
    List<String>? fields,
    int limit = 10,
  }) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/search/suggestions',
      params: {
        'query': query,
        'tables': tables,
        'fields': fields,
        'limit': limit,
      },
    );

    return (response['suggestions'] as List).cast<String>();
  }
}
