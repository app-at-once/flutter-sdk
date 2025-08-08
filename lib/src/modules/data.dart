import 'dart:async';
import '../common/types.dart';
import '../utils/http_client.dart';

/// Query filter for where conditions
class QueryFilter {
  final String field;
  final String operator;
  final dynamic value;

  const QueryFilter({
    required this.field,
    required this.operator,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'field': field,
        'operator': operator,
        'value': value,
      };
}

/// Join clause for query joins
class JoinClause {
  final String type;
  final String table;
  final String on;

  const JoinClause({
    required this.type,
    required this.table,
    required this.on,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'table': table,
        'on': on,
      };
}

/// Query result wrapper
class QueryResult<T> {
  final List<T> data;
  final int? count;

  const QueryResult({
    required this.data,
    this.count,
  });
}

/// Comprehensive query builder for data operations
class QueryBuilder<T> {
  final HttpClient _httpClient;
  final String _tableName;
  List<String> _selectFields = ['*'];
  List<QueryFilter> _whereFilters = [];
  List<Map<String, String>> _orderByFields = [];
  List<JoinClause> _joinClauses = [];
  int? _limitValue;
  int? _offsetValue;
  List<String> _groupByFields = [];
  List<QueryFilter> _havingFilters = [];

  QueryBuilder(this._httpClient, this._tableName);

  // SELECT methods
  QueryBuilder<T> select(List<String> fields) {
    _selectFields = fields.isNotEmpty ? fields : ['*'];
    return this;
  }

  // WHERE methods with fluent API
  QueryBuilder<T> where(String field, String operator, dynamic value) {
    _whereFilters
        .add(QueryFilter(field: field, operator: operator, value: value));
    return this;
  }

  QueryBuilder<T> eq(String field, dynamic value) {
    return where(field, 'eq', value);
  }

  QueryBuilder<T> ne(String field, dynamic value) {
    return where(field, 'ne', value);
  }

  QueryBuilder<T> gt(String field, dynamic value) {
    return where(field, 'gt', value);
  }

  QueryBuilder<T> gte(String field, dynamic value) {
    return where(field, 'gte', value);
  }

  QueryBuilder<T> lt(String field, dynamic value) {
    return where(field, 'lt', value);
  }

  QueryBuilder<T> lte(String field, dynamic value) {
    return where(field, 'lte', value);
  }

  QueryBuilder<T> like(String field, String value) {
    return where(field, 'like', value);
  }

  QueryBuilder<T> ilike(String field, String value) {
    return where(field, 'ilike', value);
  }

  QueryBuilder<T> whereIn(String field, List<dynamic> values) {
    return where(field, 'in', values);
  }

  QueryBuilder<T> notIn(String field, List<dynamic> values) {
    return where(field, 'nin', values);
  }

  QueryBuilder<T> isNull(String field) {
    return where(field, 'is', null);
  }

  QueryBuilder<T> isNotNull(String field) {
    return where(field, 'not', null);
  }

  QueryBuilder<T> between(String field, dynamic min, dynamic max) {
    return gte(field, min).lte(field, max);
  }

  QueryBuilder<T> notBetween(String field, dynamic min, dynamic max) {
    return lt(field, min).gt(field, max);
  }

  // ORDER BY methods
  QueryBuilder<T> orderBy(String field, [String direction = 'asc']) {
    _orderByFields.add({'field': field, 'direction': direction});
    return this;
  }

  // JOIN methods
  QueryBuilder<T> join(String table, String on, [String type = 'inner']) {
    _joinClauses.add(JoinClause(type: type, table: table, on: on));
    return this;
  }

  QueryBuilder<T> leftJoin(String table, String on) {
    return join(table, on, 'left');
  }

  QueryBuilder<T> rightJoin(String table, String on) {
    return join(table, on, 'right');
  }

  QueryBuilder<T> innerJoin(String table, String on) {
    return join(table, on, 'inner');
  }

  QueryBuilder<T> fullJoin(String table, String on) {
    return join(table, on, 'full');
  }

  // LIMIT and OFFSET
  QueryBuilder<T> limit(int count) {
    _limitValue = count;
    return this;
  }

  QueryBuilder<T> offset(int count) {
    _offsetValue = count;
    return this;
  }

  // GROUP BY and HAVING
  QueryBuilder<T> groupBy(List<String> fields) {
    _groupByFields = fields;
    return this;
  }

  QueryBuilder<T> having(String field, String operator, dynamic value) {
    _havingFilters
        .add(QueryFilter(field: field, operator: operator, value: value));
    return this;
  }

  // PAGINATION
  QueryBuilder<T> paginate(int page, [int pageSize = 10]) {
    _limitValue = pageSize;
    _offsetValue = (page - 1) * pageSize;
    return this;
  }

  // EXECUTE methods
  Future<QueryResult<T>> execute() async {
    final params = _buildQueryParams();
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/data/$_tableName',
      params: params,
    );

    return QueryResult<T>(
      data: (response['data'] as List?)?.cast<T>() ?? [],
      count: response['meta']?['total'],
    );
  }

  Future<T?> first() async {
    final result = await limit(1).execute();
    return result.data.isNotEmpty ? result.data.first : null;
  }

  Future<int> count() async {
    final params = _buildQueryParams();
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/data/$_tableName/count',
      params: params,
    );
    return response['count'] ?? 0;
  }

  Future<bool> exists() async {
    final count = await this.count();
    return count > 0;
  }

  // MUTATION methods
  Future<T> insert(Map<String, dynamic> data) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName',
      data: data,
    );
    return response['data'] as T;
  }

  Future<List<T>> insertMany(List<Map<String, dynamic>> data) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/bulk',
      data: {'data': data},
    );
    return (response['data'] as List).cast<T>();
  }

  Future<List<T>> update(Map<String, dynamic> data) async {
    // Check if we have a single ID filter
    final idFilter = _whereFilters
            .where((f) => f.field == 'id' && f.operator == 'eq')
            .isNotEmpty
        ? _whereFilters
            .where((f) => f.field == 'id' && f.operator == 'eq')
            .first
        : null;
    if (idFilter != null && _whereFilters.length == 1) {
      // Single record update
      final response = await _httpClient.patch<Map<String, dynamic>>(
        '/data/$_tableName/${idFilter.value}',
        data: data,
      );
      return [response['data'] as T];
    }

    // Batch update
    final response = await _httpClient.patch<Map<String, dynamic>>(
      '/data/$_tableName',
      data: {
        'data': data,
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );
    return (response['data'] as List).cast<T>();
  }

  Future<T> upsert(Map<String, dynamic> data,
      [List<String> conflictFields = const ['id']]) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/upsert',
      data: {
        'data': data,
        'conflictFields': conflictFields,
      },
    );
    return response['data'] as T;
  }

  Future<Map<String, int>> delete() async {
    // Check if we have a single ID filter
    final idFilter = _whereFilters
            .where((f) => f.field == 'id' && f.operator == 'eq')
            .isNotEmpty
        ? _whereFilters
            .where((f) => f.field == 'id' && f.operator == 'eq')
            .first
        : null;
    if (idFilter != null && _whereFilters.length == 1) {
      // Single record delete
      final response = await _httpClient.delete<Map<String, dynamic>>(
        '/data/$_tableName/${idFilter.value}',
      );
      return {'count': response['deleted'] == true ? 1 : 0};
    }

    // Batch delete
    final response = await _httpClient.delete<Map<String, dynamic>>(
      '/data/$_tableName',
      data: {
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );
    return {'count': response['count'] ?? 0};
  }

  // SEARCH methods
  Future<QueryResult<T>> search(
    String query, {
    List<String>? fields,
    bool highlight = false,
    int limit = 10,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/search',
      data: {
        'query': query,
        'fields': fields,
        'highlight': highlight,
        'limit': limit,
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );

    return QueryResult<T>(
      data: (response['data']?['results'] as List?)?.cast<T>() ?? [],
      count: response['data']?['total'],
    );
  }

  // ANALYTICS methods
  Future<List<Map<String, dynamic>>> analytics({
    required List<String> metrics,
    List<String>? dimensions,
    Map<String, DateTime>? timeRange,
    String? interval,
    bool realtime = false,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/analytics',
      data: {
        'metrics': metrics,
        'dimensions': dimensions,
        'timeRange': timeRange?.map((k, v) => MapEntry(k, v.toIso8601String())),
        'interval': interval,
        'realtime': realtime,
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );

    return (response['data']?['results'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
  }

  // AGGREGATION methods
  Future<Map<String, dynamic>> aggregate(List<String> functions) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/aggregate',
      data: {
        'functions': functions,
        'where': _whereFilters.map((f) => f.toJson()).toList(),
        'groupBy': _groupByFields,
        'having': _havingFilters.map((f) => f.toJson()).toList(),
      },
    );

    return response['data'] ?? {};
  }

  Future<double> sum(String field) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/aggregate',
      data: {
        'sum': [field],
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );
    return (response['data']?['sum_$field'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> avg(String field) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/aggregate',
      data: {
        'avg': [field],
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );
    return (response['data']?['avg_$field'] as num?)?.toDouble() ?? 0.0;
  }

  Future<T?> min(String field) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/aggregate',
      data: {
        'min': [field],
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );
    return response['data']?['min_$field'] as T?;
  }

  Future<T?> max(String field) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$_tableName/aggregate',
      data: {
        'max': [field],
        'where': _whereFilters.map((f) => f.toJson()).toList(),
      },
    );
    return response['data']?['max_$field'] as T?;
  }

  // UTILITY methods
  Map<String, dynamic> _buildQueryParams() {
    final params = <String, dynamic>{};

    if (_selectFields.isNotEmpty &&
        !(_selectFields.length == 1 && _selectFields.first == '*')) {
      params['select'] = _selectFields.join(',');
    }

    if (_whereFilters.isNotEmpty) {
      params['where'] = _whereFilters.map((f) => f.toJson()).toList();
    }

    if (_orderByFields.isNotEmpty) {
      params['orderBy'] = _orderByFields;
    }

    if (_limitValue != null) {
      params['limit'] = _limitValue;
    }

    if (_offsetValue != null) {
      params['offset'] = _offsetValue;
    }

    if (_joinClauses.isNotEmpty) {
      params['joins'] = _joinClauses.map((j) => j.toJson()).toList();
    }

    if (_groupByFields.isNotEmpty) {
      params['groupBy'] = _groupByFields.join(',');
    }

    if (_havingFilters.isNotEmpty) {
      params['having'] = _havingFilters.map((f) => f.toJson()).toList();
    }

    return params;
  }

  // Clone the query builder
  QueryBuilder<T> clone() {
    final cloned = QueryBuilder<T>(_httpClient, _tableName);
    cloned._selectFields = List.from(_selectFields);
    cloned._whereFilters = List.from(_whereFilters);
    cloned._orderByFields = List.from(_orderByFields);
    cloned._joinClauses = List.from(_joinClauses);
    cloned._limitValue = _limitValue;
    cloned._offsetValue = _offsetValue;
    cloned._groupByFields = List.from(_groupByFields);
    cloned._havingFilters = List.from(_havingFilters);
    return cloned;
  }
}

/// Data module for database operations
class DataModule {
  final HttpClient _httpClient;
  final ClientConfig _config;

  DataModule(this._httpClient, this._config);

  /// Create a query builder for a table
  QueryBuilder<T> table<T>(String tableName) {
    return QueryBuilder<T>(_httpClient, tableName);
  }

  /// Get a single record
  Future<T> get<T>(
    String table,
    String id, {
    List<String>? select,
    List<String>? include,
  }) async {
    final query = QueryBuilder<T>(_httpClient, table);

    if (select != null) {
      query.select(select);
    }

    final response = await _httpClient.get<Map<String, dynamic>>(
      '/data/$table/$id',
      params: query._buildQueryParams(),
    );

    return response['data'] as T;
  }

  /// Query records
  Future<List<T>> query<T>(
    String table, {
    QueryBuilder<T>? query,
  }) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/data/$table',
      params: query?._buildQueryParams() ?? {},
    );

    return (response['data'] as List).cast<T>();
  }

  /// Count records
  Future<int> count(
    String table, {
    QueryBuilder? query,
  }) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/data/$table/count',
      params: query?._buildQueryParams() ?? {},
    );

    return response['count'] as int;
  }

  /// Create a record
  Future<T> create<T>(
    String table,
    Map<String, dynamic> data, {
    List<String>? returning,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$table',
      data: data,
      params: returning != null ? {'returning': returning} : null,
    );

    return response['data'] as T;
  }

  /// Create multiple records
  Future<List<T>> createMany<T>(
    String table,
    List<Map<String, dynamic>> data, {
    List<String>? returning,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/$table/bulk',
      data: {'records': data},
      params: returning != null ? {'returning': returning} : null,
    );

    return (response['data'] as List).cast<T>();
  }

  /// Update a record
  Future<T> update<T>(
    String table,
    String id,
    Map<String, dynamic> data, {
    List<String>? returning,
  }) async {
    final response = await _httpClient.patch<Map<String, dynamic>>(
      '/data/$table/$id',
      data: data,
      params: returning != null ? {'returning': returning} : null,
    );

    return response['data'] as T;
  }

  /// Update multiple records
  Future<List<T>> updateMany<T>(
    String table,
    Map<String, dynamic> data, {
    QueryBuilder? where,
    List<String>? returning,
  }) async {
    final params = <String, dynamic>{};

    if (where != null) {
      params.addAll(where._buildQueryParams());
    }

    if (returning != null) {
      params['returning'] = returning;
    }

    final response = await _httpClient.patch<Map<String, dynamic>>(
      '/data/$table',
      data: data,
      params: params,
    );

    return (response['data'] as List).cast<T>();
  }

  /// Delete a record
  Future<void> delete(String table, String id) async {
    await _httpClient.delete<Map<String, dynamic>>(
      '/data/$table/$id',
    );
  }

  /// Delete multiple records
  Future<int> deleteMany(
    String table, {
    QueryBuilder? where,
  }) async {
    final response = await _httpClient.delete<Map<String, dynamic>>(
      '/data/$table',
      params: where?._buildQueryParams() ?? {},
    );

    return response['count'] as int;
  }

  /// Execute a raw query
  Future<List<Map<String, dynamic>>> rawQuery(
    String query, {
    Map<String, dynamic>? params,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/query',
      data: {
        'query': query,
        'params': params,
      },
    );

    return (response['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Execute a raw command
  Future<Map<String, dynamic>> rawCommand(
    String command, {
    Map<String, dynamic>? params,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/command',
      data: {
        'command': command,
        'params': params,
      },
    );

    return response['result'] as Map<String, dynamic>;
  }

  /// Subscribe to table changes
  Stream<Map<String, dynamic>> subscribe(
    String table, {
    QueryBuilder? where,
    List<String>? events = const ['INSERT', 'UPDATE', 'DELETE'],
  }) {
    // This would integrate with the realtime module
    // For now, return an empty stream
    return const Stream.empty();
  }

  /// Perform a transaction
  Future<T> transaction<T>(
    Future<T> Function(TransactionClient tx) callback,
  ) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/data/transaction',
      data: {
        // Transaction details would be handled server-side
      },
    );

    // In a real implementation, this would handle transaction logic
    final tx = TransactionClient(_httpClient, response['transactionId']);
    return callback(tx);
  }
}

/// Transaction client for database transactions
class TransactionClient {
  final HttpClient _httpClient;
  final String _transactionId;

  TransactionClient(this._httpClient, this._transactionId);

  // Transaction methods would be similar to DataModule methods
  // but scoped to the transaction
}
