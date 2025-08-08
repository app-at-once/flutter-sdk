import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../utils/http_client.dart';

/// Document conversion module for converting documents between formats
class DocumentConversionModule {
  final HttpClient _httpClient;

  DocumentConversionModule(this._httpClient);

  /// Convert document to specified format
  /// [source] - Document source (URL or bytes)
  /// [targetFormat] - Target format to convert to
  /// [options] - Conversion options
  /// Returns converted document
  Future<ConvertedDocument> convert(
    dynamic source,
    String targetFormat, {
    ConversionOptions? options,
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

    formData.fields.add(MapEntry('targetFormat', targetFormat));

    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response =
        await _httpClient.post('/documents/convert', data: formData);
    return ConvertedDocument.fromJson(response.data);
  }

  /// Convert PDF to Word document
  /// [source] - PDF source (URL or bytes)
  /// [options] - Conversion options
  /// Returns Word document
  Future<ConvertedDocument> pdfToWord(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'docx', options: options);
  }

  /// Convert PDF to Excel spreadsheet
  /// [source] - PDF source (URL or bytes)
  /// [options] - Conversion options
  /// Returns Excel document
  Future<ConvertedDocument> pdfToExcel(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'xlsx', options: options);
  }

  /// Convert PDF to PowerPoint presentation
  /// [source] - PDF source (URL or bytes)
  /// [options] - Conversion options
  /// Returns PowerPoint document
  Future<ConvertedDocument> pdfToPowerPoint(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'pptx', options: options);
  }

  /// Convert Word document to PDF
  /// [source] - Word document source (URL or bytes)
  /// [options] - Conversion options
  /// Returns PDF document
  Future<ConvertedDocument> wordToPdf(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'pdf', options: options);
  }

  /// Convert Excel spreadsheet to PDF
  /// [source] - Excel document source (URL or bytes)
  /// [options] - Conversion options
  /// Returns PDF document
  Future<ConvertedDocument> excelToPdf(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'pdf', options: options);
  }

  /// Convert PowerPoint presentation to PDF
  /// [source] - PowerPoint document source (URL or bytes)
  /// [options] - Conversion options
  /// Returns PDF document
  Future<ConvertedDocument> powerPointToPdf(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'pdf', options: options);
  }

  /// Convert document to HTML
  /// [source] - Document source (URL or bytes)
  /// [options] - Conversion options
  /// Returns HTML document
  Future<ConvertedDocument> toHtml(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'html', options: options);
  }

  /// Convert document to text
  /// [source] - Document source (URL or bytes)
  /// [options] - Conversion options
  /// Returns text document
  Future<ConvertedDocument> toText(
    dynamic source, {
    ConversionOptions? options,
  }) async {
    return convert(source, 'txt', options: options);
  }

  /// Get document information
  /// [source] - Document source (URL or bytes)
  /// Returns document information
  Future<DocumentInfo> getDocumentInfo(dynamic source) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document'),
      ));
    }

    final response = await _httpClient.post('/documents/info', data: formData);
    return DocumentInfo.fromJson(response.data);
  }

  /// Get supported conversion formats
  /// [sourceFormat] - Source format to check conversions for
  /// Returns list of supported target formats
  Future<List<String>> getSupportedFormats({String? sourceFormat}) async {
    final queryParams = <String, dynamic>{
      if (sourceFormat != null) 'sourceFormat': sourceFormat,
    };

    final response = await _httpClient.get(
      '/documents/formats',
      params: queryParams,
    );
    return (response.data['formats'] as List).cast<String>();
  }

  /// Batch convert multiple documents
  /// [conversions] - List of conversion requests
  /// Returns list of converted documents
  Future<List<ConvertedDocument>> batchConvert(
    List<ConversionRequest> conversions,
  ) async {
    final formData = FormData();

    for (int i = 0; i < conversions.length; i++) {
      final conversion = conversions[i];

      if (conversion.source is String) {
        formData.fields.add(MapEntry('sources[$i]', conversion.source));
      } else if (conversion.source is Uint8List) {
        formData.files.add(MapEntry(
          'files[$i]',
          MultipartFile.fromBytes(conversion.source, filename: 'document$i'),
        ));
      }

      formData.fields
          .add(MapEntry('targetFormats[$i]', conversion.targetFormat));
      if (conversion.options != null) {
        formData.fields
            .add(MapEntry('options[$i]', conversion.options!.toJson()));
      }
    }

    final response =
        await _httpClient.post('/documents/batch-convert', data: formData);
    return (response.data as List)
        .map((e) => ConvertedDocument.fromJson(e))
        .toList();
  }
}

// Core models and enums

enum ConversionQuality {
  low('low'),
  medium('medium'),
  high('high'),
  best('best');

  const ConversionQuality(this.value);
  final String value;
}

class ConversionOptions {
  final String? format;
  final ConversionQuality? quality;
  final bool? preserveFormatting;
  final bool? embedFonts;
  final bool? embedImages;
  final String? pageRange;
  final String? password;
  final Map<String, dynamic>? metadata;

  const ConversionOptions({
    this.format,
    this.quality,
    this.preserveFormatting,
    this.embedFonts,
    this.embedImages,
    this.pageRange,
    this.password,
    this.metadata,
  });

  String toJson() => jsonEncode({
        if (format != null) 'format': format,
        if (quality != null) 'quality': quality!.value,
        if (preserveFormatting != null)
          'preserveFormatting': preserveFormatting,
        if (embedFonts != null) 'embedFonts': embedFonts,
        if (embedImages != null) 'embedImages': embedImages,
        if (pageRange != null) 'pageRange': pageRange,
        if (password != null) 'password': password,
        if (metadata != null) 'metadata': metadata,
      });
}

class ConvertedDocument {
  final String id;
  final String url;
  final String format;
  final int size;
  final int? pages;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const ConvertedDocument({
    required this.id,
    required this.url,
    required this.format,
    required this.size,
    this.pages,
    this.metadata,
    required this.createdAt,
  });

  factory ConvertedDocument.fromJson(Map<String, dynamic> json) =>
      ConvertedDocument(
        id: json['id'],
        url: json['url'],
        format: json['format'],
        size: json['size'],
        pages: json['pages'],
        metadata: json['metadata'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

class DocumentInfo {
  final String format;
  final int size;
  final int? pages;
  final bool? encrypted;
  final DocumentMetadata? metadata;
  final DocumentCompatibility? compatibility;

  const DocumentInfo({
    required this.format,
    required this.size,
    this.pages,
    this.encrypted,
    this.metadata,
    this.compatibility,
  });

  factory DocumentInfo.fromJson(Map<String, dynamic> json) => DocumentInfo(
        format: json['format'],
        size: json['size'],
        pages: json['pages'],
        encrypted: json['encrypted'],
        metadata: json['metadata'] != null
            ? DocumentMetadata.fromJson(json['metadata'])
            : null,
        compatibility: json['compatibility'] != null
            ? DocumentCompatibility.fromJson(json['compatibility'])
            : null,
      );
}

class DocumentMetadata {
  final String? title;
  final String? author;
  final String? subject;
  final List<String>? keywords;
  final DateTime? created;
  final DateTime? modified;
  final String? application;

  const DocumentMetadata({
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.created,
    this.modified,
    this.application,
  });

  factory DocumentMetadata.fromJson(Map<String, dynamic> json) =>
      DocumentMetadata(
        title: json['title'],
        author: json['author'],
        subject: json['subject'],
        keywords: (json['keywords'] as List?)?.cast<String>(),
        created:
            json['created'] != null ? DateTime.parse(json['created']) : null,
        modified:
            json['modified'] != null ? DateTime.parse(json['modified']) : null,
        application: json['application'],
      );
}

class DocumentCompatibility {
  final List<String> formats;
  final List<String> versions;

  const DocumentCompatibility({
    required this.formats,
    required this.versions,
  });

  factory DocumentCompatibility.fromJson(Map<String, dynamic> json) =>
      DocumentCompatibility(
        formats: (json['formats'] as List).cast<String>(),
        versions: (json['versions'] as List).cast<String>(),
      );
}

class ConversionRequest {
  final dynamic source;
  final String targetFormat;
  final ConversionOptions? options;

  const ConversionRequest({
    required this.source,
    required this.targetFormat,
    this.options,
  });
}
