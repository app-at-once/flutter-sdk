import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../common/types.dart';
import 'http_client.dart';

/// Manages user session and authentication state
class SessionManager {
  static const String _sessionKey = 'appatonce_session';
  static const String _userKey = 'appatonce_user';

  final FlutterSecureStorage _storage;
  final HttpClient _httpClient;

  Session? _currentSession;
  final _sessionController = StreamController<Session?>.broadcast();
  Timer? _refreshTimer;

  SessionManager(this._storage, this._httpClient) {
    _loadSession();
  }

  /// Current session
  Session? get currentSession => _currentSession;

  /// Session stream
  Stream<Session?> get sessionStream => _sessionController.stream;

  /// Check if user is authenticated
  bool get isAuthenticated =>
      _currentSession != null && !_currentSession!.isExpired;

  /// Load session from secure storage
  Future<void> _loadSession() async {
    try {
      final sessionJson = await _storage.read(key: _sessionKey);
      if (sessionJson != null) {
        final session = Session.fromJson(json.decode(sessionJson));
        if (!session.isExpired) {
          await setSession(session);
        } else {
          await clearSession();
        }
      }
    } catch (e) {
      print('Error loading session: $e');
    }
  }

  /// Set the current session
  Future<void> setSession(Session session) async {
    _currentSession = session;
    _sessionController.add(session);

    // Save to secure storage
    await _storage.write(
      key: _sessionKey,
      value: json.encode(session.toJson()),
    );

    // Update HTTP client auth token
    _httpClient.setAuthToken(session.accessToken);

    // Schedule token refresh
    _scheduleTokenRefresh(session);
  }

  /// Clear the current session
  Future<void> clearSession() async {
    _currentSession = null;
    _sessionController.add(null);

    // Clear from storage
    await _storage.delete(key: _sessionKey);
    await _storage.delete(key: _userKey);

    // Clear auth token
    _httpClient.setAuthToken(null);

    // Cancel refresh timer
    _refreshTimer?.cancel();
  }

  /// Refresh the session
  Future<bool> refreshSession() async {
    if (_currentSession?.refreshToken == null) {
      return false;
    }

    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': _currentSession!.refreshToken},
      );

      final newSession = Session.fromJson(response);
      await setSession(newSession);
      return true;
    } catch (e) {
      print('Error refreshing session: $e');
      await clearSession();
      return false;
    }
  }

  /// Schedule automatic token refresh
  void _scheduleTokenRefresh(Session session) {
    _refreshTimer?.cancel();

    // Refresh 5 minutes before expiry
    final refreshTime = session.expiresAt.subtract(const Duration(minutes: 5));
    final now = DateTime.now();

    if (refreshTime.isAfter(now)) {
      final duration = refreshTime.difference(now);
      _refreshTimer = Timer(duration, () async {
        await refreshSession();
      });
    }
  }

  /// Update user data
  Future<void> updateUser(AuthUser user) async {
    if (_currentSession != null) {
      final updatedSession = Session(
        accessToken: _currentSession!.accessToken,
        refreshToken: _currentSession!.refreshToken,
        user: user,
        expiresAt: _currentSession!.expiresAt,
      );
      await setSession(updatedSession);
    }
  }

  /// Dispose resources
  void dispose() {
    _refreshTimer?.cancel();
    _sessionController.close();
  }
}
