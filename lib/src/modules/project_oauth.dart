import '../utils/http_client.dart';
import '../types/project_oauth_types.dart';

/// Project OAuth module for handling end-user authentication in projects
/// This is for multi-tenant OAuth where each project can have its own OAuth providers
class ProjectOAuthModule {
  final HttpClient _httpClient;

  ProjectOAuthModule(this._httpClient);

  /// Initiate OAuth flow for end-users of a project
  /// [projectId] - The project ID
  /// [provider] - OAuth provider to use
  /// [options] - Additional options for the OAuth flow
  /// Returns OAuth initiation response with authorization URL
  Future<ProjectOAuthInitiateResponse> initiateProjectOAuth(
    String projectId,
    String provider, {
    ProjectOAuthInitiateOptions? options,
  }) async {
    try {
      final response = await _httpClient.post(
        '/projects/$projectId/oauth/$provider/initiate',
        data: {
          if (options?.redirectUri != null) 'redirectUri': options!.redirectUri,
          if (options?.scope != null) 'scope': options!.scope,
          if (options?.state != null) 'state': options!.state,
          if (options?.prompt != null) 'prompt': options!.prompt,
          if (options?.loginHint != null) 'loginHint': options!.loginHint,
          if (options?.pkce != null) 'pkce': options!.pkce,
        },
      );

      return ProjectOAuthInitiateResponse(
        url: response.data['url'],
        state: response.data['state'],
        provider: provider,
        projectId: projectId,
        codeVerifier: response.data['codeVerifier'],
      );
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Handle OAuth callback for project end-users
  /// [projectId] - The project ID
  /// [provider] - OAuth provider
  /// [params] - Callback parameters (code, state, etc.)
  /// Returns project user session
  Future<ProjectUserSession> handleProjectOAuthCallback(
    String projectId,
    String provider,
    ProjectOAuthCallbackParams params,
  ) async {
    try {
      final response = await _httpClient.post(
        '/projects/$projectId/oauth/$provider/callback',
        data: params.toJson(),
      );

      return ProjectUserSession.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Exchange authorization code for tokens
  /// [projectId] - The project ID
  /// [code] - Authorization code
  /// [state] - State parameter
  /// [options] - Additional options for token exchange
  /// Returns project auth token
  Future<ProjectAuthToken> exchangeProjectOAuthToken(
    String projectId,
    String code,
    String state, {
    ProjectOAuthTokenExchangeOptions? options,
  }) async {
    try {
      final response = await _httpClient.post(
        '/projects/$projectId/oauth/token',
        data: {
          'code': code,
          'state': state,
          if (options?.codeVerifier != null)
            'codeVerifier': options!.codeVerifier,
          if (options?.redirectUri != null) 'redirectUri': options!.redirectUri,
        },
      );

      return ProjectAuthToken.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId);
    }
  }

  /// Get OAuth providers configured for a project
  /// [projectId] - The project ID
  /// Returns array of configured providers
  Future<List<ProjectOAuthProvider>> getProjectOAuthProviders(
    String projectId,
  ) async {
    try {
      final response = await _httpClient.get(
        '/projects/$projectId/oauth/providers',
      );

      final providers = response.data['providers'] as List? ?? [];
      return providers.map((e) => ProjectOAuthProvider.fromJson(e)).toList();
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId);
    }
  }

  /// Configure OAuth provider for a project (used by project owners)
  /// [projectId] - The project ID
  /// [provider] - OAuth provider name
  /// [config] - OAuth provider configuration
  Future<void> configureProjectOAuthProvider(
    String projectId,
    String provider,
    ProjectOAuthConfig config,
  ) async {
    try {
      await _httpClient.put(
        '/projects/$projectId/oauth/providers/$provider',
        data: config.toJson(),
      );
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Test OAuth provider configuration
  /// [projectId] - The project ID
  /// [provider] - OAuth provider to test
  /// Returns test result
  Future<TestResult> testProjectOAuthProvider(
    String projectId,
    String provider,
  ) async {
    try {
      final response = await _httpClient.post(
        '/projects/$projectId/oauth/providers/$provider/test',
      );

      return TestResult.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Get OAuth callback URL for a provider
  /// [projectId] - The project ID
  /// [provider] - OAuth provider
  /// Returns callback URL
  Future<String> getProjectOAuthCallbackUrl(
    String projectId,
    String provider,
  ) async {
    try {
      final response = await _httpClient.get(
        '/projects/$projectId/oauth/providers/$provider/callback-url',
      );

      return response.data['url'];
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Get user info from OAuth provider
  /// [projectId] - The project ID
  /// [provider] - OAuth provider
  /// [accessToken] - User's access token
  /// Returns user info
  Future<ProjectOAuthUserInfo> getProjectOAuthUserInfo(
    String projectId,
    String provider,
    String accessToken,
  ) async {
    try {
      final response = await _httpClient.post(
        '/projects/$projectId/oauth/$provider/userinfo',
        data: {'accessToken': accessToken},
      );

      return ProjectOAuthUserInfo.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Refresh OAuth tokens for a project user
  /// [projectId] - The project ID
  /// [provider] - OAuth provider
  /// [options] - Token refresh options
  /// Returns refreshed tokens
  Future<ProjectOAuthTokenRefreshResponse> refreshProjectOAuthToken(
    String projectId,
    String provider,
    ProjectOAuthTokenRefreshOptions options,
  ) async {
    try {
      final response = await _httpClient.post(
        '/projects/$projectId/oauth/$provider/refresh',
        data: options.toJson(),
      );

      return ProjectOAuthTokenRefreshResponse.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Enable OAuth provider for a project
  /// [projectId] - The project ID
  /// [provider] - OAuth provider to enable
  Future<void> enableProjectOAuthProvider(
    String projectId,
    String provider,
  ) async {
    try {
      await _httpClient.post(
        '/projects/$projectId/oauth/providers/$provider/enable',
      );
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Disable OAuth provider for a project
  /// [projectId] - The project ID
  /// [provider] - OAuth provider to disable
  Future<void> disableProjectOAuthProvider(
    String projectId,
    String provider,
  ) async {
    try {
      await _httpClient.post(
        '/projects/$projectId/oauth/providers/$provider/disable',
      );
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Delete OAuth provider configuration
  /// [projectId] - The project ID
  /// [provider] - OAuth provider to delete
  Future<void> deleteProjectOAuthProvider(
    String projectId,
    String provider,
  ) async {
    try {
      await _httpClient.delete(
        '/projects/$projectId/oauth/providers/$provider',
      );
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Get OAuth provider status
  /// [projectId] - The project ID
  /// [provider] - OAuth provider
  /// Returns provider status
  Future<ProjectOAuthProviderStatus> getProjectOAuthProviderStatus(
    String projectId,
    String provider,
  ) async {
    try {
      final response = await _httpClient.get(
        '/projects/$projectId/oauth/providers/$provider/status',
      );

      return ProjectOAuthProviderStatus.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Configure multiple OAuth providers at once
  /// [projectId] - The project ID
  /// [configs] - Array of provider configurations
  /// Returns bulk configuration results
  Future<List<ProjectOAuthBulkConfigResult>> configureMultipleProviders(
    String projectId,
    List<({String provider, ProjectOAuthConfig config})> configs,
  ) async {
    try {
      final providersData = configs
          .map((c) => {
                'provider': c.provider,
                'config': c.config.toJson(),
              })
          .toList();

      final response = await _httpClient.post(
        '/projects/$projectId/oauth/providers/bulk',
        data: {'providers': providersData},
      );

      final results = response.data['results'] as List? ?? [];
      return results
          .map((e) => ProjectOAuthBulkConfigResult.fromJson(e))
          .toList();
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId);
    }
  }

  /// Get available OAuth provider templates
  /// Returns array of provider templates
  Future<List<OAuthProviderTemplate>> getOAuthProviderTemplates() async {
    try {
      final response = await _httpClient.get('/oauth/templates');
      final templates = response.data['templates'] as List? ?? [];
      return templates.map((e) => OAuthProviderTemplate.fromJson(e)).toList();
    } catch (error) {
      throw _handleProjectOAuthError(error);
    }
  }

  /// Get OAuth analytics for a project
  /// [projectId] - The project ID
  /// Returns OAuth analytics
  Future<ProjectOAuthAnalytics> getProjectOAuthAnalytics(
    String projectId,
  ) async {
    try {
      final response = await _httpClient.get(
        '/projects/$projectId/oauth/analytics',
      );

      return ProjectOAuthAnalytics.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId);
    }
  }

  /// Create OAuth session from provider response
  /// Convenience method for handling provider callbacks
  /// [projectId] - The project ID
  /// [provider] - OAuth provider
  /// [providerData] - Data from OAuth provider
  /// Returns project user session
  Future<ProjectOAuthSessionWithUser> createProjectOAuthSession(
    String projectId,
    String provider, {
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
    required ProjectOAuthUserInfo userInfo,
  }) async {
    try {
      final response = await _httpClient.post(
        '/projects/$projectId/oauth/sessions',
        data: {
          'provider': provider,
          'accessToken': accessToken,
          if (refreshToken != null) 'refreshToken': refreshToken,
          if (expiresIn != null) 'expiresIn': expiresIn,
          'userInfo': userInfo.toJson(),
        },
      );

      return ProjectOAuthSessionWithUser.fromJson(response.data);
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Revoke OAuth session for a project user
  /// [projectId] - The project ID
  /// [userId] - User ID
  /// [provider] - OAuth provider
  Future<void> revokeProjectOAuthSession(
    String projectId,
    String userId,
    String provider,
  ) async {
    try {
      await _httpClient.delete(
        '/projects/$projectId/oauth/sessions/$userId/$provider',
      );
    } catch (error) {
      throw _handleProjectOAuthError(error, projectId, provider);
    }
  }

  /// Handle project OAuth errors with proper typing and context
  /// [error] - Original error
  /// [projectId] - Project ID for context
  /// [provider] - Optional OAuth provider for context
  /// Returns formatted project OAuth error
  ProjectOAuthError _handleProjectOAuthError(
    dynamic error, [
    String? projectId,
    String? provider,
  ]) {
    String message;
    String? code;
    dynamic details;

    if (error is Exception) {
      message = error.toString();
      code = 'UNKNOWN_ERROR';
    } else {
      message = 'Unknown project OAuth error';
      code = 'UNKNOWN_ERROR';
    }

    return ProjectOAuthError(
      projectId: projectId,
      provider: provider,
      code: code,
      details: details,
      message: message,
    );
  }
}

extension on ProjectOAuthUserInfo {
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'emailVerified': emailVerified,
        'name': name,
        'givenName': givenName,
        'familyName': familyName,
        'picture': picture,
        'locale': locale,
        'raw': raw,
      };
}
