import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../utils/http_client.dart';

/// OCR module for optical character recognition
class OCRModule {
  final HttpClient _httpClient;

  OCRModule(this._httpClient);

  /// Perform OCR on image or document
  /// [source] - Image or document source (URL or bytes)
  /// [options] - OCR options
  /// Returns OCR result
  Future<OCRResult> processImage(
    dynamic source, {
    OCROptions? options,
  }) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document'),
      ));
    }

    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response = await _httpClient.post('/ocr/process', data: formData);
    return OCRResult.fromJson(response.data);
  }

  /// Extract text from document
  /// [source] - Document source (URL or bytes)
  /// [options] - OCR options
  /// Returns extracted text
  Future<String> extractText(dynamic source, {OCROptions? options}) async {
    final result = await processImage(source, options: options);
    return result.text;
  }

  /// Detect and extract tables from document
  /// [source] - Document source (URL or bytes)
  /// Returns list of detected tables
  Future<List<OCRTable>> extractTables(dynamic source) async {
    final result = await processImage(
      source,
      options: const OCROptions(detectTables: true),
    );
    return result.tables ?? [];
  }

  /// Detect and extract barcodes from image
  /// [source] - Image source (URL or bytes)
  /// Returns list of detected barcodes
  Future<List<OCRBarcode>> extractBarcodes(dynamic source) async {
    final result = await processImage(
      source,
      options: const OCROptions(detectBarcodes: true),
    );
    return result.barcodes ?? [];
  }
}

// Core models and enums

enum OCRMode {
  fast('fast'),
  accurate('accurate'),
  handwriting('handwriting');

  const OCRMode(this.value);
  final String value;
}

enum OCROutputFormat {
  text('text'),
  json('json'),
  pdf('pdf'),
  docx('docx');

  const OCROutputFormat(this.value);
  final String value;
}

class OCROptions {
  final List<String>? languages;
  final OCRMode? mode;
  final OCROutputFormat? outputFormat;
  final bool? preserveLayout;
  final bool? detectTables;
  final bool? detectBarcodes;
  final bool? enhanceImage;
  final bool? deskew;
  final bool? removeNoise;
  final double? confidence;

  const OCROptions({
    this.languages,
    this.mode,
    this.outputFormat,
    this.preserveLayout,
    this.detectTables,
    this.detectBarcodes,
    this.enhanceImage,
    this.deskew,
    this.removeNoise,
    this.confidence,
  });

  String toJson() => jsonEncode({
        if (languages != null) 'languages': languages,
        if (mode != null) 'mode': mode!.value,
        if (outputFormat != null) 'outputFormat': outputFormat!.value,
        if (preserveLayout != null) 'preserveLayout': preserveLayout,
        if (detectTables != null) 'detectTables': detectTables,
        if (detectBarcodes != null) 'detectBarcodes': detectBarcodes,
        if (enhanceImage != null) 'enhanceImage': enhanceImage,
        if (deskew != null) 'deskew': deskew,
        if (removeNoise != null) 'removeNoise': removeNoise,
        if (confidence != null) 'confidence': confidence,
      });
}

class OCRResult {
  final String text;
  final double confidence;
  final String language;
  final List<OCRPage>? pages;
  final List<OCRTable>? tables;
  final List<OCRBarcode>? barcodes;
  final OCRMetadata? metadata;

  const OCRResult({
    required this.text,
    required this.confidence,
    required this.language,
    this.pages,
    this.tables,
    this.barcodes,
    this.metadata,
  });

  factory OCRResult.fromJson(Map<String, dynamic> json) => OCRResult(
        text: json['text'],
        confidence: json['confidence'].toDouble(),
        language: json['language'],
        pages: json['pages'] != null
            ? (json['pages'] as List).map((e) => OCRPage.fromJson(e)).toList()
            : null,
        tables: json['tables'] != null
            ? (json['tables'] as List).map((e) => OCRTable.fromJson(e)).toList()
            : null,
        barcodes: json['barcodes'] != null
            ? (json['barcodes'] as List)
                .map((e) => OCRBarcode.fromJson(e))
                .toList()
            : null,
        metadata: json['metadata'] != null
            ? OCRMetadata.fromJson(json['metadata'])
            : null,
      );
}

class OCRPage {
  final int pageNumber;
  final String text;
  final double confidence;
  final double width;
  final double height;
  final List<OCRTextBlock> blocks;

  const OCRPage({
    required this.pageNumber,
    required this.text,
    required this.confidence,
    required this.width,
    required this.height,
    required this.blocks,
  });

  factory OCRPage.fromJson(Map<String, dynamic> json) => OCRPage(
        pageNumber: json['pageNumber'],
        text: json['text'],
        confidence: json['confidence'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        blocks: (json['blocks'] as List)
            .map((e) => OCRTextBlock.fromJson(e))
            .toList(),
      );
}

class OCRTextBlock {
  final String text;
  final double confidence;
  final OCRBoundingBox boundingBox;
  final List<OCRWord>? words;

  const OCRTextBlock({
    required this.text,
    required this.confidence,
    required this.boundingBox,
    this.words,
  });

  factory OCRTextBlock.fromJson(Map<String, dynamic> json) => OCRTextBlock(
        text: json['text'],
        confidence: json['confidence'].toDouble(),
        boundingBox: OCRBoundingBox.fromJson(json['boundingBox']),
        words: json['words'] != null
            ? (json['words'] as List).map((e) => OCRWord.fromJson(e)).toList()
            : null,
      );
}

class OCRWord {
  final String text;
  final double confidence;
  final OCRBoundingBox boundingBox;

  const OCRWord({
    required this.text,
    required this.confidence,
    required this.boundingBox,
  });

  factory OCRWord.fromJson(Map<String, dynamic> json) => OCRWord(
        text: json['text'],
        confidence: json['confidence'].toDouble(),
        boundingBox: OCRBoundingBox.fromJson(json['boundingBox']),
      );
}

class OCRBoundingBox {
  final double x;
  final double y;
  final double width;
  final double height;

  const OCRBoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory OCRBoundingBox.fromJson(Map<String, dynamic> json) => OCRBoundingBox(
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
      );
}

class OCRTable {
  final List<List<String>> rows;
  final OCRBoundingBox boundingBox;
  final double confidence;

  const OCRTable({
    required this.rows,
    required this.boundingBox,
    required this.confidence,
  });

  factory OCRTable.fromJson(Map<String, dynamic> json) => OCRTable(
        rows: (json['rows'] as List)
            .map((row) => (row as List).cast<String>())
            .toList(),
        boundingBox: OCRBoundingBox.fromJson(json['boundingBox']),
        confidence: json['confidence'].toDouble(),
      );
}

class OCRBarcode {
  final String type;
  final String data;
  final String format;
  final OCRBoundingBox position;

  const OCRBarcode({
    required this.type,
    required this.data,
    required this.format,
    required this.position,
  });

  factory OCRBarcode.fromJson(Map<String, dynamic> json) => OCRBarcode(
        type: json['type'],
        data: json['data'],
        format: json['format'],
        position: OCRBoundingBox.fromJson(json['position']),
      );
}

class OCRMetadata {
  final int processingTime;
  final int characterCount;
  final int wordCount;
  final int lineCount;

  const OCRMetadata({
    required this.processingTime,
    required this.characterCount,
    required this.wordCount,
    required this.lineCount,
  });

  factory OCRMetadata.fromJson(Map<String, dynamic> json) => OCRMetadata(
        processingTime: json['processingTime'],
        characterCount: json['characterCount'],
        wordCount: json['wordCount'],
        lineCount: json['lineCount'],
      );
}
