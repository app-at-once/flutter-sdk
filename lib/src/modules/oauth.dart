import '../utils/http_client.dart';
import '../common/types.dart';
import '../types/oauth_types.dart';

/// OAuth module for handling OAuth authentication flows
class OAuthModule {
  final HttpClient _httpClient;

  OAuthModule(this._httpClient);

  /// Initiate OAuth flow with a provider
  /// [provider] - OAuth provider to use
  /// [options] - Additional options for the OAuth flow
  /// Returns OAuth initiation response
  Future<OAuthInitiateResponse> initiateOAuth(
    OAuthProvider provider, {
    OAuthFlowOptions? options,
  }) async {
    try {
      final queryParams = <String, String>{
        'action': OAuthAction.signin.value,
        if (options?.redirectUrl != null) 'redirectUrl': options!.redirectUrl!,
      };

      final response = await _httpClient.get(
        '/auth/oauth/${provider.value}',
        params: queryParams,
      );

      // Extract state from the redirect URL if it's returned
      String state = '';
      if (response.data is Map && response.data['url'] != null) {
        final url = response.data['url'] as String;
        if (url.contains('state=')) {
          final uri = Uri.parse(url);
          state = uri.queryParameters['state'] ?? '';
        }
      }

      return OAuthInitiateResponse(
        url: response.data is Map
            ? (response.data['url'] ?? response.data.toString())
            : response.data.toString(),
        state: state,
        provider: provider,
        action: OAuthAction.signin,
      );
    } catch (error) {
      throw _handleOAuthError(error, provider);
    }
  }

  /// Handle OAuth callback after user returns from provider
  /// [provider] - OAuth provider
  /// [code] - Authorization code from provider
  /// [state] - State parameter for CSRF protection
  /// Returns authentication session
  Future<Session> handleOAuthCallback(
    OAuthProvider provider,
    String code,
    String state,
  ) async {
    try {
      final response = await _httpClient.post(
        '/auth/oauth/${provider.value}/callback',
        data: {
          'code': code,
          'state': state,
        },
      );

      return Session.fromJson(response.data);
    } catch (error) {
      throw _handleOAuthError(error, provider);
    }
  }

  /// Link an OAuth provider to the current authenticated user
  /// [provider] - OAuth provider to link
  /// [code] - Authorization code from provider
  /// [state] - State parameter for CSRF protection
  /// Returns link result
  Future<OAuthLinkResult> linkOAuthProvider(
    OAuthProvider provider,
    String code,
    String state,
  ) async {
    try {
      final response = await _httpClient.post(
        '/auth/oauth/${provider.value}/callback',
        data: {
          'code': code,
          'state': state,
        },
      );

      return OAuthLinkResult(
        success: true,
        message: response.data['message'] ??
            '${provider.value} account linked successfully',
        provider: provider,
      );
    } catch (error) {
      throw _handleOAuthError(error, provider);
    }
  }

  /// Initiate OAuth provider linking flow
  /// [provider] - OAuth provider to link
  /// [options] - Additional options for linking
  /// Returns OAuth initiation response
  Future<OAuthInitiateResponse> initiateLinkProvider(
    OAuthProvider provider, {
    OAuthLinkOptions? options,
  }) async {
    try {
      final response = await _httpClient.post(
        '/auth/oauth/${provider.value}/link',
        data: {
          'provider': provider.value,
          if (options?.redirectUrl != null) 'redirectUrl': options!.redirectUrl,
        },
      );

      // Extract state from the redirect URL if it's returned
      String state = '';
      if (response.data['url'] != null) {
        final url = response.data['url'] as String;
        if (url.contains('state=')) {
          final uri = Uri.parse(url);
          state = uri.queryParameters['state'] ?? '';
        }
      }

      return OAuthInitiateResponse(
        url: response.data['url'] ?? response.data.toString(),
        state: state,
        provider: provider,
        action: OAuthAction.link,
      );
    } catch (error) {
      throw _handleOAuthError(error, provider);
    }
  }

  /// Unlink an OAuth provider from the current user
  /// [provider] - OAuth provider to unlink
  /// Returns unlink result
  Future<OAuthUnlinkResult> unlinkOAuthProvider(OAuthProvider provider) async {
    try {
      final response = await _httpClient.delete(
        '/auth/oauth/${provider.value}/unlink',
      );

      return OAuthUnlinkResult(
        success: true,
        message: response.data['message'] ??
            '${provider.value} account unlinked successfully',
        provider: provider,
      );
    } catch (error) {
      throw _handleOAuthError(error, provider);
    }
  }

  /// Get all connected OAuth providers for the current user
  /// Returns connected providers information
  Future<ConnectedProvidersResponse> getConnectedProviders() async {
    try {
      final response = await _httpClient.get('/auth/oauth/providers');
      return ConnectedProvidersResponse.fromJson(response.data);
    } catch (error) {
      throw _handleOAuthError(error);
    }
  }

  /// Refresh OAuth tokens for a specific provider
  /// [options] - Token refresh options
  /// Returns token refresh response
  Future<OAuthTokenRefreshResponse> refreshOAuthToken(
    OAuthTokenRefreshOptions options,
  ) async {
    try {
      final response = await _httpClient.post(
        '/auth/oauth/${options.provider.value}/refresh',
        data: {
          'providerId': options.providerId,
          'refreshToken': options.refreshToken,
        },
      );

      return OAuthTokenRefreshResponse(
        success: true,
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
        expiresAt: response.data['expires_at'],
      );
    } catch (error) {
      return OAuthTokenRefreshResponse(
        success: false,
        error: error.toString(),
      );
    }
  }

  /// Generate OAuth URL for manual redirect (alternative to initiateOAuth)
  /// [options] - OAuth initiation options
  /// Returns OAuth URL
  Future<String> generateOAuthURL(OAuthInitiateOptions options) async {
    final result = await initiateOAuth(
      options.provider,
      options: OAuthFlowOptions(redirectUrl: options.redirectUrl),
    );
    return result.url;
  }

  /// Check if a specific OAuth provider is connected
  /// [provider] - OAuth provider to check
  /// Returns boolean indicating if provider is connected
  Future<bool> isProviderConnected(OAuthProvider provider) async {
    try {
      final connectedProviders = await getConnectedProviders();
      return connectedProviders.providers.any((p) => p.provider == provider);
    } catch (error) {
      return false;
    }
  }

  /// Get information about a specific connected provider
  /// [provider] - OAuth provider to get information for
  /// Returns provider information or null if not connected
  Future<ConnectedOAuthProvider?> getProviderInfo(
      OAuthProvider provider) async {
    try {
      final connectedProviders = await getConnectedProviders();
      return connectedProviders.providers
          .where((p) => p.provider == provider)
          .firstOrNull;
    } catch (error) {
      return null;
    }
  }

  /// Bulk unlink multiple OAuth providers
  /// [providers] - Array of OAuth providers to unlink
  /// Returns array of unlink results
  Future<List<OAuthUnlinkResult>> unlinkMultipleProviders(
    List<OAuthProvider> providers,
  ) async {
    final results = <OAuthUnlinkResult>[];

    for (final provider in providers) {
      try {
        final result = await unlinkOAuthProvider(provider);
        results.add(result);
      } catch (error) {
        results.add(OAuthUnlinkResult(
          success: false,
          message: error.toString(),
          provider: provider,
        ));
      }
    }

    return results;
  }

  /// Get available OAuth providers that can be connected
  /// Returns array of available providers
  Future<List<OAuthProvider>> getAvailableProviders() async {
    try {
      final connectedProviders = await getConnectedProviders();
      return connectedProviders.availableProviders;
    } catch (error) {
      // Return all providers if we can't fetch connected ones
      return OAuthProvider.values;
    }
  }

  /// Sign in with OAuth provider (convenience method)
  /// [provider] - OAuth provider to use for sign in
  /// [redirectUrl] - Optional redirect URL after authentication
  /// Returns OAuth initiation response
  Future<OAuthInitiateResponse> signInWithProvider(
    OAuthProvider provider, {
    String? redirectUrl,
  }) async {
    return initiateOAuth(
      provider,
      options: OAuthFlowOptions(redirectUrl: redirectUrl),
    );
  }

  /// Complete OAuth sign in flow after callback
  /// [callbackData] - OAuth callback data
  /// Returns authentication result
  Future<Session> completeOAuthSignIn(OAuthCallbackData callbackData) async {
    return handleOAuthCallback(
      callbackData.provider,
      callbackData.code,
      callbackData.state,
    );
  }

  /// Complete OAuth provider linking flow after callback
  /// [callbackData] - OAuth callback data
  /// Returns link result
  Future<OAuthLinkResult> completeProviderLinking(
    OAuthCallbackData callbackData,
  ) async {
    return linkOAuthProvider(
      callbackData.provider,
      callbackData.code,
      callbackData.state,
    );
  }

  /// Handle OAuth errors with proper typing and context
  /// [error] - Original error
  /// [provider] - Optional OAuth provider for context
  /// Returns formatted OAuth error
  OAuthError _handleOAuthError(dynamic error, [OAuthProvider? provider]) {
    String message;
    String? code;
    dynamic details;

    if (error is Exception) {
      message = error.toString();
      code = 'UNKNOWN_ERROR';
    } else {
      message = 'Unknown OAuth error';
      code = 'UNKNOWN_ERROR';
    }

    return OAuthError(
      provider: provider,
      code: code,
      details: details,
      message: message,
    );
  }
}
