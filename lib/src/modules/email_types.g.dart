// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailResponse _$EmailResponseFromJson(Map<String, dynamic> json) =>
    EmailResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      messageId: json['message_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EmailResponseToJson(EmailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'message_id': instance.messageId,
      'created_at': instance.createdAt.toIso8601String(),
    };

BulkEmailItem _$BulkEmailItemFromJson(Map<String, dynamic> json) =>
    BulkEmailItem(
      to: (json['to'] as List<dynamic>)
          .map((e) => EmailRecipient.fromJson(e as Map<String, dynamic>))
          .toList(),
      subject: json['subject'] as String,
      text: json['text'] as String?,
      html: json['html'] as String?,
      template: json['template'] == null
          ? null
          : EmailTemplate.fromJson(json['template'] as Map<String, dynamic>),
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BulkEmailItemToJson(BulkEmailItem instance) =>
    <String, dynamic>{
      'to': instance.to,
      'subject': instance.subject,
      'text': instance.text,
      'html': instance.html,
      'template': instance.template,
      'tags': instance.tags,
      'metadata': instance.metadata,
    };

BulkEmailResponse _$BulkEmailResponseFromJson(Map<String, dynamic> json) =>
    BulkEmailResponse(
      batchId: json['batch_id'] as String,
      totalEmails: (json['total_emails'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BulkEmailResponseToJson(BulkEmailResponse instance) =>
    <String, dynamic>{
      'batch_id': instance.batchId,
      'total_emails': instance.totalEmails,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };

EmailStatus _$EmailStatusFromJson(Map<String, dynamic> json) => EmailStatus(
      id: json['id'] as String,
      status: json['status'] as String,
      messageId: json['message_id'] as String?,
      sentAt: json['sent_at'] == null
          ? null
          : DateTime.parse(json['sent_at'] as String),
      deliveredAt: json['delivered_at'] == null
          ? null
          : DateTime.parse(json['delivered_at'] as String),
      openedAt: json['opened_at'] == null
          ? null
          : DateTime.parse(json['opened_at'] as String),
      clickedAt: json['clicked_at'] == null
          ? null
          : DateTime.parse(json['clicked_at'] as String),
      bouncedAt: json['bounced_at'] == null
          ? null
          : DateTime.parse(json['bounced_at'] as String),
      failedAt: json['failed_at'] == null
          ? null
          : DateTime.parse(json['failed_at'] as String),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$EmailStatusToJson(EmailStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'message_id': instance.messageId,
      'sent_at': instance.sentAt?.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'opened_at': instance.openedAt?.toIso8601String(),
      'clicked_at': instance.clickedAt?.toIso8601String(),
      'bounced_at': instance.bouncedAt?.toIso8601String(),
      'failed_at': instance.failedAt?.toIso8601String(),
      'error': instance.error,
    };

BulkEmailStatus _$BulkEmailStatusFromJson(Map<String, dynamic> json) =>
    BulkEmailStatus(
      batchId: json['batch_id'] as String,
      status: json['status'] as String,
      totalEmails: (json['total_emails'] as num).toInt(),
      sentCount: (json['sent_count'] as num).toInt(),
      failedCount: (json['failed_count'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$BulkEmailStatusToJson(BulkEmailStatus instance) =>
    <String, dynamic>{
      'batch_id': instance.batchId,
      'status': instance.status,
      'total_emails': instance.totalEmails,
      'sent_count': instance.sentCount,
      'failed_count': instance.failedCount,
      'created_at': instance.createdAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };

EmailEvent _$EmailEventFromJson(Map<String, dynamic> json) => EmailEvent(
      id: json['id'] as String,
      type: $enumDecode(_$EmailEventTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$EmailEventToJson(EmailEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$EmailEventTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$EmailEventTypeEnumMap = {
  EmailEventType.queued: 'queued',
  EmailEventType.sent: 'sent',
  EmailEventType.delivered: 'delivered',
  EmailEventType.opened: 'opened',
  EmailEventType.clicked: 'clicked',
  EmailEventType.bounced: 'bounced',
  EmailEventType.failed: 'failed',
  EmailEventType.spam: 'spam',
  EmailEventType.unsubscribed: 'unsubscribed',
};

EmailEventsResponse _$EmailEventsResponseFromJson(Map<String, dynamic> json) =>
    EmailEventsResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => EmailEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$EmailEventsResponseToJson(
        EmailEventsResponse instance) =>
    <String, dynamic>{
      'events': instance.events,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

TemplateVariable _$TemplateVariableFromJson(Map<String, dynamic> json) =>
    TemplateVariable(
      name: json['name'] as String,
      type: json['type'] as String,
      required: json['required'] as bool,
      defaultValue: json['defaultValue'],
    );

Map<String, dynamic> _$TemplateVariableToJson(TemplateVariable instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'required': instance.required,
      'defaultValue': instance.defaultValue,
    };

EmailTemplateResponse _$EmailTemplateResponseFromJson(
        Map<String, dynamic> json) =>
    EmailTemplateResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      text: json['text'] as String?,
      html: json['html'] as String?,
      variables: (json['variables'] as List<dynamic>?)
          ?.map((e) => TemplateVariable.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$EmailTemplateResponseToJson(
        EmailTemplateResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subject': instance.subject,
      'text': instance.text,
      'html': instance.html,
      'variables': instance.variables,
      'category': instance.category,
      'tags': instance.tags,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

EmailTemplateList _$EmailTemplateListFromJson(Map<String, dynamic> json) =>
    EmailTemplateList(
      templates: (json['templates'] as List<dynamic>)
          .map((e) => EmailTemplateResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$EmailTemplateListToJson(EmailTemplateList instance) =>
    <String, dynamic>{
      'templates': instance.templates,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

ContactList _$ContactListFromJson(Map<String, dynamic> json) => ContactList(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      contactCount: (json['contact_count'] as num).toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ContactListToJson(ContactList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'contact_count': instance.contactCount,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ContactListResponse _$ContactListResponseFromJson(Map<String, dynamic> json) =>
    ContactListResponse(
      lists: (json['lists'] as List<dynamic>)
          .map((e) => ContactList.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$ContactListResponseToJson(
        ContactListResponse instance) =>
    <String, dynamic>{
      'lists': instance.lists,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

EmailContactList _$EmailContactListFromJson(Map<String, dynamic> json) =>
    EmailContactList(
      contacts: (json['contacts'] as List<dynamic>)
          .map((e) => EmailContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$EmailContactListToJson(EmailContactList instance) =>
    <String, dynamic>{
      'contacts': instance.contacts,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

EmailPreview _$EmailPreviewFromJson(Map<String, dynamic> json) => EmailPreview(
      subject: json['subject'] as String,
      text: json['text'] as String?,
      html: json['html'] as String?,
      headers: json['headers'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$EmailPreviewToJson(EmailPreview instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'text': instance.text,
      'html': instance.html,
      'headers': instance.headers,
    };

TestEmailResponse _$TestEmailResponseFromJson(Map<String, dynamic> json) =>
    TestEmailResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TestEmailResponseToJson(TestEmailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'details': instance.details,
    };

EmailCampaignList _$EmailCampaignListFromJson(Map<String, dynamic> json) =>
    EmailCampaignList(
      campaigns: (json['campaigns'] as List<dynamic>)
          .map((e) => EmailCampaign.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$EmailCampaignListToJson(EmailCampaignList instance) =>
    <String, dynamic>{
      'campaigns': instance.campaigns,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

CampaignLaunchResponse _$CampaignLaunchResponseFromJson(
        Map<String, dynamic> json) =>
    CampaignLaunchResponse(
      campaignId: json['campaignId'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      launchedAt: DateTime.parse(json['launched_at'] as String),
    );

Map<String, dynamic> _$CampaignLaunchResponseToJson(
        CampaignLaunchResponse instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
      'status': instance.status,
      'message': instance.message,
      'launched_at': instance.launchedAt.toIso8601String(),
    };

EmailCampaignStats _$EmailCampaignStatsFromJson(Map<String, dynamic> json) =>
    EmailCampaignStats(
      totalRecipients: (json['total_recipients'] as num).toInt(),
      sent: (json['sent'] as num).toInt(),
      delivered: (json['delivered'] as num).toInt(),
      opened: (json['opened'] as num).toInt(),
      clicked: (json['clicked'] as num).toInt(),
      bounced: (json['bounced'] as num).toInt(),
      failed: (json['failed'] as num).toInt(),
      unsubscribed: (json['unsubscribed'] as num).toInt(),
      spamComplaints: (json['spam_complaints'] as num).toInt(),
    );

Map<String, dynamic> _$EmailCampaignStatsToJson(EmailCampaignStats instance) =>
    <String, dynamic>{
      'total_recipients': instance.totalRecipients,
      'sent': instance.sent,
      'delivered': instance.delivered,
      'opened': instance.opened,
      'clicked': instance.clicked,
      'bounced': instance.bounced,
      'failed': instance.failed,
      'unsubscribed': instance.unsubscribed,
      'spam_complaints': instance.spamComplaints,
    };

EmailAnalyticsData _$EmailAnalyticsDataFromJson(Map<String, dynamic> json) =>
    EmailAnalyticsData(
      overview: json['overview'] as Map<String, dynamic>,
      byDomain: json['byDomain'] as Map<String, dynamic>,
      byDevice: json['byDevice'] as Map<String, dynamic>,
      byLocation: json['byLocation'] as Map<String, dynamic>,
      timeline: json['timeline'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$EmailAnalyticsDataToJson(EmailAnalyticsData instance) =>
    <String, dynamic>{
      'overview': instance.overview,
      'byDomain': instance.byDomain,
      'byDevice': instance.byDevice,
      'byLocation': instance.byLocation,
      'timeline': instance.timeline,
    };
