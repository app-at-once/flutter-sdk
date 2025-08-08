import 'dart:async';
import '../utils/http_client.dart';

/// Database column definition
class ColumnDefinition {
  final String name;
  final String type;
  final bool nullable;
  final dynamic defaultValue;
  final bool primaryKey;
  final bool unique;
  final String? references;
  final Map<String, dynamic>? constraints;

  const ColumnDefinition({
    required this.name,
    required this.type,
    this.nullable = true,
    this.defaultValue,
    this.primaryKey = false,
    this.unique = false,
    this.references,
    this.constraints,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'nullable': nullable,
        'default_value': defaultValue,
        'primary_key': primaryKey,
        'unique': unique,
        'references': references,
        'constraints': constraints,
      };

  factory ColumnDefinition.fromJson(Map<String, dynamic> json) =>
      ColumnDefinition(
        name: json['name'] as String,
        type: json['type'] as String,
        nullable: json['nullable'] as bool? ?? true,
        defaultValue: json['default_value'],
        primaryKey: json['primary_key'] as bool? ?? false,
        unique: json['unique'] as bool? ?? false,
        references: json['references'] as String?,
        constraints: json['constraints'] as Map<String, dynamic>?,
      );
}

/// Database index definition
class IndexDefinition {
  final String name;
  final List<String> columns;
  final bool unique;
  final String? type;
  final Map<String, dynamic>? options;

  const IndexDefinition({
    required this.name,
    required this.columns,
    this.unique = false,
    this.type,
    this.options,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'columns': columns,
        'unique': unique,
        'type': type,
        'options': options,
      };

  factory IndexDefinition.fromJson(Map<String, dynamic> json) =>
      IndexDefinition(
        name: json['name'] as String,
        columns: (json['columns'] as List<dynamic>).cast<String>(),
        unique: json['unique'] as bool? ?? false,
        type: json['type'] as String?,
        options: json['options'] as Map<String, dynamic>?,
      );
}

/// Table schema definition
class TableSchema {
  final String name;
  final List<ColumnDefinition> columns;
  final List<IndexDefinition> indexes;
  final List<String> primaryKey;
  final Map<String, dynamic>? options;

  const TableSchema({
    required this.name,
    required this.columns,
    this.indexes = const [],
    this.primaryKey = const [],
    this.options,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'columns': columns.map((c) => c.toJson()).toList(),
        'indexes': indexes.map((i) => i.toJson()).toList(),
        'primary_key': primaryKey,
        'options': options,
      };

  factory TableSchema.fromJson(Map<String, dynamic> json) => TableSchema(
        name: json['name'] as String,
        columns: (json['columns'] as List<dynamic>)
            .map((c) => ColumnDefinition.fromJson(c))
            .toList(),
        indexes: (json['indexes'] as List<dynamic>? ?? [])
            .map((i) => IndexDefinition.fromJson(i))
            .toList(),
        primaryKey:
            (json['primary_key'] as List<dynamic>? ?? []).cast<String>(),
        options: json['options'] as Map<String, dynamic>?,
      );
}

/// Database migration definition
class MigrationDefinition {
  final String name;
  final String version;
  final List<Map<String, dynamic>> operations;
  final Map<String, dynamic>? rollback;

  const MigrationDefinition({
    required this.name,
    required this.version,
    required this.operations,
    this.rollback,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'version': version,
        'operations': operations,
        'rollback': rollback,
      };

  factory MigrationDefinition.fromJson(Map<String, dynamic> json) =>
      MigrationDefinition(
        name: json['name'] as String,
        version: json['version'] as String,
        operations:
            (json['operations'] as List<dynamic>).cast<Map<String, dynamic>>(),
        rollback: json['rollback'] as Map<String, dynamic>?,
      );
}

/// Schema validation result
class ValidationResult {
  final bool valid;
  final List<String> errors;
  final List<String> warnings;

  const ValidationResult({
    required this.valid,
    required this.errors,
    required this.warnings,
  });

  factory ValidationResult.fromJson(Map<String, dynamic> json) =>
      ValidationResult(
        valid: json['valid'] as bool,
        errors: (json['errors'] as List<dynamic>? ?? []).cast<String>(),
        warnings: (json['warnings'] as List<dynamic>? ?? []).cast<String>(),
      );
}

/// Database schema information
class DatabaseInfo {
  final String name;
  final String version;
  final List<String> tables;
  final Map<String, dynamic> metadata;

  const DatabaseInfo({
    required this.name,
    required this.version,
    required this.tables,
    required this.metadata,
  });

  factory DatabaseInfo.fromJson(Map<String, dynamic> json) => DatabaseInfo(
        name: json['name'] as String,
        version: json['version'] as String,
        tables: (json['tables'] as List<dynamic>).cast<String>(),
        metadata: json['metadata'] as Map<String, dynamic>,
      );
}

/// Table information
class TableInfo {
  final String name;
  final int rowCount;
  final int columnCount;
  final int sizeBytes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TableInfo({
    required this.name,
    required this.rowCount,
    required this.columnCount,
    required this.sizeBytes,
    required this.createdAt,
    this.updatedAt,
  });

  factory TableInfo.fromJson(Map<String, dynamic> json) => TableInfo(
        name: json['name'] as String,
        rowCount: json['row_count'] as int,
        columnCount: json['column_count'] as int,
        sizeBytes: json['size_bytes'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );
}

/// Schema module for database schema management
class SchemaModule {
  final HttpClient _httpClient;

  SchemaModule(this._httpClient);

  /// Get database information
  Future<DatabaseInfo> getDatabaseInfo() async {
    final response =
        await _httpClient.get<Map<String, dynamic>>('/schema/database');
    return DatabaseInfo.fromJson(response);
  }

  /// List all tables
  Future<List<String>> listTables() async {
    final response = await _httpClient.get<List<dynamic>>('/schema/tables');
    return response.cast<String>();
  }

  /// Get table schema
  Future<TableSchema> getTableSchema(String tableName) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/schema/tables/$tableName',
    );
    return TableSchema.fromJson(response);
  }

  /// Get table information
  Future<TableInfo> getTableInfo(String tableName) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/schema/tables/$tableName/info',
    );
    return TableInfo.fromJson(response);
  }

  /// Create a new table
  Future<void> createTable(TableSchema schema) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/schema/tables',
      data: schema.toJson(),
    );
  }

  /// Drop a table
  Future<void> dropTable(String tableName, {bool cascade = false}) async {
    await _httpClient.delete(
      '/schema/tables/$tableName',
      params: {'cascade': cascade.toString()},
    );
  }

  /// Rename a table
  Future<void> renameTable(String oldName, String newName) async {
    await _httpClient.patch<Map<String, dynamic>>(
      '/schema/tables/$oldName',
      data: {'new_name': newName},
    );
  }

  /// Add a column to a table
  Future<void> addColumn(String tableName, ColumnDefinition column) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/schema/tables/$tableName/columns',
      data: column.toJson(),
    );
  }

  /// Drop a column from a table
  Future<void> dropColumn(String tableName, String columnName,
      {bool cascade = false}) async {
    await _httpClient.delete(
      '/schema/tables/$tableName/columns/$columnName',
      params: {'cascade': cascade.toString()},
    );
  }

  /// Modify a column
  Future<void> modifyColumn(String tableName, ColumnDefinition column) async {
    await _httpClient.patch<Map<String, dynamic>>(
      '/schema/tables/$tableName/columns/${column.name}',
      data: column.toJson(),
    );
  }

  /// Rename a column
  Future<void> renameColumn(
      String tableName, String oldName, String newName) async {
    await _httpClient.patch<Map<String, dynamic>>(
      '/schema/tables/$tableName/columns/$oldName',
      data: {'new_name': newName},
    );
  }

  /// Create an index
  Future<void> createIndex(String tableName, IndexDefinition index) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/schema/tables/$tableName/indexes',
      data: index.toJson(),
    );
  }

  /// Drop an index
  Future<void> dropIndex(String tableName, String indexName) async {
    await _httpClient.delete('/schema/tables/$tableName/indexes/$indexName');
  }

  /// List table indexes
  Future<List<IndexDefinition>> listIndexes(String tableName) async {
    final response = await _httpClient.get<List<dynamic>>(
      '/schema/tables/$tableName/indexes',
    );
    return response.map((i) => IndexDefinition.fromJson(i)).toList();
  }

  /// Validate table schema
  Future<ValidationResult> validateTableSchema(TableSchema schema) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/schema/validate/table',
      data: schema.toJson(),
    );
    return ValidationResult.fromJson(response);
  }

  /// Validate column definition
  Future<ValidationResult> validateColumn(ColumnDefinition column) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/schema/validate/column',
      data: column.toJson(),
    );
    return ValidationResult.fromJson(response);
  }

  /// Create a migration
  Future<Map<String, dynamic>> createMigration(
      MigrationDefinition migration) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/schema/migrations',
      data: migration.toJson(),
    );
    return response;
  }

  /// Apply pending migrations
  Future<List<Map<String, dynamic>>> applyMigrations() async {
    final response =
        await _httpClient.post<List<dynamic>>('/schema/migrations/apply');
    return response.cast<Map<String, dynamic>>();
  }

  /// Rollback migrations
  Future<List<Map<String, dynamic>>> rollbackMigrations({
    int? steps,
    String? toVersion,
  }) async {
    final data = <String, dynamic>{};
    if (steps != null) data['steps'] = steps;
    if (toVersion != null) data['to_version'] = toVersion;

    final response = await _httpClient.post<List<dynamic>>(
      '/schema/migrations/rollback',
      data: data,
    );
    return response.cast<Map<String, dynamic>>();
  }

  /// List migrations
  Future<List<Map<String, dynamic>>> listMigrations() async {
    final response = await _httpClient.get<List<dynamic>>('/schema/migrations');
    return response.cast<Map<String, dynamic>>();
  }

  /// Get migration status
  Future<Map<String, dynamic>> getMigrationStatus() async {
    final response = await _httpClient
        .get<Map<String, dynamic>>('/schema/migrations/status');
    return response;
  }

  /// Generate migration from schema diff
  Future<MigrationDefinition> generateMigration(
    String name,
    TableSchema from,
    TableSchema to,
  ) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/schema/migrations/generate',
      data: {
        'name': name,
        'from': from.toJson(),
        'to': to.toJson(),
      },
    );
    return MigrationDefinition.fromJson(response);
  }

  /// Backup database schema
  Future<Map<String, dynamic>> backupSchema() async {
    final response =
        await _httpClient.post<Map<String, dynamic>>('/schema/backup');
    return response;
  }

  /// Restore database schema
  Future<void> restoreSchema(Map<String, dynamic> backup) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/schema/restore',
      data: backup,
    );
  }

  /// Compare schemas
  Future<Map<String, dynamic>> compareSchemas(
    Map<String, dynamic> schema1,
    Map<String, dynamic> schema2,
  ) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/schema/compare',
      data: {
        'schema1': schema1,
        'schema2': schema2,
      },
    );
    return response;
  }

  /// Get schema diff
  Future<List<Map<String, dynamic>>> getSchemaDiff(
    String tableName,
    TableSchema target,
  ) async {
    final response = await _httpClient.post<List<dynamic>>(
      '/schema/diff/$tableName',
      data: target.toJson(),
    );
    return response.cast<Map<String, dynamic>>();
  }

  /// Analyze table performance
  Future<Map<String, dynamic>> analyzeTable(String tableName) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/schema/tables/$tableName/analyze',
    );
    return response;
  }

  /// Get table statistics
  Future<Map<String, dynamic>> getTableStatistics(String tableName) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/schema/tables/$tableName/statistics',
    );
    return response;
  }

  /// Optimize table
  Future<Map<String, dynamic>> optimizeTable(String tableName) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/schema/tables/$tableName/optimize',
    );
    return response;
  }

  /// Check table health
  Future<Map<String, dynamic>> checkTableHealth(String tableName) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/schema/tables/$tableName/health',
    );
    return response;
  }

  /// Get foreign key relationships
  Future<List<Map<String, dynamic>>> getForeignKeys(String tableName) async {
    final response = await _httpClient.get<List<dynamic>>(
      '/schema/tables/$tableName/foreign-keys',
    );
    return response.cast<Map<String, dynamic>>();
  }

  /// Create foreign key constraint
  Future<void> createForeignKey(
    String tableName,
    String columnName,
    String referencedTable,
    String referencedColumn, {
    String? onDelete,
    String? onUpdate,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/schema/tables/$tableName/foreign-keys',
      data: {
        'column': columnName,
        'referenced_table': referencedTable,
        'referenced_column': referencedColumn,
        'on_delete': onDelete,
        'on_update': onUpdate,
      },
    );
  }

  /// Drop foreign key constraint
  Future<void> dropForeignKey(String tableName, String constraintName) async {
    await _httpClient
        .delete('/schema/tables/$tableName/foreign-keys/$constraintName');
  }
}
