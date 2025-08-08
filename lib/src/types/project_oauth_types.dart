// Project OAuth Types for AppAtOnce Flutter SDK
// These types are for end-user authentication in projects (multi-tenant OAuth)

import 'oauth_types.dart';

/// Project OAuth provider configuration
/// Used by project owners to configure OAuth for their projects
class ProjectOAuthProviderConfig {
  final String provider; // Support custom providers too
  final String clientId;
  final String? clientSecret; // Optional for some providers
  final String? redirectUri;
  final List<String>? scope;
  final bool enabled;
  final String? customDomain; // For custom OAuth domains
  final Map<String, dynamic>? metadata;

  const ProjectOAuthProviderConfig({
    required this.provider,
    required this.clientId,
    this.clientSecret,
    this.redirectUri,
    this.scope,
    required this.enabled,
    this.customDomain,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'clientId': clientId,
        'clientSecret': clientSecret,
        'redirectUri': redirectUri,
        'scope': scope,
        'enabled': enabled,
        'customDomain': customDomain,
        'metadata': metadata,
      };

  factory ProjectOAuthProviderConfig.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthProviderConfig(
        provider: json['provider'],
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
        redirectUri: json['redirectUri'],
        scope: (json['scope'] as List?)?.cast<String>(),
        enabled: json['enabled'] ?? false,
        customDomain: json['customDomain'],
        metadata: json['metadata'],
      );
}

/// Project OAuth provider information
/// Returned when querying available providers for a project
class ProjectOAuthProvider {
  final String provider;
  final bool enabled;
  final List<String>? scope;
  final String? customDomain;
  final bool configured;
  final DateTime? configuredAt;

  const ProjectOAuthProvider({
    required this.provider,
    required this.enabled,
    this.scope,
    this.customDomain,
    required this.configured,
    this.configuredAt,
  });

  factory ProjectOAuthProvider.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthProvider(
        provider: json['provider'],
        enabled: json['enabled'] ?? false,
        scope: (json['scope'] as List?)?.cast<String>(),
        customDomain: json['customDomain'],
        configured: json['configured'] ?? false,
        configuredAt: json['configuredAt'] != null
            ? DateTime.parse(json['configuredAt'])
            : null,
      );
}

/// Project user session after OAuth authentication
/// Represents an end-user authenticated to a project
class ProjectUserSession {
  final String projectId;
  final String userId;
  final String provider;
  final String providerId; // Provider-specific user ID
  final String? email;
  final String? name;
  final String? avatarUrl;
  final String accessToken;
  final String? refreshToken;
  final int expiresAt;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const ProjectUserSession({
    required this.projectId,
    required this.userId,
    required this.provider,
    required this.providerId,
    this.email,
    this.name,
    this.avatarUrl,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    this.metadata,
    required this.createdAt,
  });

  factory ProjectUserSession.fromJson(Map<String, dynamic> json) =>
      ProjectUserSession(
        projectId: json['projectId'],
        userId: json['userId'],
        provider: json['provider'],
        providerId: json['providerId'],
        email: json['email'],
        name: json['name'],
        avatarUrl: json['avatarUrl'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        expiresAt: json['expiresAt'],
        metadata: json['metadata'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

/// Project OAuth token after exchange
class ProjectAuthToken {
  final String projectId;
  final String userId;
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final int expiresIn;
  final List<String>? scope;
  final String? idToken; // For OpenID Connect

  const ProjectAuthToken({
    required this.projectId,
    required this.userId,
    required this.accessToken,
    this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.scope,
    this.idToken,
  });

  factory ProjectAuthToken.fromJson(Map<String, dynamic> json) =>
      ProjectAuthToken(
        projectId: json['projectId'],
        userId: json['userId'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        tokenType: json['tokenType'],
        expiresIn: json['expiresIn'],
        scope: (json['scope'] as List?)?.cast<String>(),
        idToken: json['idToken'],
      );
}

/// Project OAuth initiation response
class ProjectOAuthInitiateResponse {
  final String url;
  final String state;
  final String provider;
  final String projectId;
  final String? codeVerifier; // For PKCE flow

  const ProjectOAuthInitiateResponse({
    required this.url,
    required this.state,
    required this.provider,
    required this.projectId,
    this.codeVerifier,
  });

  factory ProjectOAuthInitiateResponse.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthInitiateResponse(
        url: json['url'],
        state: json['state'],
        provider: json['provider'],
        projectId: json['projectId'],
        codeVerifier: json['codeVerifier'],
      );
}

/// Project OAuth callback parameters
class ProjectOAuthCallbackParams {
  final String code;
  final String state;
  final String? error;
  final String? errorDescription;

  const ProjectOAuthCallbackParams({
    required this.code,
    required this.state,
    this.error,
    this.errorDescription,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'state': state,
        'error': error,
        'errorDescription': errorDescription,
      };
}

/// OAuth configuration for projects
class ProjectOAuthConfig {
  final String provider;
  final String clientId;
  final String? clientSecret;
  final String? redirectUri;
  final String? authorizationUrl; // For custom providers
  final String? tokenUrl; // For custom providers
  final String? userInfoUrl; // For custom providers
  final List<String>? scope;
  final Map<String, String>? customHeaders;
  final bool pkce; // Enable PKCE for security

  const ProjectOAuthConfig({
    required this.provider,
    required this.clientId,
    this.clientSecret,
    this.redirectUri,
    this.authorizationUrl,
    this.tokenUrl,
    this.userInfoUrl,
    this.scope,
    this.customHeaders,
    this.pkce = false,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'clientId': clientId,
        'clientSecret': clientSecret,
        'redirectUri': redirectUri,
        'authorizationUrl': authorizationUrl,
        'tokenUrl': tokenUrl,
        'userInfoUrl': userInfoUrl,
        'scope': scope,
        'customHeaders': customHeaders,
        'pkce': pkce,
      };

  factory ProjectOAuthConfig.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthConfig(
        provider: json['provider'],
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
        redirectUri: json['redirectUri'],
        authorizationUrl: json['authorizationUrl'],
        tokenUrl: json['tokenUrl'],
        userInfoUrl: json['userInfoUrl'],
        scope: (json['scope'] as List?)?.cast<String>(),
        customHeaders: (json['customHeaders'] as Map?)?.cast<String, String>(),
        pkce: json['pkce'] ?? false,
      );
}

/// Test result for OAuth provider configuration
class TestResult {
  final bool success;
  final String message;
  final String provider;
  final TestResultDetails? details;

  const TestResult({
    required this.success,
    required this.message,
    required this.provider,
    this.details,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) => TestResult(
        success: json['success'],
        message: json['message'],
        provider: json['provider'],
        details: json['details'] != null
            ? TestResultDetails.fromJson(json['details'])
            : null,
      );
}

class TestResultDetails {
  final String? authorizationUrl;
  final String? tokenUrl;
  final String? userInfoUrl;
  final bool configValid;
  final bool redirectUriValid;
  final List<String>? errors;

  const TestResultDetails({
    this.authorizationUrl,
    this.tokenUrl,
    this.userInfoUrl,
    required this.configValid,
    required this.redirectUriValid,
    this.errors,
  });

  factory TestResultDetails.fromJson(Map<String, dynamic> json) =>
      TestResultDetails(
        authorizationUrl: json['authorizationUrl'],
        tokenUrl: json['tokenUrl'],
        userInfoUrl: json['userInfoUrl'],
        configValid: json['configValid'] ?? false,
        redirectUriValid: json['redirectUriValid'] ?? false,
        errors: (json['errors'] as List?)?.cast<String>(),
      );
}

/// Project OAuth error
class ProjectOAuthError extends Error {
  final String? projectId;
  final String? provider;
  final String? code;
  final dynamic details;
  final String message;

  ProjectOAuthError({
    this.projectId,
    this.provider,
    this.code,
    this.details,
    required this.message,
  });

  @override
  String toString() =>
      'ProjectOAuthError: $message (projectId: $projectId, provider: $provider, code: $code)';
}

/// Options for initiating project OAuth
class ProjectOAuthInitiateOptions {
  final String? redirectUri;
  final List<String>? scope;
  final String? state; // Custom state parameter
  final String? prompt; // 'none', 'consent', 'select_account'
  final String? loginHint; // Pre-fill email
  final bool pkce; // Enable PKCE

  const ProjectOAuthInitiateOptions({
    this.redirectUri,
    this.scope,
    this.state,
    this.prompt,
    this.loginHint,
    this.pkce = false,
  });

  Map<String, dynamic> toJson() => {
        'redirectUri': redirectUri,
        'scope': scope,
        'state': state,
        'prompt': prompt,
        'loginHint': loginHint,
        'pkce': pkce,
      };
}

/// Options for exchanging OAuth token
class ProjectOAuthTokenExchangeOptions {
  final String? codeVerifier; // For PKCE
  final String? redirectUri;

  const ProjectOAuthTokenExchangeOptions({
    this.codeVerifier,
    this.redirectUri,
  });

  Map<String, dynamic> toJson() => {
        'codeVerifier': codeVerifier,
        'redirectUri': redirectUri,
      };
}

/// Project OAuth user info
/// Normalized user information from various providers
class ProjectOAuthUserInfo {
  final String id; // Provider-specific ID
  final String? email;
  final bool? emailVerified;
  final String? name;
  final String? givenName;
  final String? familyName;
  final String? picture;
  final String? locale;
  final Map<String, dynamic> raw; // Raw provider response

  const ProjectOAuthUserInfo({
    required this.id,
    this.email,
    this.emailVerified,
    this.name,
    this.givenName,
    this.familyName,
    this.picture,
    this.locale,
    required this.raw,
  });

  factory ProjectOAuthUserInfo.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthUserInfo(
        id: json['id'],
        email: json['email'],
        emailVerified: json['emailVerified'],
        name: json['name'],
        givenName: json['givenName'],
        familyName: json['familyName'],
        picture: json['picture'],
        locale: json['locale'],
        raw: json['raw'] ?? {},
      );
}

/// Project OAuth session with user info
class ProjectOAuthSessionWithUser extends ProjectUserSession {
  final ProjectOAuthUserInfo user;

  const ProjectOAuthSessionWithUser({
    required super.projectId,
    required super.userId,
    required super.provider,
    required super.providerId,
    super.email,
    super.name,
    super.avatarUrl,
    required super.accessToken,
    super.refreshToken,
    required super.expiresAt,
    super.metadata,
    required super.createdAt,
    required this.user,
  });

  factory ProjectOAuthSessionWithUser.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthSessionWithUser(
        projectId: json['projectId'],
        userId: json['userId'],
        provider: json['provider'],
        providerId: json['providerId'],
        email: json['email'],
        name: json['name'],
        avatarUrl: json['avatarUrl'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        expiresAt: json['expiresAt'],
        metadata: json['metadata'],
        createdAt: DateTime.parse(json['createdAt']),
        user: ProjectOAuthUserInfo.fromJson(json['user']),
      );
}

/// Options for refreshing project OAuth tokens
class ProjectOAuthTokenRefreshOptions {
  final String refreshToken;
  final List<String>? scope;

  const ProjectOAuthTokenRefreshOptions({
    required this.refreshToken,
    this.scope,
  });

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
        'scope': scope,
      };
}

/// Response from refreshing project OAuth tokens
class ProjectOAuthTokenRefreshResponse {
  final String accessToken;
  final String? refreshToken;
  final int expiresIn;
  final List<String>? scope;
  final String tokenType;

  const ProjectOAuthTokenRefreshResponse({
    required this.accessToken,
    this.refreshToken,
    required this.expiresIn,
    this.scope,
    required this.tokenType,
  });

  factory ProjectOAuthTokenRefreshResponse.fromJson(
          Map<String, dynamic> json) =>
      ProjectOAuthTokenRefreshResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        expiresIn: json['expiresIn'],
        scope: (json['scope'] as List?)?.cast<String>(),
        tokenType: json['tokenType'],
      );
}

/// Project OAuth provider status
class ProjectOAuthProviderStatus {
  final String provider;
  final bool configured;
  final bool enabled;
  final DateTime? lastTestedAt;
  final bool? lastTestResult;
  final int? userCount;
  final Map<String, dynamic>? metadata;

  const ProjectOAuthProviderStatus({
    required this.provider,
    required this.configured,
    required this.enabled,
    this.lastTestedAt,
    this.lastTestResult,
    this.userCount,
    this.metadata,
  });

  factory ProjectOAuthProviderStatus.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthProviderStatus(
        provider: json['provider'],
        configured: json['configured'] ?? false,
        enabled: json['enabled'] ?? false,
        lastTestedAt: json['lastTestedAt'] != null
            ? DateTime.parse(json['lastTestedAt'])
            : null,
        lastTestResult: json['lastTestResult'],
        userCount: json['userCount'],
        metadata: json['metadata'],
      );
}

/// Bulk configuration result
class ProjectOAuthBulkConfigResult {
  final String provider;
  final bool success;
  final String? message;
  final String? error;

  const ProjectOAuthBulkConfigResult({
    required this.provider,
    required this.success,
    this.message,
    this.error,
  });

  factory ProjectOAuthBulkConfigResult.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthBulkConfigResult(
        provider: json['provider'],
        success: json['success'],
        message: json['message'],
        error: json['error'],
      );
}

/// OAuth provider template for quick setup
class OAuthProviderTemplate {
  final String provider;
  final String name;
  final String authorizationUrl;
  final String tokenUrl;
  final String? userInfoUrl;
  final List<String> scope;
  final bool pkce;
  final String? logoUrl;
  final String? documentation;

  const OAuthProviderTemplate({
    required this.provider,
    required this.name,
    required this.authorizationUrl,
    required this.tokenUrl,
    this.userInfoUrl,
    required this.scope,
    required this.pkce,
    this.logoUrl,
    this.documentation,
  });

  factory OAuthProviderTemplate.fromJson(Map<String, dynamic> json) =>
      OAuthProviderTemplate(
        provider: json['provider'],
        name: json['name'],
        authorizationUrl: json['authorizationUrl'],
        tokenUrl: json['tokenUrl'],
        userInfoUrl: json['userInfoUrl'],
        scope: (json['scope'] as List).cast<String>(),
        pkce: json['pkce'] ?? false,
        logoUrl: json['logoUrl'],
        documentation: json['documentation'],
      );
}

/// Project OAuth analytics
class ProjectOAuthAnalytics {
  final String projectId;
  final int totalUsers;
  final Map<String, ProjectOAuthProviderStats> byProvider;
  final List<RecentSignIn> recentSignIns;

  const ProjectOAuthAnalytics({
    required this.projectId,
    required this.totalUsers,
    required this.byProvider,
    required this.recentSignIns,
  });

  factory ProjectOAuthAnalytics.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthAnalytics(
        projectId: json['projectId'],
        totalUsers: json['totalUsers'],
        byProvider: (json['byProvider'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            ProjectOAuthProviderStats.fromJson(value),
          ),
        ),
        recentSignIns: (json['recentSignIns'] as List)
            .map((e) => RecentSignIn.fromJson(e))
            .toList(),
      );
}

class ProjectOAuthProviderStats {
  final int userCount;
  final DateTime? lastSignIn;
  final int signInCount;

  const ProjectOAuthProviderStats({
    required this.userCount,
    this.lastSignIn,
    required this.signInCount,
  });

  factory ProjectOAuthProviderStats.fromJson(Map<String, dynamic> json) =>
      ProjectOAuthProviderStats(
        userCount: json['userCount'],
        lastSignIn: json['lastSignIn'] != null
            ? DateTime.parse(json['lastSignIn'])
            : null,
        signInCount: json['signInCount'],
      );
}

class RecentSignIn {
  final String userId;
  final String provider;
  final DateTime timestamp;

  const RecentSignIn({
    required this.userId,
    required this.provider,
    required this.timestamp,
  });

  factory RecentSignIn.fromJson(Map<String, dynamic> json) => RecentSignIn(
        userId: json['userId'],
        provider: json['provider'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
