import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../utils/http_client.dart';

/// Image processing module for various image operations and analysis
class ImageProcessingModule {
  final HttpClient _httpClient;

  ImageProcessingModule(this._httpClient);

  /// Process image with various operations
  /// [source] - Image source (URL or bytes)
  /// [options] - Processing options
  /// Returns processed image
  Future<ProcessedImage> processImage(
    dynamic source,
    ImageProcessingOptions options,
  ) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'image'),
      ));
    }

    formData.fields.add(MapEntry('options', options.toJson()));

    final response = await _httpClient.post(
      '/image-processing/process',
      data: formData,
    );
    return ProcessedImage.fromJson(response.data);
  }

  /// Batch process multiple images
  /// [images] - List of images with their options
  /// [commonOptions] - Common options applied to all images
  /// Returns list of processed images
  Future<List<ProcessedImage>> batchProcess(
    List<ImageBatchItem> images, {
    ImageProcessingOptions? commonOptions,
  }) async {
    final formData = FormData();

    for (int i = 0; i < images.length; i++) {
      final img = images[i];
      if (img.source is String) {
        formData.fields.add(MapEntry('sources[$i]', img.source));
      } else if (img.source is Uint8List) {
        formData.files.add(MapEntry(
          'files[$i]',
          MultipartFile.fromBytes(img.source, filename: 'image$i'),
        ));
      }
      formData.fields.add(MapEntry('options[$i]', img.options.toJson()));
    }

    if (commonOptions != null) {
      formData.fields.add(MapEntry('commonOptions', commonOptions.toJson()));
    }

    final response = await _httpClient.post(
      '/image-processing/batch',
      data: formData,
    );
    return (response.data as List)
        .map((e) => ProcessedImage.fromJson(e))
        .toList();
  }

  /// Analyze image content
  /// [source] - Image source (URL or bytes)
  /// [options] - Analysis options
  /// Returns image analysis
  Future<ImageAnalysis> analyzeImage(
    dynamic source, {
    ImageAnalysisOptions? options,
  }) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'image'),
      ));
    }

    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response = await _httpClient.post(
      '/image-processing/analyze',
      data: formData,
    );
    return ImageAnalysis.fromJson(response.data);
  }

  /// Generate thumbnail
  /// [source] - Image source (URL or bytes)
  /// [options] - Thumbnail options
  /// Returns processed thumbnail
  Future<ProcessedImage> generateThumbnail(
    dynamic source, {
    ThumbnailOptions? options,
  }) async {
    return processImage(
      source,
      ImageProcessingOptions(
        resize: ResizeOptions(
          width: options?.width ?? 200,
          height: options?.height ?? 200,
          fit: ProcessingImageFit.cover,
        ),
        format: options?.format,
        quality: options?.quality,
      ),
    );
  }

  /// Convert image format
  /// [source] - Image source (URL or bytes)
  /// [format] - Target format
  /// [options] - Conversion options
  /// Returns converted image
  Future<ProcessedImage> convertFormat(
    dynamic source,
    ProcessingImageFormat format, {
    ImageConversionOptions? options,
  }) async {
    return processImage(
      source,
      ImageProcessingOptions(
        format: format,
        quality: options?.quality,
        compress: options?.compress,
      ),
    );
  }

  /// Optimize image for web
  /// [source] - Image source (URL or bytes)
  /// [options] - Optimization options
  /// Returns optimized image
  Future<ProcessedImage> optimizeForWeb(
    dynamic source, {
    WebOptimizationOptions? options,
  }) async {
    return processImage(
      source,
      ImageProcessingOptions(
        resize: ResizeOptions(
          width: options?.maxWidth,
          height: options?.maxHeight,
          fit: ProcessingImageFit.inside,
        ),
        format: options?.format ?? ProcessingImageFormat.webp,
        quality: options?.quality ?? 85,
        compress: true,
      ),
    );
  }

  /// Create image variants
  /// [source] - Image source (URL or bytes)
  /// [variants] - List of variant specifications
  /// Returns map of variant names to processed images
  Future<Map<String, ProcessedImage>> createVariants(
    dynamic source,
    List<ImageVariant> variants,
  ) async {
    final results = <String, ProcessedImage>{};

    final futures = variants.map((variant) async {
      final processed = await processImage(
        source,
        ImageProcessingOptions(
          resize: ResizeOptions(
            width: variant.width,
            height: variant.height,
            fit: ProcessingImageFit.cover,
          ),
          format: variant.format,
          quality: variant.quality,
        ),
      );
      results[variant.name] = processed;
    });

    await Future.wait(futures);
    return results;
  }

  /// Compare images
  /// [image1] - First image source
  /// [image2] - Second image source
  /// Returns comparison result
  Future<ImageComparison> compareImages(
    dynamic image1,
    dynamic image2,
  ) async {
    final formData = FormData();

    if (image1 is String) {
      formData.fields.add(MapEntry('image1', image1));
    } else if (image1 is Uint8List) {
      formData.files.add(MapEntry(
        'file1',
        MultipartFile.fromBytes(image1, filename: 'image1'),
      ));
    }

    if (image2 is String) {
      formData.fields.add(MapEntry('image2', image2));
    } else if (image2 is Uint8List) {
      formData.files.add(MapEntry(
        'file2',
        MultipartFile.fromBytes(image2, filename: 'image2'),
      ));
    }

    final response = await _httpClient.post(
      '/image-processing/compare',
      data: formData,
    );
    return ImageComparison.fromJson(response.data);
  }

  /// Extract color palette
  /// [source] - Image source (URL or bytes)
  /// [count] - Number of colors to extract
  /// Returns color palette
  Future<List<ColorInfo>> extractColorPalette(
    dynamic source, {
    int count = 5,
  }) async {
    final analysis = await analyzeImage(
      source,
      options: const ImageAnalysisOptions(analyzeColors: true),
    );
    return analysis.colors.palette
        .take(count)
        .map((p) => ColorInfo(
              color: p.color,
              percentage: p.percentage,
              rgb: _hexToRgb(p.color),
              hex: p.color,
            ))
        .toList();
  }

  /// Smart crop with face detection
  /// [source] - Image source (URL or bytes)
  /// [options] - Smart crop options
  /// Returns cropped image
  Future<ProcessedImage> smartCrop(
    dynamic source,
    SmartCropOptions options,
  ) async {
    // First analyze the image to detect faces
    final analysis = await analyzeImage(
      source,
      options: const ImageAnalysisOptions(detectFaces: true),
    );

    var cropOptions = CropOptions(
      width: options.width,
      height: options.height,
    );

    if (options.focusOn == CropFocus.faces &&
        analysis.faces != null &&
        analysis.faces!.isNotEmpty) {
      // Calculate crop position based on face detection
      final face = analysis.faces![0];
      cropOptions = CropOptions(
        width: options.width,
        height: options.height,
        x: (face.x - (options.width - face.width) / 2)
            .clamp(0, double.infinity)
            .toInt(),
        y: (face.y - (options.height - face.height) / 2)
            .clamp(0, double.infinity)
            .toInt(),
      );
    }

    return processImage(
      source,
      ImageProcessingOptions(crop: cropOptions),
    );
  }

  /// Create collage from multiple images
  /// [images] - List of image sources
  /// [options] - Collage options
  /// Returns collage image
  Future<ProcessedImage> createCollage(
    List<dynamic> images, {
    CollageOptions? options,
  }) async {
    final formData = FormData();

    for (int i = 0; i < images.length; i++) {
      final img = images[i];
      if (img is String) {
        formData.fields.add(MapEntry('images[$i]', img));
      } else if (img is Uint8List) {
        formData.files.add(MapEntry(
          'files[$i]',
          MultipartFile.fromBytes(img, filename: 'image$i'),
        ));
      }
    }

    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response = await _httpClient.post(
      '/image-processing/collage',
      data: formData,
    );
    return ProcessedImage.fromJson(response.data);
  }

  /// Apply filter to image
  /// [source] - Image source (URL or bytes)
  /// [filter] - Filter type
  /// [intensity] - Filter intensity (0.0 to 1.0)
  /// Returns filtered image
  Future<ProcessedImage> applyFilter(
    dynamic source,
    ImageFilter filter, {
    double intensity = 1.0,
  }) async {
    String sourceData;
    if (source is String) {
      sourceData = source;
    } else if (source is Uint8List) {
      sourceData = base64Encode(source);
    } else {
      throw ArgumentError('Source must be String (URL) or Uint8List (bytes)');
    }

    final response = await _httpClient.post(
      '/image-processing/filter',
      data: {
        'source': sourceData,
        'filter': filter.value,
        'intensity': intensity,
      },
    );
    return ProcessedImage.fromJson(response.data);
  }

  /// Generate placeholder image
  /// [options] - Placeholder options
  /// Returns placeholder image
  Future<ProcessedImage> generatePlaceholder(
    PlaceholderOptions options,
  ) async {
    final response = await _httpClient.post(
      '/image-processing/placeholder',
      data: options.toJson(),
    );
    return ProcessedImage.fromJson(response.data);
  }

  /// Helper method to convert hex to RGB
  List<int> _hexToRgb(String hex) {
    final result = RegExp(r'^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$',
            caseSensitive: false)
        .firstMatch(hex);
    return result != null
        ? [
            int.parse(result.group(1)!, radix: 16),
            int.parse(result.group(2)!, radix: 16),
            int.parse(result.group(3)!, radix: 16),
          ]
        : [0, 0, 0];
  }
}

// Core models and enums

enum ProcessingImageFormat {
  jpeg('jpeg'),
  png('png'),
  webp('webp'),
  avif('avif'),
  gif('gif'),
  tiff('tiff');

  const ProcessingImageFormat(this.value);
  final String value;

  static ProcessingImageFormat fromString(String value) {
    return ProcessingImageFormat.values.firstWhere(
      (format) => format.value == value,
      orElse: () => throw ArgumentError('Unknown image format: $value'),
    );
  }
}

enum ProcessingImageFit {
  cover('cover'),
  contain('contain'),
  fill('fill'),
  inside('inside'),
  outside('outside');

  const ProcessingImageFit(this.value);
  final String value;
}

enum ImagePosition {
  center('center'),
  top('top'),
  bottom('bottom'),
  left('left'),
  right('right'),
  topLeft('top left'),
  topRight('top right'),
  bottomLeft('bottom left'),
  bottomRight('bottom right');

  const ImagePosition(this.value);
  final String value;
}

enum WatermarkPosition {
  center('center'),
  topLeft('top-left'),
  topRight('top-right'),
  bottomLeft('bottom-left'),
  bottomRight('bottom-right');

  const WatermarkPosition(this.value);
  final String value;
}

enum ImageFilter {
  vintage('vintage'),
  noir('noir'),
  chrome('chrome'),
  fade('fade'),
  vivid('vivid'),
  dramatic('dramatic'),
  warm('warm'),
  cold('cold');

  const ImageFilter(this.value);
  final String value;
}

enum CollageLayout {
  grid('grid'),
  horizontal('horizontal'),
  vertical('vertical'),
  custom('custom');

  const CollageLayout(this.value);
  final String value;
}

enum CropFocus {
  faces('faces'),
  center('center'),
  attention('attention');

  const CropFocus(this.value);
  final String value;
}

// Option classes

class ImageProcessingOptions {
  final ResizeOptions? resize;
  final CropOptions? crop;
  final double? rotate;
  final bool? flip;
  final bool? flop;
  final double? blur;
  final double? sharpen;
  final bool? grayscale;
  final bool? sepia;
  final String? tint;
  final ProcessingImageFormat? format;
  final int? quality;
  final bool? compress;
  final WatermarkOptions? watermark;
  final String? background;
  final bool? removeBackground;
  final EnhanceOptions? enhance;

  const ImageProcessingOptions({
    this.resize,
    this.crop,
    this.rotate,
    this.flip,
    this.flop,
    this.blur,
    this.sharpen,
    this.grayscale,
    this.sepia,
    this.tint,
    this.format,
    this.quality,
    this.compress,
    this.watermark,
    this.background,
    this.removeBackground,
    this.enhance,
  });

  String toJson() => jsonEncode({
        if (resize != null) 'resize': resize!.toJson(),
        if (crop != null) 'crop': crop!.toJson(),
        if (rotate != null) 'rotate': rotate,
        if (flip != null) 'flip': flip,
        if (flop != null) 'flop': flop,
        if (blur != null) 'blur': blur,
        if (sharpen != null) 'sharpen': sharpen,
        if (grayscale != null) 'grayscale': grayscale,
        if (sepia != null) 'sepia': sepia,
        if (tint != null) 'tint': tint,
        if (format != null) 'format': format!.value,
        if (quality != null) 'quality': quality,
        if (compress != null) 'compress': compress,
        if (watermark != null) 'watermark': watermark!.toJson(),
        if (background != null) 'background': background,
        if (removeBackground != null) 'removeBackground': removeBackground,
        if (enhance != null) 'enhance': enhance!.toJson(),
      });
}

class ResizeOptions {
  final int? width;
  final int? height;
  final ProcessingImageFit? fit;
  final ImagePosition? position;

  const ResizeOptions({
    this.width,
    this.height,
    this.fit,
    this.position,
  });

  Map<String, dynamic> toJson() => {
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (fit != null) 'fit': fit!.value,
        if (position != null) 'position': position!.value,
      };
}

class CropOptions {
  final int width;
  final int height;
  final int? x;
  final int? y;

  const CropOptions({
    required this.width,
    required this.height,
    this.x,
    this.y,
  });

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        if (x != null) 'x': x,
        if (y != null) 'y': y,
      };
}

class WatermarkOptions {
  final String? text;
  final String? image;
  final WatermarkPosition? position;
  final double? opacity;
  final int? size;

  const WatermarkOptions({
    this.text,
    this.image,
    this.position,
    this.opacity,
    this.size,
  });

  Map<String, dynamic> toJson() => {
        if (text != null) 'text': text,
        if (image != null) 'image': image,
        if (position != null) 'position': position!.value,
        if (opacity != null) 'opacity': opacity,
        if (size != null) 'size': size,
      };
}

class EnhanceOptions {
  final double? brightness;
  final double? contrast;
  final double? saturation;

  const EnhanceOptions({
    this.brightness,
    this.contrast,
    this.saturation,
  });

  Map<String, dynamic> toJson() => {
        if (brightness != null) 'brightness': brightness,
        if (contrast != null) 'contrast': contrast,
        if (saturation != null) 'saturation': saturation,
      };
}

class ImageAnalysisOptions {
  final bool detectFaces;
  final bool detectObjects;
  final bool extractText;
  final bool analyzeColors;
  final bool extractMetadata;

  const ImageAnalysisOptions({
    this.detectFaces = false,
    this.detectObjects = false,
    this.extractText = false,
    this.analyzeColors = false,
    this.extractMetadata = false,
  });

  String toJson() => jsonEncode({
        'detectFaces': detectFaces,
        'detectObjects': detectObjects,
        'extractText': extractText,
        'analyzeColors': analyzeColors,
        'extractMetadata': extractMetadata,
      });
}

class ThumbnailOptions {
  final int? width;
  final int? height;
  final ProcessingImageFormat? format;
  final int? quality;

  const ThumbnailOptions({
    this.width,
    this.height,
    this.format,
    this.quality,
  });
}

class ImageConversionOptions {
  final int? quality;
  final bool? compress;

  const ImageConversionOptions({
    this.quality,
    this.compress,
  });
}

class WebOptimizationOptions {
  final int? maxWidth;
  final int? maxHeight;
  final ProcessingImageFormat? format;
  final int? quality;

  const WebOptimizationOptions({
    this.maxWidth,
    this.maxHeight,
    this.format,
    this.quality,
  });
}

class SmartCropOptions {
  final int width;
  final int height;
  final CropFocus? focusOn;

  const SmartCropOptions({
    required this.width,
    required this.height,
    this.focusOn,
  });
}

class CollageOptions {
  final CollageLayout? layout;
  final int? spacing;
  final String? backgroundColor;
  final int? width;
  final int? height;

  const CollageOptions({
    this.layout,
    this.spacing,
    this.backgroundColor,
    this.width,
    this.height,
  });

  String toJson() => jsonEncode({
        if (layout != null) 'layout': layout!.value,
        if (spacing != null) 'spacing': spacing,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
      });
}

class PlaceholderOptions {
  final int width;
  final int height;
  final String? text;
  final String? backgroundColor;
  final String? textColor;
  final ProcessingImageFormat? format;

  const PlaceholderOptions({
    required this.width,
    required this.height,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.format,
  });

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        if (text != null) 'text': text,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
        if (textColor != null) 'textColor': textColor,
        if (format != null) 'format': format!.value,
      };
}

// Data classes

class ImageBatchItem {
  final dynamic source;
  final ImageProcessingOptions options;

  const ImageBatchItem({
    required this.source,
    required this.options,
  });
}

class ImageVariant {
  final String name;
  final int? width;
  final int? height;
  final ProcessingImageFormat? format;
  final int? quality;

  const ImageVariant({
    required this.name,
    this.width,
    this.height,
    this.format,
    this.quality,
  });
}

class ProcessedImage {
  final String id;
  final String url;
  final int width;
  final int height;
  final String format;
  final int size;
  final Map<String, dynamic>? metadata;
  final List<String> operations;
  final DateTime createdAt;

  const ProcessedImage({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    required this.format,
    required this.size,
    this.metadata,
    required this.operations,
    required this.createdAt,
  });

  factory ProcessedImage.fromJson(Map<String, dynamic> json) => ProcessedImage(
        id: json['id'],
        url: json['url'],
        width: json['width'],
        height: json['height'],
        format: json['format'],
        size: json['size'],
        metadata: json['metadata'],
        operations: (json['operations'] as List).cast<String>(),
        createdAt: DateTime.parse(json['created_at']),
      );
}

class ImageAnalysis {
  final int width;
  final int height;
  final String format;
  final int size;
  final String colorSpace;
  final bool hasAlpha;
  final ImageMetadata metadata;
  final ColorAnalysis colors;
  final List<Face>? faces;
  final List<DetectedObject>? objects;
  final List<DetectedText>? text;

  const ImageAnalysis({
    required this.width,
    required this.height,
    required this.format,
    required this.size,
    required this.colorSpace,
    required this.hasAlpha,
    required this.metadata,
    required this.colors,
    this.faces,
    this.objects,
    this.text,
  });

  factory ImageAnalysis.fromJson(Map<String, dynamic> json) => ImageAnalysis(
        width: json['width'],
        height: json['height'],
        format: json['format'],
        size: json['size'],
        colorSpace: json['colorSpace'],
        hasAlpha: json['hasAlpha'],
        metadata: ImageMetadata.fromJson(json['metadata']),
        colors: ColorAnalysis.fromJson(json['colors']),
        faces: json['faces'] != null
            ? (json['faces'] as List).map((e) => Face.fromJson(e)).toList()
            : null,
        objects: json['objects'] != null
            ? (json['objects'] as List)
                .map((e) => DetectedObject.fromJson(e))
                .toList()
            : null,
        text: json['text'] != null
            ? (json['text'] as List)
                .map((e) => DetectedText.fromJson(e))
                .toList()
            : null,
      );
}

class ImageMetadata {
  final Map<String, dynamic>? exif;
  final Map<String, dynamic>? iptc;
  final Map<String, dynamic>? xmp;

  const ImageMetadata({
    this.exif,
    this.iptc,
    this.xmp,
  });

  factory ImageMetadata.fromJson(Map<String, dynamic> json) => ImageMetadata(
        exif: json['exif'],
        iptc: json['iptc'],
        xmp: json['xmp'],
      );
}

class ColorAnalysis {
  final List<String> dominant;
  final List<ColorPalette> palette;

  const ColorAnalysis({
    required this.dominant,
    required this.palette,
  });

  factory ColorAnalysis.fromJson(Map<String, dynamic> json) => ColorAnalysis(
        dominant: (json['dominant'] as List).cast<String>(),
        palette: (json['palette'] as List)
            .map((e) => ColorPalette.fromJson(e))
            .toList(),
      );
}

class ColorPalette {
  final String color;
  final double percentage;

  const ColorPalette({
    required this.color,
    required this.percentage,
  });

  factory ColorPalette.fromJson(Map<String, dynamic> json) => ColorPalette(
        color: json['color'],
        percentage: json['percentage'].toDouble(),
      );
}

class Face {
  final double x;
  final double y;
  final double width;
  final double height;
  final double confidence;

  const Face({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
  });

  factory Face.fromJson(Map<String, dynamic> json) => Face(
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        confidence: json['confidence'].toDouble(),
      );
}

class DetectedObject {
  final String label;
  final double confidence;
  final BoundingBox boundingBox;

  const DetectedObject({
    required this.label,
    required this.confidence,
    required this.boundingBox,
  });

  factory DetectedObject.fromJson(Map<String, dynamic> json) => DetectedObject(
        label: json['label'],
        confidence: json['confidence'].toDouble(),
        boundingBox: BoundingBox.fromJson(json['boundingBox']),
      );
}

class DetectedText {
  final String text;
  final double confidence;
  final BoundingBox boundingBox;

  const DetectedText({
    required this.text,
    required this.confidence,
    required this.boundingBox,
  });

  factory DetectedText.fromJson(Map<String, dynamic> json) => DetectedText(
        text: json['text'],
        confidence: json['confidence'].toDouble(),
        boundingBox: BoundingBox.fromJson(json['boundingBox']),
      );
}

class BoundingBox {
  final double x;
  final double y;
  final double width;
  final double height;

  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) => BoundingBox(
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
      );
}

class ImageComparison {
  final double similarity;
  final double difference;
  final String? diffImage;
  final bool identical;

  const ImageComparison({
    required this.similarity,
    required this.difference,
    this.diffImage,
    required this.identical,
  });

  factory ImageComparison.fromJson(Map<String, dynamic> json) =>
      ImageComparison(
        similarity: json['similarity'].toDouble(),
        difference: json['difference'].toDouble(),
        diffImage: json['diffImage'],
        identical: json['identical'],
      );
}

class ColorInfo {
  final String color;
  final double percentage;
  final List<int> rgb;
  final String hex;

  const ColorInfo({
    required this.color,
    required this.percentage,
    required this.rgb,
    required this.hex,
  });
}
