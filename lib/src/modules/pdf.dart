import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../utils/http_client.dart';

/// PDF module for PDF generation, manipulation, and processing
class PDFModule {
  final HttpClient _httpClient;

  PDFModule(this._httpClient);

  /// Generate PDF from HTML
  /// [html] - HTML content
  /// [options] - PDF generation options
  /// Returns generated PDF document
  Future<PDFDocument> generateFromHTML(
    String html, {
    PDFGenerationOptions? options,
  }) async {
    final response = await _httpClient.post('/pdf/generate/html', data: {
      'html': html,
      if (options != null) 'options': options.toJson(),
    });
    return PDFDocument.fromJson(response.data);
  }

  /// Generate PDF from URL
  /// [url] - URL to convert to PDF
  /// [options] - PDF generation options with URL-specific options
  /// Returns generated PDF document
  Future<PDFDocument> generateFromURL(
    String url, {
    PDFGenerationOptions? options,
    String? waitForSelector,
    int? waitForTimeout,
    List<PDFCookie>? cookies,
  }) async {
    final response = await _httpClient.post('/pdf/generate/url', data: {
      'url': url,
      if (options != null) ...options.toJson(),
      if (waitForSelector != null) 'waitForSelector': waitForSelector,
      if (waitForTimeout != null) 'waitForTimeout': waitForTimeout,
      if (cookies != null) 'cookies': cookies.map((c) => c.toJson()).toList(),
    });
    return PDFDocument.fromJson(response.data);
  }

  /// Generate PDF from template
  /// [templateId] - Template ID
  /// [data] - Template data
  /// [options] - PDF generation options
  /// Returns generated PDF document
  Future<PDFDocument> generateFromTemplate(
    String templateId,
    Map<String, dynamic> data, {
    PDFGenerationOptions? options,
  }) async {
    final response = await _httpClient.post('/pdf/generate/template', data: {
      'templateId': templateId,
      'data': data,
      if (options != null) 'options': options.toJson(),
    });
    return PDFDocument.fromJson(response.data);
  }

  /// Merge multiple PDFs
  /// [documents] - List of PDF sources (URLs or bytes)
  /// [options] - Merge options
  /// Returns merged PDF document
  Future<PDFDocument> merge(
    List<dynamic> documents, {
    PDFMergeOptions? options,
  }) async {
    final formData = FormData();

    for (int i = 0; i < documents.length; i++) {
      final doc = documents[i];
      if (doc is String) {
        formData.fields.add(MapEntry('documents[$i]', doc));
      } else if (doc is Uint8List) {
        formData.files.add(MapEntry(
          'files[$i]',
          MultipartFile.fromBytes(doc, filename: 'document$i.pdf'),
        ));
      }
    }

    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response = await _httpClient.post('/pdf/merge', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Split PDF into multiple documents
  /// [source] - PDF source (URL or bytes)
  /// [options] - Split options
  /// Returns list of split PDF documents
  Future<List<PDFDocument>> split(
    dynamic source,
    PDFSplitOptions options,
  ) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    formData.fields.add(MapEntry('options', options.toJson()));

    final response = await _httpClient.post('/pdf/split', data: formData);
    return (response.data as List).map((e) => PDFDocument.fromJson(e)).toList();
  }

  /// Extract specific pages from PDF
  /// [source] - PDF source (URL or bytes)
  /// [pageRanges] - Page ranges to extract (e.g., "1-3,5,7-9")
  /// Returns PDF with extracted pages
  Future<PDFDocument> extractPages(
    dynamic source,
    String pageRanges,
  ) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    formData.fields.add(MapEntry('pageRanges', pageRanges));

    final response =
        await _httpClient.post('/pdf/extract-pages', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Rotate pages in PDF
  /// [source] - PDF source (URL or bytes)
  /// [rotation] - Rotation angle (90, 180, or 270 degrees)
  /// [pages] - Pages to rotate (optional, defaults to all pages)
  /// Returns PDF with rotated pages
  Future<PDFDocument> rotatePages(
    dynamic source,
    PDFRotation rotation, {
    String? pages,
  }) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    formData.fields.add(MapEntry('rotation', rotation.degrees.toString()));
    if (pages != null) {
      formData.fields.add(MapEntry('pages', pages));
    }

    final response = await _httpClient.post('/pdf/rotate', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Add watermark to PDF
  /// [source] - PDF source (URL or bytes)
  /// [watermark] - Watermark options
  /// Returns PDF with watermark
  Future<PDFDocument> addWatermark(
    dynamic source,
    PDFWatermarkOptions watermark,
  ) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    if (watermark.image != null) {
      if (watermark.image is String) {
        formData.fields.add(MapEntry('watermarkImage', watermark.image!));
      } else if (watermark.image is Uint8List) {
        formData.files.add(MapEntry(
          'watermarkFile',
          MultipartFile.fromBytes(watermark.image!, filename: 'watermark'),
        ));
      }
    }

    final watermarkOptions = watermark.toJson();
    watermarkOptions.remove('image');
    formData.fields.add(MapEntry('watermark', watermarkOptions.toString()));

    final response = await _httpClient.post('/pdf/watermark', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Compress PDF
  /// [source] - PDF source (URL or bytes)
  /// [options] - Compression options
  /// Returns compressed PDF document
  Future<PDFDocument> compress(
    dynamic source, {
    PDFCompressionOptions? options,
  }) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response = await _httpClient.post('/pdf/compress', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Protect PDF with password and permissions
  /// [source] - PDF source (URL or bytes)
  /// [options] - Protection options
  /// Returns protected PDF document
  Future<PDFDocument> protect(
    dynamic source,
    PDFProtectionOptions options,
  ) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    formData.fields.add(MapEntry('options', options.toJson()));

    final response = await _httpClient.post('/pdf/protect', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Unlock password-protected PDF
  /// [source] - PDF source (URL or bytes)
  /// [password] - PDF password
  /// Returns unlocked PDF document
  Future<PDFDocument> unlock(
    dynamic source,
    String password,
  ) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    formData.fields.add(MapEntry('password', password));

    final response = await _httpClient.post('/pdf/unlock', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Get PDF information
  /// [source] - PDF source (URL or bytes)
  /// Returns PDF information
  Future<PDFInfo> getInfo(dynamic source) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    final response = await _httpClient.post('/pdf/info', data: formData);
    return PDFInfo.fromJson(response.data);
  }

  /// Convert PDF pages to images
  /// [source] - PDF source (URL or bytes)
  /// [options] - Conversion options
  /// Returns list of page images
  Future<List<PDFPageImage>> toImages(
    dynamic source, {
    PDFToImageOptions? options,
  }) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response = await _httpClient.post('/pdf/to-images', data: formData);
    return (response.data as List)
        .map((e) => PDFPageImage.fromJson(e))
        .toList();
  }

  /// Add form fields to PDF
  /// [source] - PDF source (URL or bytes)
  /// [fields] - Form fields to add
  /// Returns PDF with form fields
  Future<PDFDocument> addFormFields(
    dynamic source,
    List<PDFFormField> fields,
  ) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    formData.fields.add(
        MapEntry('fields', jsonEncode(fields.map((f) => f.toJson()).toList())));

    final response =
        await _httpClient.post('/pdf/add-form-fields', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Fill PDF form
  /// [source] - PDF source (URL or bytes)
  /// [data] - Form data
  /// [options] - Fill options
  /// Returns filled PDF document
  Future<PDFDocument> fillForm(
    dynamic source,
    Map<String, dynamic> data, {
    PDFFormFillOptions? options,
  }) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    formData.fields.add(MapEntry('data', jsonEncode(data)));
    if (options != null) {
      formData.fields.add(MapEntry('options', options.toJson()));
    }

    final response = await _httpClient.post('/pdf/fill-form', data: formData);
    return PDFDocument.fromJson(response.data);
  }

  /// Sign PDF
  /// [source] - PDF source (URL or bytes)
  /// [signature] - Signature options
  /// [certificate] - Digital certificate (optional)
  /// Returns signed PDF document
  Future<PDFDocument> sign(
    dynamic source,
    PDFSignature signature, {
    PDFCertificate? certificate,
  }) async {
    final formData = FormData();

    if (source is String) {
      formData.fields.add(MapEntry('source', source));
    } else if (source is Uint8List) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(source, filename: 'document.pdf'),
      ));
    }

    if (signature.image != null) {
      if (signature.image is String) {
        formData.fields.add(MapEntry('signatureImage', signature.image!));
      } else if (signature.image is Uint8List) {
        formData.files.add(MapEntry(
          'signatureFile',
          MultipartFile.fromBytes(signature.image!, filename: 'signature'),
        ));
      }
    }

    final signatureOptions = signature.toJson();
    signatureOptions.remove('image');
    formData.fields.add(MapEntry('signature', jsonEncode(signatureOptions)));

    if (certificate != null) {
      formData.files.add(MapEntry(
        'certificate',
        MultipartFile.fromBytes(certificate.pfx, filename: 'certificate.pfx'),
      ));
      formData.fields
          .add(MapEntry('certificatePassword', certificate.password));
    }

    final response = await _httpClient.post('/pdf/sign', data: formData);
    return PDFDocument.fromJson(response.data);
  }
}

// Core models and enums

enum PDFFormat {
  a4('A4'),
  a3('A3'),
  letter('Letter'),
  legal('Legal'),
  tabloid('Tabloid');

  const PDFFormat(this.value);
  final String value;
}

enum PDFOrientation {
  portrait('portrait'),
  landscape('landscape');

  const PDFOrientation(this.value);
  final String value;
}

enum PDFRotation {
  degrees90(90),
  degrees180(180),
  degrees270(270);

  const PDFRotation(this.degrees);
  final int degrees;
}

enum PDFCompressionQuality {
  low('low'),
  medium('medium'),
  high('high');

  const PDFCompressionQuality(this.value);
  final String value;
}

enum PDFWatermarkPosition {
  center('center'),
  topLeft('top-left'),
  topRight('top-right'),
  bottomLeft('bottom-left'),
  bottomRight('bottom-right'),
  diagonal('diagonal');

  const PDFWatermarkPosition(this.value);
  final String value;
}

enum PDFFormFieldType {
  text('text'),
  checkbox('checkbox'),
  radio('radio'),
  dropdown('dropdown'),
  signature('signature');

  const PDFFormFieldType(this.value);
  final String value;
}

enum PDFImageFormat {
  jpeg('jpeg'),
  png('png'),
  webp('webp');

  const PDFImageFormat(this.value);
  final String value;
}

// Option classes

class PDFGenerationOptions {
  final PDFFormat? format;
  final PDFOrientation? orientation;
  final PDFMargin? margin;
  final bool? displayHeaderFooter;
  final String? headerTemplate;
  final String? footerTemplate;
  final bool? printBackground;
  final double? scale;
  final String? pageRanges;
  final bool? preferCSSPageSize;

  const PDFGenerationOptions({
    this.format,
    this.orientation,
    this.margin,
    this.displayHeaderFooter,
    this.headerTemplate,
    this.footerTemplate,
    this.printBackground,
    this.scale,
    this.pageRanges,
    this.preferCSSPageSize,
  });

  Map<String, dynamic> toJson() => {
        if (format != null) 'format': format!.value,
        if (orientation != null) 'orientation': orientation!.value,
        if (margin != null) 'margin': margin!.toJson(),
        if (displayHeaderFooter != null)
          'displayHeaderFooter': displayHeaderFooter,
        if (headerTemplate != null) 'headerTemplate': headerTemplate,
        if (footerTemplate != null) 'footerTemplate': footerTemplate,
        if (printBackground != null) 'printBackground': printBackground,
        if (scale != null) 'scale': scale,
        if (pageRanges != null) 'pageRanges': pageRanges,
        if (preferCSSPageSize != null) 'preferCSSPageSize': preferCSSPageSize,
      };
}

class PDFMargin {
  final String? top;
  final String? right;
  final String? bottom;
  final String? left;

  const PDFMargin({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  Map<String, dynamic> toJson() => {
        if (top != null) 'top': top,
        if (right != null) 'right': right,
        if (bottom != null) 'bottom': bottom,
        if (left != null) 'left': left,
      };
}

class PDFCookie {
  final String name;
  final String value;
  final String? domain;

  const PDFCookie({
    required this.name,
    required this.value,
    this.domain,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        if (domain != null) 'domain': domain,
      };
}

class PDFMergeOptions {
  final List<PDFPageRange>? pageRanges;
  final bool? alternatePages;
  final bool? reverse;

  const PDFMergeOptions({
    this.pageRanges,
    this.alternatePages,
    this.reverse,
  });

  String toJson() => jsonEncode({
        if (pageRanges != null)
          'pageRanges': pageRanges!.map((r) => r.toJson()).toList(),
        if (alternatePages != null) 'alternatePages': alternatePages,
        if (reverse != null) 'reverse': reverse,
      });
}

class PDFPageRange {
  final int document;
  final String? pages;

  const PDFPageRange({
    required this.document,
    this.pages,
  });

  Map<String, dynamic> toJson() => {
        'document': document,
        if (pages != null) 'pages': pages,
      };
}

class PDFSplitOptions {
  final List<String>? pageRanges;
  final int? pagesPerDocument;
  final List<int>? splitAt;

  const PDFSplitOptions({
    this.pageRanges,
    this.pagesPerDocument,
    this.splitAt,
  });

  String toJson() => jsonEncode({
        if (pageRanges != null) 'pageRanges': pageRanges,
        if (pagesPerDocument != null) 'pagesPerDocument': pagesPerDocument,
        if (splitAt != null) 'splitAt': splitAt,
      });
}

class PDFWatermarkOptions {
  final String? text;
  final dynamic image; // String (URL) or Uint8List (bytes)
  final PDFWatermarkPosition? position;
  final double? opacity;
  final double? rotation;
  final int? fontSize;
  final String? color;
  final String? pages;

  const PDFWatermarkOptions({
    this.text,
    this.image,
    this.position,
    this.opacity,
    this.rotation,
    this.fontSize,
    this.color,
    this.pages,
  });

  Map<String, dynamic> toJson() => {
        if (text != null) 'text': text,
        if (image != null) 'image': image,
        if (position != null) 'position': position!.value,
        if (opacity != null) 'opacity': opacity,
        if (rotation != null) 'rotation': rotation,
        if (fontSize != null) 'fontSize': fontSize,
        if (color != null) 'color': color,
        if (pages != null) 'pages': pages,
      };
}

class PDFCompressionOptions {
  final PDFCompressionQuality? quality;
  final int? imageQuality;
  final bool? removeMetadata;
  final bool? removeFonts;

  const PDFCompressionOptions({
    this.quality,
    this.imageQuality,
    this.removeMetadata,
    this.removeFonts,
  });

  String toJson() => jsonEncode({
        if (quality != null) 'quality': quality!.value,
        if (imageQuality != null) 'imageQuality': imageQuality,
        if (removeMetadata != null) 'removeMetadata': removeMetadata,
        if (removeFonts != null) 'removeFonts': removeFonts,
      });
}

class PDFProtectionOptions {
  final String? userPassword;
  final String? ownerPassword;
  final PDFPermissions? permissions;

  const PDFProtectionOptions({
    this.userPassword,
    this.ownerPassword,
    this.permissions,
  });

  String toJson() => jsonEncode({
        if (userPassword != null) 'userPassword': userPassword,
        if (ownerPassword != null) 'ownerPassword': ownerPassword,
        if (permissions != null) 'permissions': permissions!.toJson(),
      });
}

class PDFPermissions {
  final bool? printing;
  final bool? modifying;
  final bool? copying;
  final bool? annotating;
  final bool? formFilling;

  const PDFPermissions({
    this.printing,
    this.modifying,
    this.copying,
    this.annotating,
    this.formFilling,
  });

  Map<String, dynamic> toJson() => {
        if (printing != null) 'printing': printing,
        if (modifying != null) 'modifying': modifying,
        if (copying != null) 'copying': copying,
        if (annotating != null) 'annotating': annotating,
        if (formFilling != null) 'formFilling': formFilling,
      };
}

class PDFToImageOptions {
  final PDFImageFormat? format;
  final int? dpi;
  final String? pages;
  final int? quality;

  const PDFToImageOptions({
    this.format,
    this.dpi,
    this.pages,
    this.quality,
  });

  String toJson() => jsonEncode({
        if (format != null) 'format': format!.value,
        if (dpi != null) 'dpi': dpi,
        if (pages != null) 'pages': pages,
        if (quality != null) 'quality': quality,
      });
}

class PDFFormField {
  final PDFFormFieldType type;
  final String name;
  final int page;
  final double x;
  final double y;
  final double width;
  final double height;
  final bool? required;
  final dynamic defaultValue;
  final List<String>? options;

  const PDFFormField({
    required this.type,
    required this.name,
    required this.page,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.required,
    this.defaultValue,
    this.options,
  });

  Map<String, dynamic> toJson() => {
        'type': type.value,
        'name': name,
        'page': page,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        if (required != null) 'required': required,
        if (defaultValue != null) 'defaultValue': defaultValue,
        if (options != null) 'options': options,
      };
}

class PDFFormFillOptions {
  final bool? flatten;

  const PDFFormFillOptions({
    this.flatten,
  });

  String toJson() => jsonEncode({
        if (flatten != null) 'flatten': flatten,
      });
}

class PDFSignature {
  final dynamic image; // String (URL) or Uint8List (bytes)
  final String? text;
  final int page;
  final double x;
  final double y;
  final double width;
  final double height;

  const PDFSignature({
    this.image,
    this.text,
    required this.page,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
        if (image != null) 'image': image,
        if (text != null) 'text': text,
        'page': page,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };
}

class PDFCertificate {
  final Uint8List pfx;
  final String password;

  const PDFCertificate({
    required this.pfx,
    required this.password,
  });
}

// Data classes

class PDFDocument {
  final String id;
  final String url;
  final int pages;
  final int size;
  final PDFMetadata? metadata;
  final DateTime createdAt;

  const PDFDocument({
    required this.id,
    required this.url,
    required this.pages,
    required this.size,
    this.metadata,
    required this.createdAt,
  });

  factory PDFDocument.fromJson(Map<String, dynamic> json) => PDFDocument(
        id: json['id'],
        url: json['url'],
        pages: json['pages'],
        size: json['size'],
        metadata: json['metadata'] != null
            ? PDFMetadata.fromJson(json['metadata'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
      );
}

class PDFMetadata {
  final String? title;
  final String? author;
  final String? subject;
  final List<String>? keywords;
  final String? creator;
  final String? producer;
  final DateTime? creationDate;
  final DateTime? modificationDate;

  const PDFMetadata({
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator,
    this.producer,
    this.creationDate,
    this.modificationDate,
  });

  factory PDFMetadata.fromJson(Map<String, dynamic> json) => PDFMetadata(
        title: json['title'],
        author: json['author'],
        subject: json['subject'],
        keywords: (json['keywords'] as List?)?.cast<String>(),
        creator: json['creator'],
        producer: json['producer'],
        creationDate: json['creationDate'] != null
            ? DateTime.parse(json['creationDate'])
            : null,
        modificationDate: json['modificationDate'] != null
            ? DateTime.parse(json['modificationDate'])
            : null,
      );
}

class PDFInfo {
  final int pages;
  final int size;
  final bool encrypted;
  final Map<String, dynamic> metadata;
  final List<PDFPageInfo> pageInfo;

  const PDFInfo({
    required this.pages,
    required this.size,
    required this.encrypted,
    required this.metadata,
    required this.pageInfo,
  });

  factory PDFInfo.fromJson(Map<String, dynamic> json) => PDFInfo(
        pages: json['pages'],
        size: json['size'],
        encrypted: json['encrypted'],
        metadata: json['metadata'],
        pageInfo: (json['pageInfo'] as List)
            .map((e) => PDFPageInfo.fromJson(e))
            .toList(),
      );
}

class PDFPageInfo {
  final int pageNumber;
  final double width;
  final double height;
  final double rotation;
  final String? text;
  final List<PDFImage>? images;
  final List<PDFLink>? links;

  const PDFPageInfo({
    required this.pageNumber,
    required this.width,
    required this.height,
    required this.rotation,
    this.text,
    this.images,
    this.links,
  });

  factory PDFPageInfo.fromJson(Map<String, dynamic> json) => PDFPageInfo(
        pageNumber: json['pageNumber'],
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        rotation: json['rotation'].toDouble(),
        text: json['text'],
        images: json['images'] != null
            ? (json['images'] as List).map((e) => PDFImage.fromJson(e)).toList()
            : null,
        links: json['links'] != null
            ? (json['links'] as List).map((e) => PDFLink.fromJson(e)).toList()
            : null,
      );
}

class PDFImage {
  final double x;
  final double y;
  final double width;
  final double height;
  final String? url;

  const PDFImage({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.url,
  });

  factory PDFImage.fromJson(Map<String, dynamic> json) => PDFImage(
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        url: json['url'],
      );
}

class PDFLink {
  final double x;
  final double y;
  final double width;
  final double height;
  final String url;

  const PDFLink({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.url,
  });

  factory PDFLink.fromJson(Map<String, dynamic> json) => PDFLink(
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        url: json['url'],
      );
}

class PDFPageImage {
  final int page;
  final String url;
  final double width;
  final double height;

  const PDFPageImage({
    required this.page,
    required this.url,
    required this.width,
    required this.height,
  });

  factory PDFPageImage.fromJson(Map<String, dynamic> json) => PDFPageImage(
        page: json['page'],
        url: json['url'],
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
      );
}
