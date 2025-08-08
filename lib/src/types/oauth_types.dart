// OAuth Types for AppAtOnce Flutter SDK

/// Supported OAuth providers
enum OAuthProvider {
  google('google'),
  facebook('facebook'),
  apple('apple'),
  github('github'),
  microsoft('microsoft'),
  twitter('twitter');

  const OAuthProvider(this.value);
  final String value;

  static OAuthProvider fromString(String value) {
    for (final provider in OAuthProvider.values) {
      if (provider.value == value) return provider;
    }
    throw ArgumentError('Unknown OAuth provider: $value');
  }
}

/// OAuth action types
enum OAuthAction {
  signin('signin'),
  link('link');

  const OAuthAction(this.value);
  final String value;

  static OAuthAction fromString(String value) {
    for (final action in OAuthAction.values) {
      if (action.value == value) return action;
    }
    throw ArgumentError('Unknown OAuth action: $value');
  }
}

/// OAuth provider configuration
class OAuthProviderConfig {
  final OAuthProvider provider;
  final String? clientId;
  final String? clientSecret;
  final String? redirectUri;
  final List<String>? scope;
  final bool enabled;

  const OAuthProviderConfig({
    required this.provider,
    this.clientId,
    this.clientSecret,
    this.redirectUri,
    this.scope,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider.value,
        'clientId': clientId,
        'clientSecret': clientSecret,
        'redirectUri': redirectUri,
        'scope': scope,
        'enabled': enabled,
      };

  factory OAuthProviderConfig.fromJson(Map<String, dynamic> json) =>
      OAuthProviderConfig(
        provider: OAuthProvider.fromString(json['provider']),
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
        redirectUri: json['redirectUri'],
        scope: (json['scope'] as List?)?.cast<String>(),
        enabled: json['enabled'] ?? true,
      );
}

/// OAuth initialization response
class OAuthInitiateResponse {
  final String url;
  final String state;
  final OAuthProvider provider;
  final OAuthAction action;

  const OAuthInitiateResponse({
    required this.url,
    required this.state,
    required this.provider,
    required this.action,
  });

  factory OAuthInitiateResponse.fromJson(Map<String, dynamic> json) =>
      OAuthInitiateResponse(
        url: json['url'],
        state: json['state'],
        provider: OAuthProvider.fromString(json['provider']),
        action: OAuthAction.fromString(json['action']),
      );
}

/// OAuth callback data
class OAuthCallbackData {
  final OAuthProvider provider;
  final String code;
  final String state;

  const OAuthCallbackData({
    required this.provider,
    required this.code,
    required this.state,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider.value,
        'code': code,
        'state': state,
      };
}

/// OAuth user data from provider
class OAuthUserData {
  final OAuthProvider provider;
  final String providerId;
  final String? email;
  final String? name;
  final String? avatarUrl;
  final bool? emailVerified;
  final Map<String, dynamic>? rawData;

  const OAuthUserData({
    required this.provider,
    required this.providerId,
    this.email,
    this.name,
    this.avatarUrl,
    this.emailVerified,
    this.rawData,
  });

  factory OAuthUserData.fromJson(Map<String, dynamic> json) => OAuthUserData(
        provider: OAuthProvider.fromString(json['provider']),
        providerId: json['providerId'],
        email: json['email'],
        name: json['name'],
        avatarUrl: json['avatarUrl'],
        emailVerified: json['emailVerified'],
        rawData: json['rawData'],
      );
}

/// Connected OAuth provider information
class ConnectedOAuthProvider {
  final OAuthProvider provider;
  final String? email;
  final String? name;
  final String? avatarUrl;
  final DateTime connectedAt;

  const ConnectedOAuthProvider({
    required this.provider,
    this.email,
    this.name,
    this.avatarUrl,
    required this.connectedAt,
  });

  factory ConnectedOAuthProvider.fromJson(Map<String, dynamic> json) =>
      ConnectedOAuthProvider(
        provider: OAuthProvider.fromString(json['provider']),
        email: json['email'],
        name: json['name'],
        avatarUrl: json['avatarUrl'],
        connectedAt: DateTime.parse(json['connectedAt']),
      );
}

/// Connected providers response
class ConnectedProvidersResponse {
  final List<ConnectedOAuthProvider> providers;
  final List<OAuthProvider> availableProviders;

  const ConnectedProvidersResponse({
    required this.providers,
    required this.availableProviders,
  });

  factory ConnectedProvidersResponse.fromJson(Map<String, dynamic> json) =>
      ConnectedProvidersResponse(
        providers: (json['providers'] as List)
            .map((e) => ConnectedOAuthProvider.fromJson(e))
            .toList(),
        availableProviders: (json['availableProviders'] as List)
            .map((e) => OAuthProvider.fromString(e))
            .toList(),
      );
}

/// OAuth link provider options
class OAuthLinkOptions {
  final String? redirectUrl;

  const OAuthLinkOptions({this.redirectUrl});

  Map<String, dynamic> toJson() => {
        'redirectUrl': redirectUrl,
      };
}

/// OAuth session data that extends the main AuthSession
class OAuthSession {
  final OAuthProvider provider;
  final String providerId;
  final DateTime connectedAt;

  const OAuthSession({
    required this.provider,
    required this.providerId,
    required this.connectedAt,
  });

  factory OAuthSession.fromJson(Map<String, dynamic> json) => OAuthSession(
        provider: OAuthProvider.fromString(json['provider']),
        providerId: json['providerId'],
        connectedAt: DateTime.parse(json['connectedAt']),
      );
}

/// OAuth error
class OAuthError extends Error {
  final OAuthProvider? provider;
  final String? code;
  final dynamic details;
  final String message;

  OAuthError({
    this.provider,
    this.code,
    this.details,
    required this.message,
  });

  @override
  String toString() =>
      'OAuthError: $message (provider: ${provider?.value}, code: $code)';
}

/// OAuth flow options
class OAuthFlowOptions {
  final OAuthAction? action;
  final String? redirectUrl;
  final String? state;
  final List<String>? scope;

  const OAuthFlowOptions({
    this.action,
    this.redirectUrl,
    this.state,
    this.scope,
  });

  Map<String, dynamic> toJson() => {
        'action': action?.value,
        'redirectUrl': redirectUrl,
        'state': state,
        'scope': scope,
      };
}

/// OAuth token refresh options
class OAuthTokenRefreshOptions {
  final OAuthProvider provider;
  final String providerId;
  final String? refreshToken;

  const OAuthTokenRefreshOptions({
    required this.provider,
    required this.providerId,
    this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider.value,
        'providerId': providerId,
        'refreshToken': refreshToken,
      };
}

/// OAuth token refresh response
class OAuthTokenRefreshResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresAt;
  final String? error;

  const OAuthTokenRefreshResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.error,
  });

  factory OAuthTokenRefreshResponse.fromJson(Map<String, dynamic> json) =>
      OAuthTokenRefreshResponse(
        success: json['success'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        expiresAt: json['expiresAt'],
        error: json['error'],
      );
}

/// OAuth configuration for the SDK
class OAuthConfig {
  final Map<OAuthProvider, OAuthProviderConfig>? providers;
  final String? defaultRedirectUrl;
  final bool enableTokenRefresh;
  final int tokenRefreshThreshold; // Minutes before expiry to refresh

  const OAuthConfig({
    this.providers,
    this.defaultRedirectUrl,
    this.enableTokenRefresh = true,
    this.tokenRefreshThreshold = 5,
  });
}

/// OAuth state parameter data
class OAuthStateData {
  final OAuthAction action;
  final String? userId;
  final String? redirectUrl;
  final String csrfToken;
  final int timestamp;

  const OAuthStateData({
    required this.action,
    this.userId,
    this.redirectUrl,
    required this.csrfToken,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'action': action.value,
        'userId': userId,
        'redirectUrl': redirectUrl,
        'csrfToken': csrfToken,
        'timestamp': timestamp,
      };

  factory OAuthStateData.fromJson(Map<String, dynamic> json) => OAuthStateData(
        action: OAuthAction.fromString(json['action']),
        userId: json['userId'],
        redirectUrl: json['redirectUrl'],
        csrfToken: json['csrfToken'],
        timestamp: json['timestamp'],
      );
}

/// OAuth initiate request options
class OAuthInitiateOptions {
  final OAuthProvider provider;
  final OAuthAction? action;
  final String? userId;
  final String? redirectUrl;

  const OAuthInitiateOptions({
    required this.provider,
    this.action,
    this.userId,
    this.redirectUrl,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider.value,
        'action': action?.value,
        'userId': userId,
        'redirectUrl': redirectUrl,
      };
}

/// OAuth unlink options
class OAuthUnlinkOptions {
  final OAuthProvider provider;

  const OAuthUnlinkOptions({required this.provider});

  Map<String, dynamic> toJson() => {
        'provider': provider.value,
      };
}

/// OAuth provider linking result
class OAuthLinkResult {
  final bool success;
  final String message;
  final OAuthProvider provider;

  const OAuthLinkResult({
    required this.success,
    required this.message,
    required this.provider,
  });

  factory OAuthLinkResult.fromJson(Map<String, dynamic> json) =>
      OAuthLinkResult(
        success: json['success'],
        message: json['message'],
        provider: OAuthProvider.fromString(json['provider']),
      );
}

/// OAuth provider unlinking result
class OAuthUnlinkResult {
  final bool success;
  final String message;
  final OAuthProvider provider;

  const OAuthUnlinkResult({
    required this.success,
    required this.message,
    required this.provider,
  });

  factory OAuthUnlinkResult.fromJson(Map<String, dynamic> json) =>
      OAuthUnlinkResult(
        success: json['success'],
        message: json['message'],
        provider: OAuthProvider.fromString(json['provider']),
      );
}

/// OAuth authentication result
class OAuthAuthResult {
  final String accessToken;
  final String? refreshToken;
  final User user;
  final int? expiresAt;
  final OAuthSession? oauth;

  const OAuthAuthResult({
    required this.accessToken,
    this.refreshToken,
    required this.user,
    this.expiresAt,
    this.oauth,
  });

  factory OAuthAuthResult.fromJson(Map<String, dynamic> json) =>
      OAuthAuthResult(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        user: User.fromJson(json['user']),
        expiresAt: json['expires_at'],
        oauth:
            json['oauth'] != null ? OAuthSession.fromJson(json['oauth']) : null,
      );
}

// Required User class for OAuth result
class User {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final bool? emailVerified;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        avatarUrl: json['avatarUrl'],
        emailVerified: json['emailVerified'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatarUrl': avatarUrl,
        'emailVerified': emailVerified,
      };
}
