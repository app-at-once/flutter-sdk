import '../utils/http_client.dart';
import '../common/types.dart';

/// Triggers module for managing scheduled, webhook, and event-based triggers
class TriggersModule {
  final HttpClient _httpClient;

  TriggersModule(this._httpClient);

  /// Create a new trigger
  /// [trigger] - Trigger configuration
  /// Returns the created trigger
  Future<Trigger> createTrigger(CreateTriggerRequest trigger) async {
    final response =
        await _httpClient.post('/triggers', data: trigger.toJson());
    return Trigger.fromJson(response.data);
  }

  /// Update an existing trigger
  /// [triggerId] - ID of the trigger to update
  /// [updates] - Fields to update
  /// Returns the updated trigger
  Future<Trigger> updateTrigger(
    String triggerId,
    UpdateTriggerRequest updates,
  ) async {
    final response = await _httpClient.patch(
      '/triggers/$triggerId',
      data: updates.toJson(),
    );
    return Trigger.fromJson(response.data);
  }

  /// Get a trigger by ID
  /// [triggerId] - ID of the trigger
  /// Returns the trigger
  Future<Trigger> getTrigger(String triggerId) async {
    final response = await _httpClient.get('/triggers/$triggerId');
    return Trigger.fromJson(response.data);
  }

  /// List triggers with optional filters
  /// [options] - Filter options
  /// Returns paginated list of triggers
  Future<TriggerListResponse> listTriggers({
    TriggerType? type,
    TargetType? targetType,
    bool? isActive,
    int? limit,
    int? offset,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      if (type != null) 'type': type.value,
      if (targetType != null) 'targetType': targetType.value,
      if (isActive != null) 'isActive': isActive,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (search != null) 'search': search,
    };

    final response = await _httpClient.get(
      '/triggers',
      params: queryParams,
    );
    return TriggerListResponse.fromJson(response.data);
  }

  /// Delete a trigger
  /// [triggerId] - ID of the trigger to delete
  Future<void> deleteTrigger(String triggerId) async {
    await _httpClient.delete('/triggers/$triggerId');
  }

  /// Activate a trigger
  /// [triggerId] - ID of the trigger to activate
  /// Returns the activated trigger
  Future<Trigger> activateTrigger(String triggerId) async {
    final response = await _httpClient.post('/triggers/$triggerId/activate');
    return Trigger.fromJson(response.data);
  }

  /// Deactivate a trigger
  /// [triggerId] - ID of the trigger to deactivate
  /// Returns the deactivated trigger
  Future<Trigger> deactivateTrigger(String triggerId) async {
    final response = await _httpClient.post('/triggers/$triggerId/deactivate');
    return Trigger.fromJson(response.data);
  }

  /// Execute a trigger manually
  /// [triggerId] - ID of the trigger to execute
  /// [input] - Optional input data
  /// Returns the trigger execution
  Future<TriggerExecution> executeTrigger(String triggerId,
      {dynamic input}) async {
    final response = await _httpClient.post(
      '/triggers/$triggerId/execute',
      data: {'input': input},
    );
    return TriggerExecution.fromJson(response.data);
  }

  /// Get execution details
  /// [executionId] - ID of the execution
  /// Returns the execution details
  Future<TriggerExecution> getExecution(String executionId) async {
    final response = await _httpClient.get('/triggers/executions/$executionId');
    return TriggerExecution.fromJson(response.data);
  }

  /// List trigger executions
  /// [triggerId] - Optional trigger ID to filter by
  /// [options] - Filter options
  /// Returns paginated list of executions
  Future<TriggerExecutionListResponse> listExecutions({
    String? triggerId,
    TriggerExecutionStatus? status,
    int? limit,
    int? offset,
    DateTimeRange? timeRange,
  }) async {
    final queryParams = <String, dynamic>{
      if (status != null) 'status': status.value,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (timeRange != null) ...{
        'start_date': timeRange.start.toIso8601String(),
        'end_date': timeRange.end.toIso8601String(),
      },
    };

    final url = triggerId != null
        ? '/triggers/$triggerId/executions'
        : '/triggers/executions';

    final response = await _httpClient.get(url, params: queryParams);
    return TriggerExecutionListResponse.fromJson(response.data);
  }

  /// Get webhook URL for a trigger
  /// [triggerId] - ID of the webhook trigger
  /// Returns webhook configuration
  Future<WebhookConfig> getWebhookURL(String triggerId) async {
    final response = await _httpClient.get('/triggers/$triggerId/webhook');
    return WebhookConfig.fromJson(response.data);
  }

  /// Regenerate webhook secret
  /// [triggerId] - ID of the webhook trigger
  /// Returns new secret
  Future<WebhookSecret> regenerateWebhookSecret(String triggerId) async {
    final response =
        await _httpClient.post('/triggers/$triggerId/webhook/regenerate');
    return WebhookSecret.fromJson(response.data);
  }

  /// Subscribe to an event trigger
  /// [event] - Event configuration
  /// Returns the created trigger
  Future<Trigger> subscribeToEvent(EventSubscription event) async {
    final trigger = CreateTriggerRequest(
      name: '${event.source}.${event.eventType}',
      type: TriggerType.event,
      config: TriggerConfig(
        source: event.source,
        eventType: event.eventType,
        filters: event.filters,
      ),
      target: event.target,
      isActive: true,
    );

    return createTrigger(trigger);
  }

  /// Unsubscribe from an event trigger
  /// [triggerId] - ID of the trigger to unsubscribe
  Future<void> unsubscribeFromEvent(String triggerId) async {
    await deleteTrigger(triggerId);
  }

  /// Create a cron trigger
  /// [cron] - Cron configuration
  /// Returns the created trigger
  Future<Trigger> createCronTrigger(CronTriggerRequest cron) async {
    final trigger = CreateTriggerRequest(
      name: cron.name,
      type: TriggerType.cron,
      config: TriggerConfig(
        cron: cron.cronExpression,
        timezone: cron.timezone,
      ),
      target: cron.target,
      isActive: true,
      metadata: cron.metadata,
    );

    return createTrigger(trigger);
  }

  /// Update cron expression
  /// [triggerId] - ID of the cron trigger
  /// [cronExpression] - New cron expression
  /// [timezone] - Optional timezone
  /// Returns the updated trigger
  Future<Trigger> updateCronExpression(
    String triggerId,
    String cronExpression, {
    String? timezone,
  }) async {
    return updateTrigger(
      triggerId,
      UpdateTriggerRequest(
        config: TriggerConfig(
          cron: cronExpression,
          timezone: timezone,
        ),
      ),
    );
  }

  /// Get next run time for a cron trigger
  /// [triggerId] - ID of the cron trigger
  /// Returns next run time information
  Future<NextRunTime> getNextRunTime(String triggerId) async {
    final response = await _httpClient.get('/triggers/$triggerId/next-run');
    return NextRunTime.fromJson(response.data);
  }

  /// Get trigger statistics
  /// [triggerId] - ID of the trigger
  /// [timeRange] - Optional time range
  /// Returns trigger statistics
  Future<TriggerStats> getTriggerStats(
    String triggerId, {
    DateTimeRange? timeRange,
  }) async {
    final queryParams = <String, dynamic>{};
    if (timeRange != null) {
      queryParams['start_date'] = timeRange.start.toIso8601String();
      queryParams['end_date'] = timeRange.end.toIso8601String();
    }

    final response = await _httpClient.get(
      '/triggers/$triggerId/stats',
      params: queryParams,
    );
    return TriggerStats.fromJson(response.data);
  }

  /// Get trigger definitions (legacy)
  /// Returns empty list as smart triggers are deprecated
  Future<List<TriggerDefinition>> getDefinitions() async {
    return [];
  }

  /// Get trigger patterns (legacy)
  /// Returns empty list as smart triggers are deprecated
  Future<List<TriggerPattern>> getPatterns() async {
    return [];
  }

  /// Detect patterns (legacy)
  /// Returns empty list as smart triggers are deprecated
  Future<List<dynamic>> detectPatterns(
    String tableName,
    List<TableField> fields,
  ) async {
    return [];
  }

  /// Get table triggers
  /// [tableName] - Name of the table
  /// Returns triggers targeting the table
  Future<List<TableTrigger>> getTableTriggers(String tableName) async {
    final response = await listTriggers(targetType: TargetType.tool);

    // Filter for database-related triggers
    final tableTriggers = response.triggers.where(
      (trigger) => trigger.target.config?['table'] == tableName,
    );

    return tableTriggers
        .map((trigger) => TableTrigger(
              tableName: tableName,
              fieldName: trigger.target.config?['field'] ?? '',
              triggers: [
                TableTriggerInfo(
                  name: trigger.name,
                  type: trigger.type.value,
                  enabled: trigger.isActive,
                  config: trigger.config.toJson(),
                  lastProcessed: trigger.metadata?['lastProcessed'] != null
                      ? DateTime.parse(trigger.metadata!['lastProcessed'])
                      : null,
                  status: trigger.isActive ? 'active' : 'pending',
                ),
              ],
            ))
        .toList();
  }

  /// Process a trigger
  /// [request] - Trigger processing request
  /// Returns job information
  Future<TriggerJobResponse> processTrigger(
      TriggerProcessRequest request) async {
    // Find matching trigger
    final response = await listTriggers(targetType: TargetType.tool);

    final trigger = response.triggers
        .where((t) =>
            t.target.config?['table'] == request.tableName &&
            t.target.config?['field'] == request.fieldName &&
            t.type.value == request.triggerType)
        .firstOrNull;

    if (trigger?.id == null) {
      throw Exception(
        'No trigger found for ${request.tableName}.${request.fieldName} of type ${request.triggerType}',
      );
    }

    final execution = await executeTrigger(trigger!.id!, input: request.data);
    return TriggerJobResponse(
      jobId: execution.id,
      status: execution.status.value,
      message: 'Trigger execution started',
    );
  }

  /// Get job status
  /// [jobId] - ID of the job
  /// Returns job status
  Future<TriggerJobStatus> getJobStatus(String jobId) async {
    final execution = await getExecution(jobId);
    return TriggerJobStatus(
      jobId: execution.id,
      status: _mapExecutionStatus(execution.status),
      result: execution.output,
      error: execution.error,
      createdAt: execution.startedAt ?? DateTime.now(),
      completedAt: execution.completedAt,
    );
  }

  /// Wait for job completion
  /// [jobId] - ID of the job
  /// [options] - Wait options
  /// Returns final job status
  Future<TriggerJobStatus> waitForJob(
    String jobId, {
    Duration timeout = const Duration(minutes: 1),
    Duration pollInterval = const Duration(seconds: 1),
  }) async {
    final startTime = DateTime.now();

    while (DateTime.now().difference(startTime) < timeout) {
      final job = await getJobStatus(jobId);

      if (job.status == 'completed' || job.status == 'failed') {
        return job;
      }

      await Future.delayed(pollInterval);
    }

    throw Exception(
        'Trigger job $jobId timed out after ${timeout.inMilliseconds}ms');
  }

  String _mapExecutionStatus(TriggerExecutionStatus status) {
    switch (status) {
      case TriggerExecutionStatus.pending:
        return 'queued';
      case TriggerExecutionStatus.running:
        return 'active';
      case TriggerExecutionStatus.success:
        return 'completed';
      case TriggerExecutionStatus.failed:
        return 'failed';
    }
  }
}

// Supporting classes and enums

enum TriggerType {
  cron('cron'),
  webhook('webhook'),
  event('event');

  const TriggerType(this.value);
  final String value;

  static TriggerType fromString(String value) {
    return TriggerType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown trigger type: $value'),
    );
  }
}

enum TargetType {
  workflow('workflow'),
  logic('logic'),
  node('node'),
  tool('tool');

  const TargetType(this.value);
  final String value;

  static TargetType fromString(String value) {
    return TargetType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown target type: $value'),
    );
  }
}

enum TriggerExecutionStatus {
  pending('pending'),
  running('running'),
  success('success'),
  failed('failed');

  const TriggerExecutionStatus(this.value);
  final String value;

  static TriggerExecutionStatus fromString(String value) {
    return TriggerExecutionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown execution status: $value'),
    );
  }
}

class DateTimeRange {
  final DateTime start;
  final DateTime end;

  const DateTimeRange({required this.start, required this.end});
}

// Request/Response classes - these would typically be in a separate types file

class CreateTriggerRequest {
  final String name;
  final String? description;
  final TriggerType type;
  final TriggerConfig config;
  final TriggerTarget target;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  const CreateTriggerRequest({
    required this.name,
    this.description,
    required this.type,
    required this.config,
    required this.target,
    this.isActive = true,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'type': type.value,
        'config': config.toJson(),
        'target': target.toJson(),
        'isActive': isActive,
        if (metadata != null) 'metadata': metadata,
      };
}

class UpdateTriggerRequest {
  final String? name;
  final String? description;
  final TriggerConfig? config;
  final TriggerTarget? target;
  final bool? isActive;
  final Map<String, dynamic>? metadata;

  const UpdateTriggerRequest({
    this.name,
    this.description,
    this.config,
    this.target,
    this.isActive,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (config != null) 'config': config!.toJson(),
        if (target != null) 'target': target!.toJson(),
        if (isActive != null) 'isActive': isActive,
        if (metadata != null) 'metadata': metadata,
      };
}

class TriggerListResponse {
  final List<Trigger> triggers;
  final int total;

  const TriggerListResponse({required this.triggers, required this.total});

  factory TriggerListResponse.fromJson(Map<String, dynamic> json) =>
      TriggerListResponse(
        triggers:
            (json['triggers'] as List).map((e) => Trigger.fromJson(e)).toList(),
        total: json['total'],
      );
}

class TriggerExecutionListResponse {
  final List<TriggerExecution> executions;
  final int total;

  const TriggerExecutionListResponse(
      {required this.executions, required this.total});

  factory TriggerExecutionListResponse.fromJson(Map<String, dynamic> json) =>
      TriggerExecutionListResponse(
        executions: (json['executions'] as List)
            .map((e) => TriggerExecution.fromJson(e))
            .toList(),
        total: json['total'],
      );
}

class WebhookConfig {
  final String url;
  final String method;
  final Map<String, String>? headers;

  const WebhookConfig({
    required this.url,
    required this.method,
    this.headers,
  });

  factory WebhookConfig.fromJson(Map<String, dynamic> json) => WebhookConfig(
        url: json['url'],
        method: json['method'],
        headers: (json['headers'] as Map?)?.cast<String, String>(),
      );
}

class WebhookSecret {
  final String secret;

  const WebhookSecret({required this.secret});

  factory WebhookSecret.fromJson(Map<String, dynamic> json) =>
      WebhookSecret(secret: json['secret']);
}

class EventSubscription {
  final String source;
  final String eventType;
  final Map<String, dynamic>? filters;
  final TriggerTarget target;

  const EventSubscription({
    required this.source,
    required this.eventType,
    this.filters,
    required this.target,
  });
}

class CronTriggerRequest {
  final String name;
  final String cronExpression;
  final String? timezone;
  final TriggerTarget target;
  final Map<String, dynamic>? metadata;

  const CronTriggerRequest({
    required this.name,
    required this.cronExpression,
    this.timezone,
    required this.target,
    this.metadata,
  });
}

class NextRunTime {
  final String nextRun;
  final String timezone;

  const NextRunTime({required this.nextRun, required this.timezone});

  factory NextRunTime.fromJson(Map<String, dynamic> json) => NextRunTime(
        nextRun: json['nextRun'],
        timezone: json['timezone'],
      );
}

class TriggerStats {
  final int totalExecutions;
  final int successfulExecutions;
  final int failedExecutions;
  final double successRate;
  final double averageDuration;
  final String? lastExecution;
  final List<ExecutionsByDay> executionsByDay;

  const TriggerStats({
    required this.totalExecutions,
    required this.successfulExecutions,
    required this.failedExecutions,
    required this.successRate,
    required this.averageDuration,
    this.lastExecution,
    required this.executionsByDay,
  });

  factory TriggerStats.fromJson(Map<String, dynamic> json) => TriggerStats(
        totalExecutions: json['total_executions'],
        successfulExecutions: json['successful_executions'],
        failedExecutions: json['failed_executions'],
        successRate: json['success_rate'].toDouble(),
        averageDuration: json['average_duration'].toDouble(),
        lastExecution: json['last_execution'],
        executionsByDay: (json['executions_by_day'] as List)
            .map((e) => ExecutionsByDay.fromJson(e))
            .toList(),
      );
}

class ExecutionsByDay {
  final String date;
  final int count;
  final double successRate;

  const ExecutionsByDay({
    required this.date,
    required this.count,
    required this.successRate,
  });

  factory ExecutionsByDay.fromJson(Map<String, dynamic> json) =>
      ExecutionsByDay(
        date: json['date'],
        count: json['count'],
        successRate: json['success_rate'].toDouble(),
      );
}

class TriggerDefinition {
  final String name;
  final String type;
  final String description;
  final List<String>? requiredFieldTypes;
  final List<String>? optionalFieldTypes;
  final Map<String, dynamic>? defaultConfig;
  final List<String>? features;

  const TriggerDefinition({
    required this.name,
    required this.type,
    required this.description,
    this.requiredFieldTypes,
    this.optionalFieldTypes,
    this.defaultConfig,
    this.features,
  });
}

class TriggerPattern {
  final String pattern;
  final String description;
  final List<String> fieldTypes;
  final List<String> triggers;
  final double confidence;

  const TriggerPattern({
    required this.pattern,
    required this.description,
    required this.fieldTypes,
    required this.triggers,
    required this.confidence,
  });
}

class TableTrigger {
  final String tableName;
  final String fieldName;
  final List<TableTriggerInfo> triggers;

  const TableTrigger({
    required this.tableName,
    required this.fieldName,
    required this.triggers,
  });
}

class TableTriggerInfo {
  final String name;
  final String type;
  final bool enabled;
  final Map<String, dynamic>? config;
  final DateTime? lastProcessed;
  final String status;

  const TableTriggerInfo({
    required this.name,
    required this.type,
    required this.enabled,
    this.config,
    this.lastProcessed,
    required this.status,
  });
}

class TriggerProcessRequest {
  final String tableName;
  final String fieldName;
  final String recordId;
  final String triggerType;
  final dynamic data;

  const TriggerProcessRequest({
    required this.tableName,
    required this.fieldName,
    required this.recordId,
    required this.triggerType,
    this.data,
  });
}

class TriggerJobResponse {
  final String jobId;
  final String status;
  final String message;

  const TriggerJobResponse({
    required this.jobId,
    required this.status,
    required this.message,
  });
}

class TriggerJobStatus {
  final String jobId;
  final String status;
  final int? progress;
  final dynamic result;
  final String? error;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TriggerJobStatus({
    required this.jobId,
    required this.status,
    this.progress,
    this.result,
    this.error,
    required this.createdAt,
    this.completedAt,
  });
}

// Core classes

class Trigger {
  final String id;
  final String name;
  final String? description;
  final TriggerType type;
  final TriggerConfig config;
  final TriggerTarget target;
  final bool isActive;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Trigger({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.config,
    required this.target,
    required this.isActive,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trigger.fromJson(Map<String, dynamic> json) => Trigger(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        type: TriggerType.fromString(json['type']),
        config: TriggerConfig.fromJson(json['config']),
        target: TriggerTarget.fromJson(json['target']),
        isActive: json['isActive'] ?? true,
        metadata: json['metadata'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'type': type.value,
        'config': config.toJson(),
        'target': target.toJson(),
        'isActive': isActive,
        if (metadata != null) 'metadata': metadata,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class TriggerConfig {
  final String? cron;
  final String? timezone;
  final String? url;
  final String? method;
  final Map<String, String>? headers;
  final String? source;
  final String? eventType;
  final Map<String, dynamic>? filters;

  const TriggerConfig({
    this.cron,
    this.timezone,
    this.url,
    this.method,
    this.headers,
    this.source,
    this.eventType,
    this.filters,
  });

  factory TriggerConfig.fromJson(Map<String, dynamic> json) => TriggerConfig(
        cron: json['cron'],
        timezone: json['timezone'],
        url: json['url'],
        method: json['method'],
        headers: (json['headers'] as Map?)?.cast<String, String>(),
        source: json['source'],
        eventType: json['eventType'],
        filters: json['filters'],
      );

  Map<String, dynamic> toJson() => {
        if (cron != null) 'cron': cron,
        if (timezone != null) 'timezone': timezone,
        if (url != null) 'url': url,
        if (method != null) 'method': method,
        if (headers != null) 'headers': headers,
        if (source != null) 'source': source,
        if (eventType != null) 'eventType': eventType,
        if (filters != null) 'filters': filters,
      };
}

class TriggerTarget {
  final TargetType type;
  final String id;
  final Map<String, dynamic>? config;

  const TriggerTarget({
    required this.type,
    required this.id,
    this.config,
  });

  factory TriggerTarget.fromJson(Map<String, dynamic> json) => TriggerTarget(
        type: TargetType.fromString(json['type']),
        id: json['id'],
        config: json['config'],
      );

  Map<String, dynamic> toJson() => {
        'type': type.value,
        'id': id,
        if (config != null) 'config': config,
      };
}

class TriggerExecution {
  final String id;
  final String triggerId;
  final TriggerExecutionStatus status;
  final Map<String, dynamic>? input;
  final Map<String, dynamic>? output;
  final String? error;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const TriggerExecution({
    required this.id,
    required this.triggerId,
    required this.status,
    this.input,
    this.output,
    this.error,
    this.startedAt,
    this.completedAt,
  });

  factory TriggerExecution.fromJson(Map<String, dynamic> json) =>
      TriggerExecution(
        id: json['id'],
        triggerId: json['triggerId'],
        status: TriggerExecutionStatus.fromString(json['status']),
        input: json['input'],
        output: json['output'],
        error: json['error'],
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'])
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
      );
}

class TableField {
  final String name;
  final String type;

  const TableField({required this.name, required this.type});
}

// Helper extension
extension<T> on Iterable<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}
