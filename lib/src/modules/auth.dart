import 'dart:async';
import '../common/types.dart';
import '../common/exceptions.dart';
import '../utils/http_client.dart';
import '../utils/session_manager.dart';

/// Authentication options
class AuthOptions {
  final bool rememberMe;
  final Map<String, dynamic>? metadata;
  final String? redirectTo;

  const AuthOptions({
    this.rememberMe = false,
    this.metadata,
    this.redirectTo,
  });
}

/// Password reset options
class PasswordResetOptions {
  final String? redirectTo;
  final String? emailRedirectTo;

  const PasswordResetOptions({
    this.redirectTo,
    this.emailRedirectTo,
  });
}

/// Auth module for authentication operations
class AuthModule {
  final HttpClient _httpClient;
  final SessionManager _sessionManager;

  AuthModule(this._httpClient, this._sessionManager);

  /// Get current session
  Session? get currentSession => _sessionManager.currentSession;

  /// Get current user
  AuthUser? get currentUser => _sessionManager.currentSession?.user;

  /// Session stream
  Stream<Session?> get sessionStream => _sessionManager.sessionStream;

  /// Sign up with email and password
  Future<Session> signUp({
    required String email,
    required String password,
    String? name,
    AuthOptions? options,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'options': options != null
            ? {
                'rememberMe': options.rememberMe,
                'metadata': options.metadata,
                'redirectTo': options.redirectTo,
              }
            : null,
      },
    );

    final session = Session.fromJson(response);
    await _sessionManager.setSession(session);
    return session;
  }

  /// Sign in with email and password
  Future<Session> signIn({
    required String email,
    required String password,
    AuthOptions? options,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/signin',
      data: {
        'email': email,
        'password': password,
        'options': options != null
            ? {
                'rememberMe': options.rememberMe,
                'metadata': options.metadata,
              }
            : null,
      },
    );

    final session = Session.fromJson(response);
    await _sessionManager.setSession(session);
    return session;
  }

  /// Sign in with OAuth provider
  Future<String> signInWithOAuth({
    required String provider,
    String? redirectTo,
    List<String>? scopes,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/oauth/$provider',
      data: {
        'redirectTo': redirectTo,
        'scopes': scopes,
      },
    );

    return response['url'] as String;
  }

  /// Handle OAuth callback
  Future<Session> handleOAuthCallback({
    required String provider,
    required String code,
    String? state,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/oauth/$provider/callback',
      data: {
        'code': code,
        'state': state,
      },
    );

    final session = Session.fromJson(response);
    await _sessionManager.setSession(session);
    return session;
  }

  /// Sign in with magic link
  Future<void> signInWithMagicLink({
    required String email,
    String? redirectTo,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/auth/magic-link',
      data: {
        'email': email,
        'redirectTo': redirectTo,
      },
    );
  }

  /// Verify magic link token
  Future<Session> verifyMagicLink({
    required String token,
    required String email,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/magic-link/verify',
      data: {
        'token': token,
        'email': email,
      },
    );

    final session = Session.fromJson(response);
    await _sessionManager.setSession(session);
    return session;
  }

  /// Request password reset
  Future<void> requestPasswordReset({
    required String email,
    PasswordResetOptions? options,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/auth/password-reset',
      data: {
        'email': email,
        'options': options != null
            ? {
                'redirectTo': options.redirectTo,
                'emailRedirectTo': options.emailRedirectTo,
              }
            : null,
      },
    );
  }

  /// Reset password with token
  Future<Session> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/password-reset/verify',
      data: {
        'token': token,
        'password': newPassword,
      },
    );

    final session = Session.fromJson(response);
    await _sessionManager.setSession(session);
    return session;
  }

  /// Update user profile
  Future<AuthUser> updateProfile({
    String? name,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _httpClient.patch<Map<String, dynamic>>(
      '/auth/profile',
      data: {
        'name': name,
        'avatarUrl': avatarUrl,
        'metadata': metadata,
      },
    );

    final user = AuthUser.fromJson(response);
    await _sessionManager.updateUser(user);
    return user;
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/auth/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  /// Refresh session
  Future<Session> refreshSession() async {
    final refreshed = await _sessionManager.refreshSession();
    if (!refreshed) {
      throw AuthException('Failed to refresh session');
    }
    return _sessionManager.currentSession!;
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _httpClient.post<Map<String, dynamic>>('/auth/signout');
    } catch (e) {
      // Ignore errors during signout
    } finally {
      await _sessionManager.clearSession();
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    await _httpClient.delete<Map<String, dynamic>>('/auth/account');
    await _sessionManager.clearSession();
  }

  /// Verify email with token
  Future<void> verifyEmail({
    required String token,
  }) async {
    await _httpClient.post<Map<String, dynamic>>(
      '/auth/verify-email',
      data: {'token': token},
    );
  }

  /// Resend verification email
  Future<void> resendVerificationEmail() async {
    await _httpClient.post<Map<String, dynamic>>(
      '/auth/resend-verification',
    );
  }

  /// Check if email exists
  Future<bool> checkEmailExists(String email) async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/auth/check-email',
      params: {'email': email},
    );

    return response['exists'] as bool;
  }
}
