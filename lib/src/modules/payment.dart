import '../utils/http_client.dart';

/// Payment module for handling payment methods, transactions, subscriptions, and plans
class PaymentModule {
  final HttpClient _httpClient;

  PaymentModule(this._httpClient);

  // Payment Methods

  /// Create a new payment method
  /// [paymentMethod] - Payment method details
  /// Returns the created payment method
  Future<PaymentMethod> createPaymentMethod(
      CreatePaymentMethodRequest paymentMethod) async {
    final response = await _httpClient.post('/payment/methods',
        data: paymentMethod.toJson());
    return PaymentMethod.fromJson(response.data);
  }

  /// List payment methods
  /// [options] - Filter options
  /// Returns paginated list of payment methods
  Future<PaymentMethodListResponse> listPaymentMethods({
    String? type,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{
      if (type != null) 'type': type,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    final response =
        await _httpClient.get('/payment/methods', params: queryParams);
    return PaymentMethodListResponse.fromJson(response.data);
  }

  /// Get a payment method by ID
  /// [methodId] - Payment method ID
  /// Returns the payment method
  Future<PaymentMethod> getPaymentMethod(String methodId) async {
    final response = await _httpClient.get('/payment/methods/$methodId');
    return PaymentMethod.fromJson(response.data);
  }

  /// Update a payment method
  /// [methodId] - Payment method ID
  /// [updates] - Fields to update
  /// Returns the updated payment method
  Future<PaymentMethod> updatePaymentMethod(
    String methodId,
    UpdatePaymentMethodRequest updates,
  ) async {
    final response = await _httpClient.patch('/payment/methods/$methodId',
        data: updates.toJson());
    return PaymentMethod.fromJson(response.data);
  }

  /// Delete a payment method
  /// [methodId] - Payment method ID
  Future<void> deletePaymentMethod(String methodId) async {
    await _httpClient.delete('/payment/methods/$methodId');
  }

  // Transactions

  /// Create a new transaction
  /// [transaction] - Transaction details
  /// Returns the created transaction
  Future<PaymentTransaction> createTransaction(
      CreateTransactionRequest transaction) async {
    final response = await _httpClient.post('/payment/transactions',
        data: transaction.toJson());
    return PaymentTransaction.fromJson(response.data);
  }

  /// Capture a transaction
  /// [transactionId] - Transaction ID
  /// [amount] - Optional amount to capture (defaults to full amount)
  /// Returns the captured transaction
  Future<PaymentTransaction> captureTransaction(String transactionId,
      {double? amount}) async {
    final response = await _httpClient.post(
      '/payment/transactions/$transactionId/capture',
      data: {'amount': amount},
    );
    return PaymentTransaction.fromJson(response.data);
  }

  /// Refund a transaction
  /// [transactionId] - Transaction ID
  /// [amount] - Optional amount to refund (defaults to full amount)
  /// [reason] - Optional reason for refund
  /// Returns the refunded transaction
  Future<PaymentTransaction> refundTransaction(
    String transactionId, {
    double? amount,
    String? reason,
  }) async {
    final response = await _httpClient.post(
      '/payment/transactions/$transactionId/refund',
      data: {
        'amount': amount,
        'reason': reason,
      },
    );
    return PaymentTransaction.fromJson(response.data);
  }

  /// Get a transaction by ID
  /// [transactionId] - Transaction ID
  /// Returns the transaction
  Future<PaymentTransaction> getTransaction(String transactionId) async {
    final response =
        await _httpClient.get('/payment/transactions/$transactionId');
    return PaymentTransaction.fromJson(response.data);
  }

  /// List transactions
  /// [options] - Filter options
  /// Returns paginated list of transactions
  Future<TransactionListResponse> listTransactions({
    String? status,
    String? paymentMethodId,
    String? fromDate,
    String? toDate,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{
      if (status != null) 'status': status,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    final response =
        await _httpClient.get('/payment/transactions', params: queryParams);
    return TransactionListResponse.fromJson(response.data);
  }

  // Subscriptions

  /// Create a new subscription
  /// [subscription] - Subscription details
  /// Returns the created subscription
  Future<PaymentSubscription> createSubscription(
      CreateSubscriptionRequest subscription) async {
    final response = await _httpClient.post('/payment/subscriptions',
        data: subscription.toJson());
    return PaymentSubscription.fromJson(response.data);
  }

  /// Get a subscription by ID
  /// [subscriptionId] - Subscription ID
  /// Returns the subscription
  Future<PaymentSubscription> getSubscription(String subscriptionId) async {
    final response =
        await _httpClient.get('/payment/subscriptions/$subscriptionId');
    return PaymentSubscription.fromJson(response.data);
  }

  /// Update a subscription
  /// [subscriptionId] - Subscription ID
  /// [updates] - Fields to update
  /// Returns the updated subscription
  Future<PaymentSubscription> updateSubscription(
    String subscriptionId,
    UpdateSubscriptionRequest updates,
  ) async {
    final response = await _httpClient.patch(
        '/payment/subscriptions/$subscriptionId',
        data: updates.toJson());
    return PaymentSubscription.fromJson(response.data);
  }

  /// Pause a subscription
  /// [subscriptionId] - Subscription ID
  /// Returns the paused subscription
  Future<PaymentSubscription> pauseSubscription(String subscriptionId) async {
    final response =
        await _httpClient.post('/payment/subscriptions/$subscriptionId/pause');
    return PaymentSubscription.fromJson(response.data);
  }

  /// Resume a subscription
  /// [subscriptionId] - Subscription ID
  /// Returns the resumed subscription
  Future<PaymentSubscription> resumeSubscription(String subscriptionId) async {
    final response =
        await _httpClient.post('/payment/subscriptions/$subscriptionId/resume');
    return PaymentSubscription.fromJson(response.data);
  }

  /// Cancel a subscription
  /// [subscriptionId] - Subscription ID
  /// [immediate] - Whether to cancel immediately or at period end
  /// [reason] - Optional reason for cancellation
  /// Returns the cancelled subscription
  Future<PaymentSubscription> cancelSubscription(
    String subscriptionId, {
    bool immediate = false,
    String? reason,
  }) async {
    final response = await _httpClient.post(
      '/payment/subscriptions/$subscriptionId/cancel',
      data: {
        'immediate': immediate,
        'reason': reason,
      },
    );
    return PaymentSubscription.fromJson(response.data);
  }

  /// List subscriptions
  /// [options] - Filter options
  /// Returns paginated list of subscriptions
  Future<SubscriptionListResponse> listSubscriptions({
    String? status,
    String? planId,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{
      if (status != null) 'status': status,
      if (planId != null) 'plan_id': planId,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    final response =
        await _httpClient.get('/payment/subscriptions', params: queryParams);
    return SubscriptionListResponse.fromJson(response.data);
  }

  // Plans

  /// Create a new plan
  /// [plan] - Plan details
  /// Returns the created plan
  Future<PaymentPlan> createPlan(CreatePlanRequest plan) async {
    final response =
        await _httpClient.post('/payment/plans', data: plan.toJson());
    return PaymentPlan.fromJson(response.data);
  }

  /// Get a plan by ID
  /// [planId] - Plan ID
  /// Returns the plan
  Future<PaymentPlan> getPlan(String planId) async {
    final response = await _httpClient.get('/payment/plans/$planId');
    return PaymentPlan.fromJson(response.data);
  }

  /// Update a plan
  /// [planId] - Plan ID
  /// [updates] - Fields to update
  /// Returns the updated plan
  Future<PaymentPlan> updatePlan(
      String planId, UpdatePlanRequest updates) async {
    final response = await _httpClient.patch('/payment/plans/$planId',
        data: updates.toJson());
    return PaymentPlan.fromJson(response.data);
  }

  /// List plans
  /// [options] - Filter options
  /// Returns paginated list of plans
  Future<PlanListResponse> listPlans({
    bool? active,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{
      if (active != null) 'active': active,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    final response =
        await _httpClient.get('/payment/plans', params: queryParams);
    return PlanListResponse.fromJson(response.data);
  }

  /// Delete a plan
  /// [planId] - Plan ID
  Future<void> deletePlan(String planId) async {
    await _httpClient.delete('/payment/plans/$planId');
  }

  // Payment Links

  /// Create a payment link
  /// [link] - Payment link details
  /// Returns the created payment link
  Future<PaymentLink> createPaymentLink(CreatePaymentLinkRequest link) async {
    final response =
        await _httpClient.post('/payment/links', data: link.toJson());
    return PaymentLink.fromJson(response.data);
  }

  /// Get a payment link by ID
  /// [linkId] - Payment link ID
  /// Returns the payment link
  Future<PaymentLinkDetails> getPaymentLink(String linkId) async {
    final response = await _httpClient.get('/payment/links/$linkId');
    return PaymentLinkDetails.fromJson(response.data);
  }

  // Invoices

  /// Create an invoice
  /// [invoice] - Invoice details
  /// Returns the created invoice
  Future<PaymentInvoice> createInvoice(CreateInvoiceRequest invoice) async {
    final response =
        await _httpClient.post('/payment/invoices', data: invoice.toJson());
    return PaymentInvoice.fromJson(response.data);
  }

  /// Send an invoice
  /// [invoiceId] - Invoice ID
  Future<void> sendInvoice(String invoiceId) async {
    await _httpClient.post('/payment/invoices/$invoiceId/send');
  }

  /// Mark an invoice as paid
  /// [invoiceId] - Invoice ID
  /// [transactionId] - Optional transaction ID
  Future<void> markInvoiceAsPaid(String invoiceId,
      {String? transactionId}) async {
    await _httpClient.post(
      '/payment/invoices/$invoiceId/mark-paid',
      data: {'transaction_id': transactionId},
    );
  }

  // Webhooks

  /// Create a payment webhook
  /// [webhook] - Webhook details
  /// Returns the created webhook
  Future<PaymentWebhook> createPaymentWebhook(
      CreateWebhookRequest webhook) async {
    final response =
        await _httpClient.post('/payment/webhooks', data: webhook.toJson());
    return PaymentWebhook.fromJson(response.data);
  }

  /// Verify webhook signature
  /// [payload] - Webhook payload
  /// [signature] - Webhook signature
  /// [secret] - Webhook secret
  /// Returns true if signature is valid
  Future<bool> verifyWebhookSignature(
      String payload, String signature, String secret) async {
    // This would typically be done client-side
    // Implementation depends on the specific webhook signing algorithm
    return true;
  }

  // Analytics

  /// Get payment analytics
  /// [options] - Filter options
  /// Returns payment analytics data
  Future<PaymentAnalytics> getPaymentAnalytics({
    String? fromDate,
    String? toDate,
    String? groupBy,
  }) async {
    final queryParams = <String, dynamic>{
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (groupBy != null) 'group_by': groupBy,
    };

    final response =
        await _httpClient.get('/payment/analytics', params: queryParams);
    return PaymentAnalytics.fromJson(response.data);
  }
}

// Core Models

enum PaymentMethodType {
  card('card'),
  bankAccount('bank_account'),
  paypal('paypal'),
  stripe('stripe'),
  crypto('crypto');

  const PaymentMethodType(this.value);
  final String value;

  static PaymentMethodType fromString(String value) {
    return PaymentMethodType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown payment method type: $value'),
    );
  }
}

enum TransactionStatus {
  pending('pending'),
  processing('processing'),
  completed('completed'),
  failed('failed'),
  refunded('refunded');

  const TransactionStatus(this.value);
  final String value;

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown transaction status: $value'),
    );
  }
}

enum SubscriptionStatus {
  active('active'),
  paused('paused'),
  cancelled('cancelled'),
  expired('expired');

  const SubscriptionStatus(this.value);
  final String value;

  static SubscriptionStatus fromString(String value) {
    return SubscriptionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown subscription status: $value'),
    );
  }
}

enum PlanInterval {
  day('day'),
  week('week'),
  month('month'),
  year('year');

  const PlanInterval(this.value);
  final String value;

  static PlanInterval fromString(String value) {
    return PlanInterval.values.firstWhere(
      (interval) => interval.value == value,
      orElse: () => throw ArgumentError('Unknown plan interval: $value'),
    );
  }
}

class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final Map<String, dynamic> details;
  final bool isDefault;
  final DateTime createdAt;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.details,
    required this.isDefault,
    required this.createdAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'],
        type: PaymentMethodType.fromString(json['type']),
        details: json['details'],
        isDefault: json['default'] ?? false,
        createdAt: DateTime.parse(json['created_at']),
      );
}

class PaymentTransaction {
  final String id;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final String paymentMethodId;
  final String? description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? error;

  const PaymentTransaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethodId,
    this.description,
    this.metadata,
    required this.createdAt,
    this.completedAt,
    this.error,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) =>
      PaymentTransaction(
        id: json['id'],
        amount: json['amount'].toDouble(),
        currency: json['currency'],
        status: TransactionStatus.fromString(json['status']),
        paymentMethodId: json['payment_method_id'],
        description: json['description'],
        metadata: json['metadata'],
        createdAt: DateTime.parse(json['created_at']),
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'])
            : null,
        error: json['error'],
      );
}

class PaymentSubscription {
  final String id;
  final String planId;
  final SubscriptionStatus status;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final String paymentMethodId;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? cancelledAt;

  const PaymentSubscription({
    required this.id,
    required this.planId,
    required this.status,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.paymentMethodId,
    this.metadata,
    required this.createdAt,
    this.cancelledAt,
  });

  factory PaymentSubscription.fromJson(Map<String, dynamic> json) =>
      PaymentSubscription(
        id: json['id'],
        planId: json['plan_id'],
        status: SubscriptionStatus.fromString(json['status']),
        currentPeriodStart: DateTime.parse(json['current_period_start']),
        currentPeriodEnd: DateTime.parse(json['current_period_end']),
        paymentMethodId: json['payment_method_id'],
        metadata: json['metadata'],
        createdAt: DateTime.parse(json['created_at']),
        cancelledAt: json['cancelled_at'] != null
            ? DateTime.parse(json['cancelled_at'])
            : null,
      );
}

class PaymentPlan {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final PlanInterval interval;
  final int intervalCount;
  final List<String>? features;
  final Map<String, dynamic>? metadata;
  final bool active;
  final DateTime createdAt;

  const PaymentPlan({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.interval,
    required this.intervalCount,
    this.features,
    this.metadata,
    required this.active,
    required this.createdAt,
  });

  factory PaymentPlan.fromJson(Map<String, dynamic> json) => PaymentPlan(
        id: json['id'],
        name: json['name'],
        amount: json['amount'].toDouble(),
        currency: json['currency'],
        interval: PlanInterval.fromString(json['interval']),
        intervalCount: json['interval_count'],
        features: (json['features'] as List?)?.cast<String>(),
        metadata: json['metadata'],
        active: json['active'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

// Request/Response classes

class CreatePaymentMethodRequest {
  final PaymentMethodType type;
  final Map<String, dynamic> details;
  final bool isDefault;
  final Map<String, dynamic>? metadata;

  const CreatePaymentMethodRequest({
    required this.type,
    required this.details,
    this.isDefault = false,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'type': type.value,
        'details': details,
        'default': isDefault,
        if (metadata != null) 'metadata': metadata,
      };
}

class UpdatePaymentMethodRequest {
  final bool? isDefault;
  final Map<String, dynamic>? metadata;

  const UpdatePaymentMethodRequest({
    this.isDefault,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        if (isDefault != null) 'default': isDefault,
        if (metadata != null) 'metadata': metadata,
      };
}

class CreateTransactionRequest {
  final double amount;
  final String currency;
  final String paymentMethodId;
  final String? description;
  final bool capture;
  final Map<String, dynamic>? metadata;

  const CreateTransactionRequest({
    required this.amount,
    required this.currency,
    required this.paymentMethodId,
    this.description,
    this.capture = true,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'payment_method_id': paymentMethodId,
        if (description != null) 'description': description,
        'capture': capture,
        if (metadata != null) 'metadata': metadata,
      };
}

class CreateSubscriptionRequest {
  final String planId;
  final String paymentMethodId;
  final int? trialDays;
  final Map<String, dynamic>? metadata;

  const CreateSubscriptionRequest({
    required this.planId,
    required this.paymentMethodId,
    this.trialDays,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'plan_id': planId,
        'payment_method_id': paymentMethodId,
        if (trialDays != null) 'trial_days': trialDays,
        if (metadata != null) 'metadata': metadata,
      };
}

class UpdateSubscriptionRequest {
  final String? planId;
  final String? paymentMethodId;
  final Map<String, dynamic>? metadata;

  const UpdateSubscriptionRequest({
    this.planId,
    this.paymentMethodId,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        if (planId != null) 'plan_id': planId,
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
        if (metadata != null) 'metadata': metadata,
      };
}

class CreatePlanRequest {
  final String name;
  final double amount;
  final String currency;
  final PlanInterval interval;
  final int intervalCount;
  final List<String>? features;
  final int? trialDays;
  final Map<String, dynamic>? metadata;

  const CreatePlanRequest({
    required this.name,
    required this.amount,
    required this.currency,
    required this.interval,
    this.intervalCount = 1,
    this.features,
    this.trialDays,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'currency': currency,
        'interval': interval.value,
        'interval_count': intervalCount,
        if (features != null) 'features': features,
        if (trialDays != null) 'trial_days': trialDays,
        if (metadata != null) 'metadata': metadata,
      };
}

class UpdatePlanRequest {
  final String? name;
  final List<String>? features;
  final bool? active;
  final Map<String, dynamic>? metadata;

  const UpdatePlanRequest({
    this.name,
    this.features,
    this.active,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (features != null) 'features': features,
        if (active != null) 'active': active,
        if (metadata != null) 'metadata': metadata,
      };
}

class CreatePaymentLinkRequest {
  final double amount;
  final String currency;
  final String? description;
  final String? successUrl;
  final String? cancelUrl;
  final DateTime? expiresAt;
  final Map<String, dynamic>? metadata;

  const CreatePaymentLinkRequest({
    required this.amount,
    required this.currency,
    this.description,
    this.successUrl,
    this.cancelUrl,
    this.expiresAt,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        if (description != null) 'description': description,
        if (successUrl != null) 'success_url': successUrl,
        if (cancelUrl != null) 'cancel_url': cancelUrl,
        if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      };
}

class CreateInvoiceRequest {
  final String customerId;
  final List<InvoiceItem> items;
  final DateTime? dueDate;
  final Map<String, dynamic>? metadata;

  const CreateInvoiceRequest({
    required this.customerId,
    required this.items,
    this.dueDate,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'customer_id': customerId,
        'items': items.map((item) => item.toJson()).toList(),
        if (dueDate != null) 'due_date': dueDate!.toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      };
}

class InvoiceItem {
  final String description;
  final double amount;
  final int quantity;

  const InvoiceItem({
    required this.description,
    required this.amount,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'amount': amount,
        'quantity': quantity,
      };
}

class CreateWebhookRequest {
  final String url;
  final List<String> events;
  final String? description;
  final bool active;

  const CreateWebhookRequest({
    required this.url,
    required this.events,
    this.description,
    this.active = true,
  });

  Map<String, dynamic> toJson() => {
        'url': url,
        'events': events,
        if (description != null) 'description': description,
        'active': active,
      };
}

// List response classes

class PaymentMethodListResponse {
  final List<PaymentMethod> methods;
  final int total;

  const PaymentMethodListResponse({required this.methods, required this.total});

  factory PaymentMethodListResponse.fromJson(Map<String, dynamic> json) =>
      PaymentMethodListResponse(
        methods: (json['methods'] as List)
            .map((e) => PaymentMethod.fromJson(e))
            .toList(),
        total: json['total'],
      );
}

class TransactionListResponse {
  final List<PaymentTransaction> transactions;
  final int total;
  final double totalAmount;

  const TransactionListResponse({
    required this.transactions,
    required this.total,
    required this.totalAmount,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) =>
      TransactionListResponse(
        transactions: (json['transactions'] as List)
            .map((e) => PaymentTransaction.fromJson(e))
            .toList(),
        total: json['total'],
        totalAmount: json['total_amount'].toDouble(),
      );
}

class SubscriptionListResponse {
  final List<PaymentSubscription> subscriptions;
  final int total;

  const SubscriptionListResponse(
      {required this.subscriptions, required this.total});

  factory SubscriptionListResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionListResponse(
        subscriptions: (json['subscriptions'] as List)
            .map((e) => PaymentSubscription.fromJson(e))
            .toList(),
        total: json['total'],
      );
}

class PlanListResponse {
  final List<PaymentPlan> plans;
  final int total;

  const PlanListResponse({required this.plans, required this.total});

  factory PlanListResponse.fromJson(Map<String, dynamic> json) =>
      PlanListResponse(
        plans: (json['plans'] as List)
            .map((e) => PaymentPlan.fromJson(e))
            .toList(),
        total: json['total'],
      );
}

// Additional models

class PaymentLink {
  final String id;
  final String url;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const PaymentLink({
    required this.id,
    required this.url,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.expiresAt,
  });

  factory PaymentLink.fromJson(Map<String, dynamic> json) => PaymentLink(
        id: json['id'],
        url: json['url'],
        amount: json['amount'].toDouble(),
        currency: json['currency'],
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
        expiresAt: json['expires_at'] != null
            ? DateTime.parse(json['expires_at'])
            : null,
      );
}

class PaymentLinkDetails {
  final String id;
  final String url;
  final double amount;
  final String currency;
  final String status;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? usedAt;

  const PaymentLinkDetails({
    required this.id,
    required this.url,
    required this.amount,
    required this.currency,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.usedAt,
  });

  factory PaymentLinkDetails.fromJson(Map<String, dynamic> json) =>
      PaymentLinkDetails(
        id: json['id'],
        url: json['url'],
        amount: json['amount'].toDouble(),
        currency: json['currency'],
        status: json['status'],
        transactionId: json['transaction_id'],
        createdAt: DateTime.parse(json['created_at']),
        usedAt:
            json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
      );
}

class PaymentInvoice {
  final String id;
  final String number;
  final String customerId;
  final double amount;
  final String status;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final DateTime createdAt;

  const PaymentInvoice({
    required this.id,
    required this.number,
    required this.customerId,
    required this.amount,
    required this.status,
    this.dueDate,
    this.paidAt,
    required this.createdAt,
  });

  factory PaymentInvoice.fromJson(Map<String, dynamic> json) => PaymentInvoice(
        id: json['id'],
        number: json['number'],
        customerId: json['customer_id'],
        amount: json['amount'].toDouble(),
        status: json['status'],
        dueDate:
            json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
        paidAt:
            json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
        createdAt: DateTime.parse(json['created_at']),
      );
}

class PaymentWebhook {
  final String id;
  final String url;
  final List<String> events;
  final String secret;
  final bool active;
  final DateTime createdAt;

  const PaymentWebhook({
    required this.id,
    required this.url,
    required this.events,
    required this.secret,
    required this.active,
    required this.createdAt,
  });

  factory PaymentWebhook.fromJson(Map<String, dynamic> json) => PaymentWebhook(
        id: json['id'],
        url: json['url'],
        events: (json['events'] as List).cast<String>(),
        secret: json['secret'],
        active: json['active'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

class PaymentAnalytics {
  final double totalRevenue;
  final int totalTransactions;
  final double averageTransaction;
  final Map<String, double> currencyBreakdown;
  final Map<String, int> statusBreakdown;
  final List<AnalyticsTimeline> timeline;

  const PaymentAnalytics({
    required this.totalRevenue,
    required this.totalTransactions,
    required this.averageTransaction,
    required this.currencyBreakdown,
    required this.statusBreakdown,
    required this.timeline,
  });

  factory PaymentAnalytics.fromJson(Map<String, dynamic> json) =>
      PaymentAnalytics(
        totalRevenue: json['total_revenue'].toDouble(),
        totalTransactions: json['total_transactions'],
        averageTransaction: json['average_transaction'].toDouble(),
        currencyBreakdown: (json['currency_breakdown'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toDouble())),
        statusBreakdown: (json['status_breakdown'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value as int)),
        timeline: (json['timeline'] as List)
            .map((e) => AnalyticsTimeline.fromJson(e))
            .toList(),
      );
}

class AnalyticsTimeline {
  final String date;
  final double revenue;
  final int transactions;

  const AnalyticsTimeline({
    required this.date,
    required this.revenue,
    required this.transactions,
  });

  factory AnalyticsTimeline.fromJson(Map<String, dynamic> json) =>
      AnalyticsTimeline(
        date: json['date'],
        revenue: json['revenue'].toDouble(),
        transactions: json['transactions'],
      );
}
