import 'dart:async';
import '../utils/http_client.dart';
import '../common/types.dart';
import 'email_types.dart';

/// Email module for sending emails, managing templates, contacts, and campaigns
class EmailModule {
  final HttpClient _httpClient;

  EmailModule(this._httpClient);

  // Send email methods

  /// Send a single email
  Future<EmailResponse> sendEmail({
    required List<EmailRecipient> to,
    required String subject,
    String? text,
    String? html,
    String? from,
    List<EmailRecipient>? cc,
    List<EmailRecipient>? bcc,
    List<EmailAttachment>? attachments,
    Map<String, String>? headers,
    Map<String, String>? tags,
    Map<String, dynamic>? metadata,
    EmailTemplate? template,
    Priority priority = Priority.normal,
    DateTime? sendAt,
  }) async {
    final response = await _httpClient.post('/email/send', data: {
      'to': to.map((r) => r.toJson()).toList(),
      'subject': subject,
      if (text != null) 'text': text,
      if (html != null) 'html': html,
      if (from != null) 'from': from,
      if (cc != null) 'cc': cc.map((r) => r.toJson()).toList(),
      if (bcc != null) 'bcc': bcc.map((r) => r.toJson()).toList(),
      if (attachments != null)
        'attachments': attachments.map((a) => a.toJson()).toList(),
      if (headers != null) 'headers': headers,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
      if (template != null) 'template': template.toJson(),
      'priority': priority.name,
      if (sendAt != null) 'sendAt': sendAt.toIso8601String(),
    });

    return EmailResponse.fromJson(response.data);
  }

  /// Send bulk emails
  Future<BulkEmailResponse> sendBulkEmail({
    required List<BulkEmailItem> emails,
    String? from,
    List<EmailRecipient>? cc,
    List<EmailRecipient>? bcc,
    Map<String, String>? headers,
    Priority priority = Priority.normal,
    DateTime? sendAt,
  }) async {
    final response = await _httpClient.post('/email/send-bulk', data: {
      'emails': emails.map((e) => e.toJson()).toList(),
      if (from != null) 'from': from,
      if (cc != null) 'cc': cc.map((r) => r.toJson()).toList(),
      if (bcc != null) 'bcc': bcc.map((r) => r.toJson()).toList(),
      if (headers != null) 'headers': headers,
      'priority': priority.name,
      if (sendAt != null) 'sendAt': sendAt.toIso8601String(),
    });

    return BulkEmailResponse.fromJson(response.data);
  }

  /// Send email using template
  Future<EmailResponse> sendTemplateEmail({
    required String templateId,
    required List<EmailRecipient> to,
    String? from,
    Map<String, dynamic>? variables,
    List<EmailRecipient>? cc,
    List<EmailRecipient>? bcc,
    List<EmailAttachment>? attachments,
    Map<String, String>? headers,
    Map<String, String>? tags,
    Map<String, dynamic>? metadata,
    Priority priority = Priority.normal,
    DateTime? sendAt,
  }) async {
    final response = await _httpClient.post('/email/send-template', data: {
      'templateId': templateId,
      'to': to.map((r) => r.toJson()).toList(),
      if (from != null) 'from': from,
      if (variables != null) 'variables': variables,
      if (cc != null) 'cc': cc.map((r) => r.toJson()).toList(),
      if (bcc != null) 'bcc': bcc.map((r) => r.toJson()).toList(),
      if (attachments != null)
        'attachments': attachments.map((a) => a.toJson()).toList(),
      if (headers != null) 'headers': headers,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
      'priority': priority.name,
      if (sendAt != null) 'sendAt': sendAt.toIso8601String(),
    });

    return EmailResponse.fromJson(response.data);
  }

  // Email status and tracking

  /// Get email status
  Future<EmailStatus> getEmailStatus(String emailId) async {
    final response = await _httpClient.get('/email/$emailId/status');
    return EmailStatus.fromJson(response.data);
  }

  /// Get bulk email status
  Future<BulkEmailStatus> getBulkEmailStatus(String batchId) async {
    final response = await _httpClient.get('/email/bulk/$batchId/status');
    return BulkEmailStatus.fromJson(response.data);
  }

  /// Get email events
  Future<EmailEventsResponse> getEmailEvents(
    String emailId, {
    List<EmailEventType>? types,
    int? limit,
    int? offset,
  }) async {
    final response = await _httpClient.get(
      '/email/$emailId/events',
      params: {
        if (types != null) 'types': types.map((t) => t.name).toList(),
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return EmailEventsResponse.fromJson(response.data);
  }

  // Email templates

  /// Create email template
  Future<EmailTemplateResponse> createTemplate({
    required String name,
    required String subject,
    String? text,
    String? html,
    List<TemplateVariable>? variables,
    String? category,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _httpClient.post('/email/templates', data: {
      'name': name,
      'subject': subject,
      if (text != null) 'text': text,
      if (html != null) 'html': html,
      if (variables != null)
        'variables': variables.map((v) => v.toJson()).toList(),
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
    });

    return EmailTemplateResponse.fromJson(response.data);
  }

  /// Update email template
  Future<EmailTemplateResponse> updateTemplate(
    String templateId, {
    String? name,
    String? subject,
    String? text,
    String? html,
    List<TemplateVariable>? variables,
    String? category,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    final response =
        await _httpClient.patch('/email/templates/$templateId', data: {
      if (name != null) 'name': name,
      if (subject != null) 'subject': subject,
      if (text != null) 'text': text,
      if (html != null) 'html': html,
      if (variables != null)
        'variables': variables.map((v) => v.toJson()).toList(),
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
    });

    return EmailTemplateResponse.fromJson(response.data);
  }

  /// Get email template
  Future<EmailTemplateResponse> getTemplate(String templateId) async {
    final response = await _httpClient.get('/email/templates/$templateId');
    return EmailTemplateResponse.fromJson(response.data);
  }

  /// List email templates
  Future<EmailTemplateList> listTemplates({
    String? category,
    List<String>? tags,
    String? search,
    int? limit,
    int? offset,
    String? sortBy,
    SortOrder? sortOrder,
  }) async {
    final response = await _httpClient.get(
      '/email/templates',
      params: {
        if (category != null) 'category': category,
        if (tags != null) 'tags': tags,
        if (search != null) 'search': search,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder.name,
      },
    );

    return EmailTemplateList.fromJson(response.data);
  }

  /// Delete email template
  Future<void> deleteTemplate(String templateId) async {
    await _httpClient.delete('/email/templates/$templateId');
  }

  /// Preview email template
  Future<EmailPreview> previewTemplate(
    String templateId,
    Map<String, dynamic>? variables,
  ) async {
    final response = await _httpClient.post(
      '/email/templates/$templateId/preview',
      data: {'variables': variables ?? {}},
    );

    return EmailPreview.fromJson(response.data);
  }

  /// Test email template
  Future<TestEmailResponse> testTemplate(
    String templateId, {
    required String to,
    Map<String, dynamic>? variables,
  }) async {
    final response = await _httpClient.post(
      '/email/templates/$templateId/test',
      data: {
        'to': to,
        if (variables != null) 'variables': variables,
      },
    );

    return TestEmailResponse.fromJson(response.data);
  }

  // Contact management

  /// Create email contact
  Future<EmailContact> createContact({
    required String email,
    String? name,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    List<String>? lists,
    bool subscribed = true,
  }) async {
    final response = await _httpClient.post('/email/contacts', data: {
      'email': email,
      if (name != null) 'name': name,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
      if (lists != null) 'lists': lists,
      'subscribed': subscribed,
    });

    return EmailContact.fromJson(response.data);
  }

  /// Update email contact
  Future<EmailContact> updateContact(
    String contactId, {
    String? name,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    bool? subscribed,
  }) async {
    final response =
        await _httpClient.patch('/email/contacts/$contactId', data: {
      if (name != null) 'name': name,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
      if (subscribed != null) 'subscribed': subscribed,
    });

    return EmailContact.fromJson(response.data);
  }

  /// Get email contact
  Future<EmailContact> getContact(String contactId) async {
    final response = await _httpClient.get('/email/contacts/$contactId');
    return EmailContact.fromJson(response.data);
  }

  /// List email contacts
  Future<EmailContactList> listContacts({
    bool? subscribed,
    List<String>? tags,
    String? search,
    int? limit,
    int? offset,
    String? sortBy,
    SortOrder? sortOrder,
  }) async {
    final response = await _httpClient.get(
      '/email/contacts',
      params: {
        if (subscribed != null) 'subscribed': subscribed,
        if (tags != null) 'tags': tags,
        if (search != null) 'search': search,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder.name,
      },
    );

    return EmailContactList.fromJson(response.data);
  }

  /// Delete email contact
  Future<void> deleteContact(String contactId) async {
    await _httpClient.delete('/email/contacts/$contactId');
  }

  /// Subscribe contact
  Future<void> subscribeContact(String contactId) async {
    await _httpClient.post('/email/contacts/$contactId/subscribe');
  }

  /// Unsubscribe contact
  Future<void> unsubscribeContact(String contactId) async {
    await _httpClient.post('/email/contacts/$contactId/unsubscribe');
  }

  // Email lists

  /// Create email list
  Future<EmailList> createList({
    required String name,
    String? description,
    List<String>? tags,
  }) async {
    final response = await _httpClient.post('/email/lists', data: {
      'name': name,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
    });

    return EmailList.fromJson(response.data);
  }

  /// Update email list
  Future<EmailList> updateList(
    String listId, {
    String? name,
    String? description,
    List<String>? tags,
  }) async {
    final response = await _httpClient.patch('/email/lists/$listId', data: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
    });

    return EmailList.fromJson(response.data);
  }

  /// Get email list
  Future<EmailList> getList(String listId) async {
    final response = await _httpClient.get('/email/lists/$listId');
    return EmailList.fromJson(response.data);
  }

  /// List email lists
  Future<List<EmailList>> listLists() async {
    final response = await _httpClient.get('/email/lists');
    return (response.data as List)
        .map((item) => EmailList.fromJson(item))
        .toList();
  }

  /// Delete email list
  Future<void> deleteList(String listId) async {
    await _httpClient.delete('/email/lists/$listId');
  }

  /// Add contact to list
  Future<void> addContactToList(String listId, String contactId) async {
    await _httpClient.post('/email/lists/$listId/contacts', data: {
      'contactId': contactId,
    });
  }

  /// Remove contact from list
  Future<void> removeContactFromList(String listId, String contactId) async {
    await _httpClient.delete('/email/lists/$listId/contacts/$contactId');
  }

  /// Get list contacts
  Future<EmailContactList> getListContacts(
    String listId, {
    int? limit,
    int? offset,
  }) async {
    final response = await _httpClient.get(
      '/email/lists/$listId/contacts',
      params: {
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return EmailContactList.fromJson(response.data);
  }

  // Email campaigns

  /// Create email campaign
  Future<EmailCampaign> createCampaign({
    required String name,
    required String subject,
    String? templateId,
    String? text,
    String? html,
    List<String>? lists,
    List<String>? tags,
    DateTime? sendAt,
    String? timezone,
  }) async {
    final response = await _httpClient.post('/email/campaigns', data: {
      'name': name,
      'subject': subject,
      if (templateId != null) 'templateId': templateId,
      if (text != null) 'text': text,
      if (html != null) 'html': html,
      if (lists != null) 'lists': lists,
      if (tags != null) 'tags': tags,
      if (sendAt != null) 'sendAt': sendAt.toIso8601String(),
      if (timezone != null) 'timezone': timezone,
    });

    return EmailCampaign.fromJson(response.data);
  }

  /// Update email campaign
  Future<EmailCampaign> updateCampaign(
    String campaignId, {
    String? name,
    String? subject,
    String? templateId,
    String? text,
    String? html,
    List<String>? lists,
    List<String>? tags,
    DateTime? sendAt,
    String? timezone,
  }) async {
    final response =
        await _httpClient.patch('/email/campaigns/$campaignId', data: {
      if (name != null) 'name': name,
      if (subject != null) 'subject': subject,
      if (templateId != null) 'templateId': templateId,
      if (text != null) 'text': text,
      if (html != null) 'html': html,
      if (lists != null) 'lists': lists,
      if (tags != null) 'tags': tags,
      if (sendAt != null) 'sendAt': sendAt.toIso8601String(),
      if (timezone != null) 'timezone': timezone,
    });

    return EmailCampaign.fromJson(response.data);
  }

  /// Get email campaign
  Future<EmailCampaign> getCampaign(String campaignId) async {
    final response = await _httpClient.get('/email/campaigns/$campaignId');
    return EmailCampaign.fromJson(response.data);
  }

  /// List email campaigns
  Future<EmailCampaignList> listCampaigns({
    CampaignStatus? status,
    int? limit,
    int? offset,
  }) async {
    final response = await _httpClient.get(
      '/email/campaigns',
      params: {
        if (status != null) 'status': status.name,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return EmailCampaignList.fromJson(response.data);
  }

  /// Send email campaign
  Future<CampaignLaunchResponse> sendCampaign(String campaignId) async {
    final response =
        await _httpClient.post('/email/campaigns/$campaignId/send');
    return CampaignLaunchResponse.fromJson(response.data);
  }

  /// Cancel email campaign
  Future<void> cancelCampaign(String campaignId) async {
    await _httpClient.post('/email/campaigns/$campaignId/cancel');
  }

  /// Delete email campaign
  Future<void> deleteCampaign(String campaignId) async {
    await _httpClient.delete('/email/campaigns/$campaignId');
  }

  // Analytics and reporting

  /// Get email analytics
  Future<EmailAnalytics> getEmailAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _httpClient.get(
      '/email/analytics',
      params: {
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      },
    );

    return EmailAnalytics.fromJson(response.data);
  }

  /// Get domain reputation
  Future<DomainReputation> getDomainReputation() async {
    final response = await _httpClient.get('/email/reputation');
    return DomainReputation.fromJson(response.data);
  }

  /// Get suppression list
  Future<SuppressionList> getSuppressionList({
    SuppressionType? type,
    int? limit,
    int? offset,
  }) async {
    final response = await _httpClient.get(
      '/email/suppressions',
      params: {
        if (type != null) 'type': type.name,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return SuppressionList.fromJson(response.data);
  }

  /// Remove from suppression list
  Future<void> removeFromSuppressionList(String email) async {
    await _httpClient.delete('/email/suppressions/$email');
  }
}
