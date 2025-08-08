import 'dart:async';
import '../utils/http_client.dart';

/// Logic definition for server-side logic execution
class LogicDefinition {
  final String code;
  final Map<String, dynamic>? runtime;
  final Map<String, String>? environment;
  final List<String>? dependencies;
  final Map<String, dynamic>? config;

  const LogicDefinition({
    required this.code,
    this.runtime,
    this.environment,
    this.dependencies,
    this.config,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'runtime': runtime,
        'environment': environment,
        'dependencies': dependencies,
        'config': config,
      };

  factory LogicDefinition.fromJson(Map<String, dynamic> json) =>
      LogicDefinition(
        code: json['code'] as String,
        runtime: json['runtime'] as Map<String, dynamic>?,
        environment: (json['environment'] as Map<String, dynamic>?)
            ?.cast<String, String>(),
        dependencies: (json['dependencies'] as List<dynamic>?)?.cast<String>(),
        config: json['config'] as Map<String, dynamic>?,
      );
}

/// Options for logic execution
class LogicExecutionOptions {
  final int? timeout;
  final bool debug;
  final Map<String, dynamic>? context;
  final String? version;
  final bool async;

  const LogicExecutionOptions({
    this.timeout,
    this.debug = false,
    this.context,
    this.version,
    this.async = false,
  });

  Map<String, dynamic> toJson() => {
        'timeout': timeout,
        'debug': debug,
        'context': context,
        'version': version,
        'async': async,
      };
}

/// Result of logic execution
class LogicExecutionResult {
  final dynamic output;
  final bool success;
  final String? error;
  final int? duration;
  final Map<String, dynamic>? logs;
  final Map<String, dynamic>? metadata;

  const LogicExecutionResult({
    required this.output,
    required this.success,
    this.error,
    this.duration,
    this.logs,
    this.metadata,
  });

  factory LogicExecutionResult.fromJson(Map<String, dynamic> json) =>
      LogicExecutionResult(
        output: json['output'],
        success: json['success'] as bool,
        error: json['error'] as String?,
        duration: json['duration'] as int?,
        logs: json['logs'] as Map<String, dynamic>?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
}

/// Logic execution status for async operations
class LogicExecutionStatus {
  final String id;
  final String status;
  final dynamic result;
  final String? error;
  final int? duration;
  final DateTime createdAt;
  final DateTime? completedAt;

  const LogicExecutionStatus({
    required this.id,
    required this.status,
    this.result,
    this.error,
    this.duration,
    required this.createdAt,
    this.completedAt,
  });

  factory LogicExecutionStatus.fromJson(Map<String, dynamic> json) =>
      LogicExecutionStatus(
        id: json['id'] as String,
        status: json['status'] as String,
        result: json['result'],
        error: json['error'] as String?,
        duration: json['duration'] as int?,
        createdAt: DateTime.parse(json['created_at'] as String),
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'] as String)
            : null,
      );
}

/// Logic information
class LogicInfo {
  final String id;
  final String name;
  final String version;
  final LogicDefinition definition;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LogicStats stats;

  const LogicInfo({
    required this.id,
    required this.name,
    required this.version,
    required this.definition,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  factory LogicInfo.fromJson(Map<String, dynamic> json) => LogicInfo(
        id: json['id'] as String,
        name: json['name'] as String,
        version: json['version'] as String,
        definition: LogicDefinition.fromJson(json['definition']),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        stats: LogicStats.fromJson(json['stats']),
      );
}

/// Logic statistics
class LogicStats {
  final int executions;
  final double successRate;
  final double avgDuration;

  const LogicStats({
    required this.executions,
    required this.successRate,
    required this.avgDuration,
  });

  factory LogicStats.fromJson(Map<String, dynamic> json) => LogicStats(
        executions: json['executions'] as int,
        successRate: (json['success_rate'] as num).toDouble(),
        avgDuration: (json['avg_duration'] as num).toDouble(),
      );
}

/// Logic module for server-side code execution
class LogicModule {
  final HttpClient _httpClient;

  LogicModule(this._httpClient);

  /// Publish a logic function
  Future<Map<String, dynamic>> publishLogic(
    String name,
    LogicDefinition definition, {
    String? version,
    String? description,
    String? environment,
    List<String>? permissions,
    Map<String, dynamic>? rateLimit,
    List<String>? tags,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/logic/publish',
      data: {
        'name': name,
        'definition': definition.toJson(),
        'version': version,
        'description': description,
        'environment': environment,
        'permissions': permissions,
        'rateLimit': rateLimit,
        'tags': tags,
      },
    );

    return response;
  }

  /// Execute a logic function
  Future<LogicExecutionResult> executeLogic(
    String name,
    Map<String, dynamic> input, [
    LogicExecutionOptions? options,
  ]) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/logic/execute/$name',
      data: {
        'input': input,
        ...?options?.toJson(),
      },
    );

    return LogicExecutionResult.fromJson(response);
  }

  /// Execute logic asynchronously
  Future<Map<String, dynamic>> executeLogicAsync(
    String name,
    Map<String, dynamic> input, [
    LogicExecutionOptions? options,
  ]) async {
    final execOptions = options ?? const LogicExecutionOptions();
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/logic/execute/$name',
      data: {
        'input': input,
        ...execOptions.toJson(),
        'async': true,
      },
    );

    return response;
  }

  /// Get execution status for async operations
  Future<LogicExecutionStatus> getExecutionStatus(String executionId) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/logic/executions/$executionId',
    );

    return LogicExecutionStatus.fromJson(response);
  }

  /// List all logic functions
  Future<List<Map<String, dynamic>>> listLogic() async {
    final response = await _httpClient.get<List<dynamic>>('/logic');
    return response.cast<Map<String, dynamic>>();
  }

  /// Get logic function details
  Future<LogicInfo> getLogic(String name) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/logic/$name',
    );

    return LogicInfo.fromJson(response);
  }

  /// Delete a logic function
  Future<void> deleteLogic(String name) async {
    await _httpClient.delete('/logic/$name');
  }

  /// Get logic versions
  Future<List<Map<String, dynamic>>> getLogicVersions(String name) async {
    final response = await _httpClient.get<List<dynamic>>(
      '/logic/$name/versions',
    );
    return response.cast<Map<String, dynamic>>();
  }

  /// Rollback to a specific version
  Future<void> rollbackLogic(String name, String version) async {
    await _httpClient.put<Map<String, dynamic>>(
      '/logic/$name/rollback',
      data: {'version': version},
    );
  }

  /// Set A/B testing splits
  Future<void> setLogicSplit(
    String name,
    Map<String, double> splits,
  ) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/logic/$name/split-test',
      data: {'splits': splits},
    );
  }

  /// Get current A/B testing configuration
  Future<Map<String, dynamic>> getLogicSplit(String name) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/logic/$name/split-test',
    );
    return response;
  }

  /// Stop A/B testing
  Future<void> stopLogicSplit(String name) async {
    await _httpClient.delete('/logic/$name/split-test');
  }

  /// Test logic function with debug information
  Future<LogicExecutionResult> testLogic(
    String name,
    Map<String, dynamic> input, {
    bool debug = true,
    int? timeout,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/logic/$name/test',
      data: {
        'input': input,
        'debug': debug,
        'timeout': timeout,
      },
    );

    return LogicExecutionResult.fromJson(response);
  }

  /// Validate logic definition
  Future<Map<String, dynamic>> validateLogic(
    LogicDefinition definition,
  ) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/logic/validate',
      data: {'definition': definition.toJson()},
    );

    return response;
  }

  /// Get logic statistics
  Future<Map<String, dynamic>> getLogicStats(
    String name, {
    DateTime? start,
    DateTime? end,
  }) async {
    final params = <String, dynamic>{};
    if (start != null) params['start_date'] = start.toIso8601String();
    if (end != null) params['end_date'] = end.toIso8601String();

    final response = await _httpClient.get<Map<String, dynamic>>(
      '/logic/$name/stats',
      params: params,
    );

    return response;
  }

  /// Get execution logs
  Future<Map<String, dynamic>> getExecutionLogs(
    String name, {
    int? limit,
    int? offset,
    String? status,
    DateTime? start,
    DateTime? end,
  }) async {
    final params = <String, dynamic>{};
    if (limit != null) params['limit'] = limit;
    if (offset != null) params['offset'] = offset;
    if (status != null) params['status'] = status;
    if (start != null) params['start_date'] = start.toIso8601String();
    if (end != null) params['end_date'] = end.toIso8601String();

    final response = await _httpClient.get<Map<String, dynamic>>(
      '/logic/$name/logs',
      params: params,
    );

    return response;
  }

  /// Get logic quota information
  Future<Map<String, dynamic>> getLogicQuota(String name) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/logic/$name/quota',
    );

    return response;
  }

  /// Update rate limiting
  Future<void> updateLogicRateLimit(
    String name,
    Map<String, dynamic> rateLimit,
  ) async {
    await _httpClient.put<Map<String, dynamic>>(
      '/logic/$name/rate-limit',
      data: rateLimit,
    );
  }

  /// Search logic functions
  Future<List<Map<String, dynamic>>> searchLogic(
    String query, {
    String? category,
    List<String>? tags,
    String? author,
  }) async {
    final response = await _httpClient.post<List<dynamic>>(
      '/logic/search',
      data: {
        'query': query,
        'filters': {
          'category': category,
          'tags': tags,
          'author': author,
        },
      },
    );

    return response.cast<Map<String, dynamic>>();
  }

  /// Get logic template
  Future<LogicDefinition> getLogicTemplate(String templateName) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/logic/templates/$templateName',
    );

    return LogicDefinition.fromJson(response);
  }

  /// List available templates
  Future<List<Map<String, dynamic>>> listLogicTemplates([
    String? category,
  ]) async {
    final params =
        category != null ? {'category': category} : <String, String>{};
    final response = await _httpClient.get<List<dynamic>>(
      '/logic/templates',
      params: params,
    );

    return response.cast<Map<String, dynamic>>();
  }

  /// Create webhook for logic events
  Future<Map<String, dynamic>> createLogicWebhook(
    String name,
    String webhookUrl, [
    List<String>? events,
  ]) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/logic/$name/webhooks',
      data: {
        'url': webhookUrl,
        'events': events ?? ['execution.completed', 'execution.failed'],
      },
    );

    return response;
  }

  /// List logic webhooks
  Future<List<Map<String, dynamic>>> listLogicWebhooks(String name) async {
    final response = await _httpClient.get<List<dynamic>>(
      '/logic/$name/webhooks',
    );

    return response.cast<Map<String, dynamic>>();
  }

  /// Delete a webhook
  Future<void> deleteLogicWebhook(String name, String webhookId) async {
    await _httpClient.delete('/logic/$name/webhooks/$webhookId');
  }

  /// Deploy logic to environment
  Future<Map<String, dynamic>> deployLogic(
    String name,
    String environment, {
    bool? autoPromote,
    String? healthCheck,
    bool? rollbackOnFailure,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/logic/$name/deploy',
      data: {
        'environment': environment,
        'auto_promote': autoPromote,
        'health_check': healthCheck,
        'rollback_on_failure': rollbackOnFailure,
      },
    );

    return response;
  }

  /// Get logic deployments
  Future<List<Map<String, dynamic>>> getLogicDeployments(String name) async {
    final response = await _httpClient.get<List<dynamic>>(
      '/logic/$name/deployments',
    );

    return response.cast<Map<String, dynamic>>();
  }

  /// Stream logic events (placeholder for WebSocket implementation)
  Stream<Map<String, dynamic>> subscribeToLogicEvents(String name) {
    // NOTE: To implement real-time logic events:
    // 1. Use the RealtimeModule to subscribe to a logic-specific channel
    // 2. Listen for 'logic_event' messages with logic_name matching the parameter
    // 3. Transform the events into the expected format
    // Example usage: client.realtime.subscribe('logic:$name', onMessage: ...)
    throw UnimplementedError(
        'Logic event subscriptions should be implemented using the RealtimeModule. '
        'Subscribe to channel "logic:$name" for real-time logic execution events.');
  }
}
