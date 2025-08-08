import 'dart:async';
import '../common/types.dart';
import '../utils/http_client.dart';

/// Workflow execution result
class WorkflowResult {
  final String id;
  final String workflowId;
  final String status;
  final dynamic result;
  final Map<String, dynamic>? metadata;
  final DateTime startedAt;
  final DateTime? completedAt;

  WorkflowResult({
    required this.id,
    required this.workflowId,
    required this.status,
    this.result,
    this.metadata,
    required this.startedAt,
    this.completedAt,
  });

  factory WorkflowResult.fromJson(Map<String, dynamic> json) {
    return WorkflowResult(
      id: json['id'],
      workflowId: json['workflowId'],
      status: json['status'],
      result: json['result'],
      metadata: json['metadata'],
      startedAt: DateTime.parse(json['startedAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}

/// Workflows module for workflow execution
class WorkflowsModule {
  final HttpClient _httpClient;
  final ClientConfig _config;

  WorkflowsModule(this._httpClient, this._config);

  /// Execute a workflow
  Future<WorkflowResult> execute({
    required String workflowId,
    Map<String, dynamic>? input,
    Map<String, dynamic>? options,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/workflows/$workflowId/execute',
      data: {
        'input': input,
        'options': options,
      },
    );

    return WorkflowResult.fromJson(response['data']);
  }

  /// Execute a workflow by name
  Future<WorkflowResult> executeByName({
    required String name,
    Map<String, dynamic>? input,
    Map<String, dynamic>? options,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/workflows/execute',
      data: {
        'name': name,
        'input': input,
        'options': options,
      },
    );

    return WorkflowResult.fromJson(response['data']);
  }

  /// Get workflow execution status
  Future<WorkflowResult> getExecution(String executionId) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/workflows/executions/$executionId',
    );

    return WorkflowResult.fromJson(response['data']);
  }

  /// List workflow executions
  Future<List<WorkflowResult>> listExecutions({
    String? workflowId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/workflows/executions',
      params: {
        'workflowId': workflowId,
        'status': status,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'limit': limit,
        'offset': offset,
      },
    );

    return (response['data'] as List)
        .map((item) => WorkflowResult.fromJson(item))
        .toList();
  }

  /// Cancel workflow execution
  Future<void> cancelExecution(String executionId) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/workflows/executions/$executionId/cancel',
    );
  }

  /// Retry workflow execution
  Future<WorkflowResult> retryExecution(String executionId) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/workflows/executions/$executionId/retry',
    );

    return WorkflowResult.fromJson(response['data']);
  }

  /// List available workflows
  Future<List<Map<String, dynamic>>> listWorkflows({
    String? category,
    bool? active,
  }) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/workflows',
      params: {
        'category': category,
        'active': active,
      },
    );

    return (response['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Get workflow definition
  Future<Map<String, dynamic>> getWorkflow(String workflowId) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/workflows/$workflowId',
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Create a workflow
  Future<Map<String, dynamic>> createWorkflow({
    required String name,
    String? description,
    required Map<String, dynamic> definition,
    Map<String, dynamic>? metadata,
    bool active = true,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/workflows',
      data: {
        'name': name,
        'description': description,
        'definition': definition,
        'metadata': metadata,
        'active': active,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Update a workflow
  Future<Map<String, dynamic>> updateWorkflow(
    String workflowId, {
    String? name,
    String? description,
    Map<String, dynamic>? definition,
    Map<String, dynamic>? metadata,
    bool? active,
  }) async {
    final response = await _httpClient.patch<Map<String, dynamic>>(
      '/workflows/$workflowId',
      data: {
        'name': name,
        'description': description,
        'definition': definition,
        'metadata': metadata,
        'active': active,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  /// Delete a workflow
  Future<void> deleteWorkflow(String workflowId) async {
    await _httpClient.delete<Map<String, dynamic>>(
      '/workflows/$workflowId',
    );
  }

  /// Get workflow metrics
  Future<Map<String, dynamic>> getWorkflowMetrics(
    String workflowId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/workflows/$workflowId/metrics',
      params: {
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      },
    );

    return response['data'] as Map<String, dynamic>;
  }
}
