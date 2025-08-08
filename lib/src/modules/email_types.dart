import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../common/types.dart';

part 'email_types.g.dart';

/// Email priority levels
enum Priority {
  low,
  normal,
  high,
}

/// Email event types
enum EmailEventType {
  queued,
  sent,
  delivered,
  opened,
  clicked,
  bounced,
  failed,
  spam,
  unsubscribed,
}

/// Email response
@JsonSerializable()
class EmailResponse extends Equatable {
  final String id;
  final String status;
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const EmailResponse({
    required this.id,
    required this.status,
    required this.messageId,
    required this.createdAt,
  });

  factory EmailResponse.fromJson(Map<String, dynamic> json) =>
      _$EmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailResponseToJson(this);

  @override
  List<Object?> get props => [id, status, messageId, createdAt];
}

/// Bulk email item
@JsonSerializable()
class BulkEmailItem extends Equatable {
  final List<EmailRecipient> to;
  final String subject;
  final String? text;
  final String? html;
  final EmailTemplate? template;
  final Map<String, String>? tags;
  final Map<String, dynamic>? metadata;

  const BulkEmailItem({
    required this.to,
    required this.subject,
    this.text,
    this.html,
    this.template,
    this.tags,
    this.metadata,
  });

  factory BulkEmailItem.fromJson(Map<String, dynamic> json) =>
      _$BulkEmailItemFromJson(json);

  Map<String, dynamic> toJson() => _$BulkEmailItemToJson(this);

  @override
  List<Object?> get props =>
      [to, subject, text, html, template, tags, metadata];
}

/// Bulk email response
@JsonSerializable()
class BulkEmailResponse extends Equatable {
  @JsonKey(name: 'batch_id')
  final String batchId;
  @JsonKey(name: 'total_emails')
  final int totalEmails;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const BulkEmailResponse({
    required this.batchId,
    required this.totalEmails,
    required this.status,
    required this.createdAt,
  });

  factory BulkEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BulkEmailResponseToJson(this);

  @override
  List<Object?> get props => [batchId, totalEmails, status, createdAt];
}

/// Email status
@JsonSerializable()
class EmailStatus extends Equatable {
  final String id;
  final String status;
  @JsonKey(name: 'message_id')
  final String? messageId;
  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;
  @JsonKey(name: 'opened_at')
  final DateTime? openedAt;
  @JsonKey(name: 'clicked_at')
  final DateTime? clickedAt;
  @JsonKey(name: 'bounced_at')
  final DateTime? bouncedAt;
  @JsonKey(name: 'failed_at')
  final DateTime? failedAt;
  final String? error;

  const EmailStatus({
    required this.id,
    required this.status,
    this.messageId,
    this.sentAt,
    this.deliveredAt,
    this.openedAt,
    this.clickedAt,
    this.bouncedAt,
    this.failedAt,
    this.error,
  });

  factory EmailStatus.fromJson(Map<String, dynamic> json) =>
      _$EmailStatusFromJson(json);

  Map<String, dynamic> toJson() => _$EmailStatusToJson(this);

  @override
  List<Object?> get props => [
        id,
        status,
        messageId,
        sentAt,
        deliveredAt,
        openedAt,
        clickedAt,
        bouncedAt,
        failedAt,
        error,
      ];
}

/// Bulk email status
@JsonSerializable()
class BulkEmailStatus extends Equatable {
  @JsonKey(name: 'batch_id')
  final String batchId;
  final String status;
  @JsonKey(name: 'total_emails')
  final int totalEmails;
  @JsonKey(name: 'sent_count')
  final int sentCount;
  @JsonKey(name: 'failed_count')
  final int failedCount;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  const BulkEmailStatus({
    required this.batchId,
    required this.status,
    required this.totalEmails,
    required this.sentCount,
    required this.failedCount,
    required this.createdAt,
    this.completedAt,
  });

  factory BulkEmailStatus.fromJson(Map<String, dynamic> json) =>
      _$BulkEmailStatusFromJson(json);

  Map<String, dynamic> toJson() => _$BulkEmailStatusToJson(this);

  @override
  List<Object?> get props => [
        batchId,
        status,
        totalEmails,
        sentCount,
        failedCount,
        createdAt,
        completedAt,
      ];
}

/// Email event
@JsonSerializable()
class EmailEvent extends Equatable {
  final String id;
  final EmailEventType type;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const EmailEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    this.metadata,
  });

  factory EmailEvent.fromJson(Map<String, dynamic> json) =>
      _$EmailEventFromJson(json);

  Map<String, dynamic> toJson() => _$EmailEventToJson(this);

  @override
  List<Object?> get props => [id, type, timestamp, metadata];
}

/// Email events response
@JsonSerializable()
class EmailEventsResponse extends Equatable {
  final List<EmailEvent> events;
  final int total;
  final int limit;
  final int offset;

  const EmailEventsResponse({
    required this.events,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory EmailEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$EmailEventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailEventsResponseToJson(this);

  @override
  List<Object?> get props => [events, total, limit, offset];
}

/// Template variable
@JsonSerializable()
class TemplateVariable extends Equatable {
  final String name;
  final String type;
  final bool required;
  final dynamic defaultValue;

  const TemplateVariable({
    required this.name,
    required this.type,
    required this.required,
    this.defaultValue,
  });

  factory TemplateVariable.fromJson(Map<String, dynamic> json) =>
      _$TemplateVariableFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateVariableToJson(this);

  @override
  List<Object?> get props => [name, type, required, defaultValue];
}

/// Email template response
@JsonSerializable()
class EmailTemplateResponse extends Equatable {
  final String id;
  final String name;
  final String subject;
  final String? text;
  final String? html;
  final List<TemplateVariable>? variables;
  final String? category;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const EmailTemplateResponse({
    required this.id,
    required this.name,
    required this.subject,
    this.text,
    this.html,
    this.variables,
    this.category,
    this.tags,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmailTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$EmailTemplateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailTemplateResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        subject,
        text,
        html,
        variables,
        category,
        tags,
        metadata,
        createdAt,
        updatedAt,
      ];
}

/// Email template list response
@JsonSerializable()
class EmailTemplateList extends Equatable {
  final List<EmailTemplateResponse> templates;
  final int total;
  final int limit;
  final int offset;

  const EmailTemplateList({
    required this.templates,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory EmailTemplateList.fromJson(Map<String, dynamic> json) =>
      _$EmailTemplateListFromJson(json);

  Map<String, dynamic> toJson() => _$EmailTemplateListToJson(this);

  @override
  List<Object?> get props => [templates, total, limit, offset];
}

/// Contact list
@JsonSerializable()
class ContactList extends Equatable {
  final String id;
  final String name;
  final String? description;
  @JsonKey(name: 'contact_count')
  final int contactCount;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const ContactList({
    required this.id,
    required this.name,
    this.description,
    required this.contactCount,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactList.fromJson(Map<String, dynamic> json) =>
      _$ContactListFromJson(json);

  Map<String, dynamic> toJson() => _$ContactListToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        contactCount,
        metadata,
        createdAt,
        updatedAt,
      ];
}

/// Contact list response
@JsonSerializable()
class ContactListResponse extends Equatable {
  final List<ContactList> lists;
  final int total;
  final int limit;
  final int offset;

  const ContactListResponse({
    required this.lists,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory ContactListResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContactListResponseToJson(this);

  @override
  List<Object?> get props => [lists, total, limit, offset];
}

/// Email contact list response
@JsonSerializable()
class EmailContactList extends Equatable {
  final List<EmailContact> contacts;
  final int total;
  final int limit;
  final int offset;

  const EmailContactList({
    required this.contacts,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory EmailContactList.fromJson(Map<String, dynamic> json) =>
      _$EmailContactListFromJson(json);

  Map<String, dynamic> toJson() => _$EmailContactListToJson(this);

  @override
  List<Object?> get props => [contacts, total, limit, offset];
}

/// Email preview
@JsonSerializable()
class EmailPreview extends Equatable {
  final String subject;
  final String? text;
  final String? html;
  final Map<String, dynamic>? headers;

  const EmailPreview({
    required this.subject,
    this.text,
    this.html,
    this.headers,
  });

  factory EmailPreview.fromJson(Map<String, dynamic> json) =>
      _$EmailPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$EmailPreviewToJson(this);

  @override
  List<Object?> get props => [subject, text, html, headers];
}

/// Test email response
@JsonSerializable()
class TestEmailResponse extends Equatable {
  final bool success;
  final String message;
  final Map<String, dynamic>? details;

  const TestEmailResponse({
    required this.success,
    required this.message,
    this.details,
  });

  factory TestEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$TestEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TestEmailResponseToJson(this);

  @override
  List<Object?> get props => [success, message, details];
}

/// Email campaign list
@JsonSerializable()
class EmailCampaignList extends Equatable {
  final List<EmailCampaign> campaigns;
  final int total;
  final int limit;
  final int offset;

  const EmailCampaignList({
    required this.campaigns,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory EmailCampaignList.fromJson(Map<String, dynamic> json) =>
      _$EmailCampaignListFromJson(json);

  Map<String, dynamic> toJson() => _$EmailCampaignListToJson(this);

  @override
  List<Object?> get props => [campaigns, total, limit, offset];
}

/// Campaign status enum
enum CampaignStatus {
  draft,
  scheduled,
  sending,
  sent,
  paused,
  cancelled,
  failed,
}

/// Campaign launch response
@JsonSerializable()
class CampaignLaunchResponse extends Equatable {
  final String campaignId;
  final String status;
  final String message;
  @JsonKey(name: 'launched_at')
  final DateTime launchedAt;

  const CampaignLaunchResponse({
    required this.campaignId,
    required this.status,
    required this.message,
    required this.launchedAt,
  });

  factory CampaignLaunchResponse.fromJson(Map<String, dynamic> json) =>
      _$CampaignLaunchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignLaunchResponseToJson(this);

  @override
  List<Object?> get props => [campaignId, status, message, launchedAt];
}

/// Email campaign stats
@JsonSerializable()
class EmailCampaignStats extends Equatable {
  @JsonKey(name: 'total_recipients')
  final int totalRecipients;
  final int sent;
  final int delivered;
  final int opened;
  final int clicked;
  final int bounced;
  final int failed;
  final int unsubscribed;
  @JsonKey(name: 'spam_complaints')
  final int spamComplaints;

  const EmailCampaignStats({
    required this.totalRecipients,
    required this.sent,
    required this.delivered,
    required this.opened,
    required this.clicked,
    required this.bounced,
    required this.failed,
    required this.unsubscribed,
    required this.spamComplaints,
  });

  factory EmailCampaignStats.fromJson(Map<String, dynamic> json) =>
      _$EmailCampaignStatsFromJson(json);

  Map<String, dynamic> toJson() => _$EmailCampaignStatsToJson(this);

  @override
  List<Object?> get props => [
        totalRecipients,
        sent,
        delivered,
        opened,
        clicked,
        bounced,
        failed,
        unsubscribed,
        spamComplaints,
      ];
}

/// Email analytics data
@JsonSerializable()
class EmailAnalyticsData extends Equatable {
  final Map<String, dynamic> overview;
  final Map<String, dynamic> byDomain;
  final Map<String, dynamic> byDevice;
  final Map<String, dynamic> byLocation;
  final Map<String, dynamic> timeline;

  const EmailAnalyticsData({
    required this.overview,
    required this.byDomain,
    required this.byDevice,
    required this.byLocation,
    required this.timeline,
  });

  factory EmailAnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$EmailAnalyticsDataFromJson(json);

  Map<String, dynamic> toJson() => _$EmailAnalyticsDataToJson(this);

  @override
  List<Object?> get props =>
      [overview, byDomain, byDevice, byLocation, timeline];
}
