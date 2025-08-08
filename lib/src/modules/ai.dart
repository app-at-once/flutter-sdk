import 'dart:async';
import 'dart:typed_data';
import '../common/types.dart';
import '../utils/http_client.dart';

/// Job status response for AI generation jobs
class AIJobStatus {
  final String jobId;
  final String status;
  final int progress;
  final dynamic results;
  final String? error;
  final DateTime createdAt;
  final DateTime? completedAt;

  AIJobStatus({
    required this.jobId,
    required this.status,
    required this.progress,
    this.results,
    this.error,
    required this.createdAt,
    this.completedAt,
  });

  factory AIJobStatus.fromJson(Map<String, dynamic> json) {
    return AIJobStatus(
      jobId: json['jobId'],
      status: json['status'],
      progress: json['progress'] ?? 0,
      results: json['results'],
      error: json['error'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}

/// Image generation job response
class ImageGenerationJob {
  final String jobId;
  final String status;
  final int progress;

  ImageGenerationJob({
    required this.jobId,
    required this.status,
    required this.progress,
  });

  factory ImageGenerationJob.fromJson(Map<String, dynamic> json) {
    return ImageGenerationJob(
      jobId: json['jobId'],
      status: json['status'],
      progress: json['progress'] ?? 0,
    );
  }
}

/// Batch image generation job response
class BatchImageGenerationJob {
  final String jobId;
  final String status;
  final int totalImages;
  final int progress;

  BatchImageGenerationJob({
    required this.jobId,
    required this.status,
    required this.totalImages,
    required this.progress,
  });

  factory BatchImageGenerationJob.fromJson(Map<String, dynamic> json) {
    return BatchImageGenerationJob(
      jobId: json['jobId'],
      status: json['status'],
      totalImages: json['totalImages'],
      progress: json['progress'] ?? 0,
    );
  }
}

/// Voice info response
class VoiceInfo {
  final String id;
  final String name;
  final String? gender;
  final String? language;
  final Map<String, dynamic>? labels;

  VoiceInfo({
    required this.id,
    required this.name,
    this.gender,
    this.language,
    this.labels,
  });

  factory VoiceInfo.fromJson(Map<String, dynamic> json) {
    return VoiceInfo(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      language: json['language'],
      labels: json['labels'],
    );
  }
}

/// Voices response
class VoicesResponse {
  final List<VoiceInfo> voices;
  final String provider;

  VoicesResponse({
    required this.voices,
    required this.provider,
  });

  factory VoicesResponse.fromJson(Map<String, dynamic> json) {
    return VoicesResponse(
      voices:
          (json['voices'] as List).map((v) => VoiceInfo.fromJson(v)).toList(),
      provider: json['provider'],
    );
  }
}

/// Video pipeline info
class VideoPipeline {
  final String id;
  final String name;
  final List<String> features;

  VideoPipeline({
    required this.id,
    required this.name,
    required this.features,
  });

  factory VideoPipeline.fromJson(Map<String, dynamic> json) {
    return VideoPipeline(
      id: json['id'],
      name: json['name'],
      features: List<String>.from(json['features']),
    );
  }
}

/// AI module for AI operations
class AIModule {
  final HttpClient _httpClient;
  final ClientConfig _config;

  AIModule(this._httpClient, this._config);

  /// Generate text
  Future<AIGenerationResult> generateText({
    required String prompt,
    String? model,
    Map<String, dynamic>? options,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/generate/text',
      data: {
        'prompt': prompt,
        'model': model,
        'options': options,
      },
    );

    return AIGenerationResult.fromJson(response['data']);
  }

  /// Generate embeddings
  Future<List<double>> generateEmbeddings({
    required String text,
    String? model,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/embeddings',
      data: {
        'text': text,
        'model': model,
      },
    );

    return (response['embeddings'] as List).cast<double>();
  }

  /// Generate image with job-based processing
  Future<ImageGenerationJob> generateImage(
    String prompt, {
    int? width,
    int? height,
    String? model,
    String? negativePrompt,
    int? steps,
    double? cfg,
    int? seed,
    String? scheduler,
    String? style,
    Map<String, dynamic>? additionalOptions,
  }) async {
    final options = {
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (model != null) 'model': model,
      if (negativePrompt != null) 'negativePrompt': negativePrompt,
      if (steps != null) 'steps': steps,
      if (cfg != null) 'cfg': cfg,
      if (seed != null) 'seed': seed,
      if (scheduler != null) 'scheduler': scheduler,
      if (style != null) 'style': style,
      ...?additionalOptions,
    };

    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/generate/image',
      data: {
        'prompt': prompt,
        ...options,
      },
    );

    return ImageGenerationJob.fromJson(response);
  }

  /// Get image job status
  Future<AIJobStatus> getImageJobStatus(String jobId) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/ai/generate/image/$jobId',
    );

    return AIJobStatus.fromJson(response);
  }

  /// Generate batch images with job-based processing
  Future<BatchImageGenerationJob> generateBatchImages(
    List<String> prompts, {
    int? width,
    int? height,
    String? model,
    int? steps,
    double? cfg,
    Map<String, dynamic>? additionalOptions,
  }) async {
    final options = {
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (model != null) 'model': model,
      if (steps != null) 'steps': steps,
      if (cfg != null) 'cfg': cfg,
      ...?additionalOptions,
    };

    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/generate/image/batch',
      data: {
        'prompts': prompts,
        ...options,
      },
    );

    return BatchImageGenerationJob.fromJson(response);
  }

  /// Upscale image
  Future<Map<String, dynamic>> upscaleImage(
    String imageUrl,
    int scaleFactor, {
    String? method,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/image/upscale',
      data: {
        'imageUrl': imageUrl,
        'scaleFactor': scaleFactor,
        if (method != null) 'method': method,
      },
    );

    return response;
  }

  /// Remove background from image
  Future<Map<String, dynamic>> removeBackground(
    String imageUrl,
    String resourceId,
    String resourceType,
  ) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/image/remove-background',
      data: {
        'imageUrl': imageUrl,
        'resourceId': resourceId,
        'resourceType': resourceType,
      },
    );

    return response;
  }

  /// Generate audio with job-based processing
  Future<ImageGenerationJob> generateAudio(
    String text, {
    String voice = 'alloy',
    String provider = 'openai',
    String? model,
    double speed = 1.0,
    Map<String, dynamic>? additionalOptions,
  }) async {
    final options = {
      'voice': voice,
      'provider': provider,
      if (model != null) 'model': model,
      'speed': speed,
      ...?additionalOptions,
    };

    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/generate/audio',
      data: {
        'text': text,
        ...options,
      },
    );

    return ImageGenerationJob.fromJson(response);
  }

  /// Get audio job status
  Future<AIJobStatus> getAudioJobStatus(String jobId) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/ai/generate/audio/$jobId',
    );

    return AIJobStatus.fromJson(response);
  }

  /// Get available audio voices
  Future<VoicesResponse> getAudioVoices(String provider) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/ai/audio/voices/$provider',
    );

    return VoicesResponse.fromJson(response);
  }

  /// Generate video with job-based processing and optional narration
  Future<ImageGenerationJob> generateVideo(
    String prompt, {
    int duration = 6,
    String aspectRatio = '16:9',
    String resolution = '1080p',
    String? style,
    bool voiceEnabled = false,
    String? voiceText,
    String voice = 'nova',
    double voiceSpeed = 1.0,
    String voiceProvider = 'openai',
    String? model,
    String? provider,
    int? fps,
    int? seed,
    Map<String, dynamic>? additionalOptions,
  }) async {
    final options = {
      'duration': duration,
      'aspectRatio': aspectRatio,
      'resolution': resolution,
      if (style != null) 'style': style,
      'voiceEnabled': voiceEnabled,
      if (voiceText != null) 'voiceText': voiceText,
      'voice': voice,
      'voiceSpeed': voiceSpeed,
      'voiceProvider': voiceProvider,
      if (model != null) 'model': model,
      if (provider != null) 'provider': provider,
      if (fps != null) 'fps': fps,
      if (seed != null) 'seed': seed,
      ...?additionalOptions,
    };

    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/generate/video',
      data: {
        'prompt': prompt,
        ...options,
      },
    );

    return ImageGenerationJob.fromJson(response);
  }

  /// Get video job status
  Future<AIJobStatus> getVideoJobStatus(String jobId) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/ai/generate/video/$jobId',
    );

    return AIJobStatus.fromJson(response);
  }

  /// Get available video pipelines
  Future<List<VideoPipeline>> getVideoPipelines() async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/ai/video/pipelines',
    );

    final pipelines = response['pipelines'] as List;
    return pipelines.map((p) => VideoPipeline.fromJson(p)).toList();
  }

  /// Transcribe audio
  Future<String> transcribeAudio({
    required Uint8List audioData,
    String? language,
  }) async {
    final response = await _httpClient.upload<Map<String, dynamic>>(
      '/ai/transcribe',
      bytes: audioData,
      filename: 'audio.wav',
      data: {
        'language': language,
      },
    );

    return response['text'] as String;
  }

  /// Translate text
  Future<String> translateText({
    required String text,
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/ai/translate',
      data: {
        'text': text,
        'targetLanguage': targetLanguage,
        'sourceLanguage': sourceLanguage,
      },
    );

    return response['translation'] as String;
  }

  /// Analyze image
  Future<Map<String, dynamic>> analyzeImage({
    required Uint8List imageData,
    List<String>? features,
  }) async {
    final response = await _httpClient.upload<Map<String, dynamic>>(
      '/ai/analyze/image',
      bytes: imageData,
      filename: 'image.jpg',
      data: {
        'features': features,
      },
    );

    return response['analysis'] as Map<String, dynamic>;
  }
}
