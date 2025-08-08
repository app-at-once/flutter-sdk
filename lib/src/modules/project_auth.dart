import '../utils/http_client.dart';
import '../common/types.dart';

/// Project-specific authentication module
/// Handles authentication for multi-tenant projects where each project has its own user database
class ProjectAuthModule {
  final HttpClient _httpClient;
  String? _projectId;
  String? _appId;
  AuthUser? _currentUser;
  Session? _currentSession;

  ProjectAuthModule(this._httpClient, {String? projectId, String? appId})
      : _projectId = projectId,
        _appId = appId;

  /// Set the project context for authentication
  void setProject(String projectId) {
    _projectId = projectId;
  }

  /// Set the app context for authentication
  void setApp(String appId) {
    _appId = appId;
  }

  /// Get current user
  AuthUser? get currentUser => _currentUser;

  /// Get current session
  Session? get currentSession => _currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentSession != null && _currentUser != null;

  /// Sign up a new user in the project's user database
  /// [credentials] - User signup credentials
  /// Returns authentication session
  Future<Session> signUp(SignUpCredentials credentials) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    final response = await _httpClient.post('/data/users/auth/signup', data: {
      'email': credentials.email,
      'password': credentials.password,
      'name': credentials.name,
      'metadata': credentials.metadata ?? {},
    });

    final session = Session.fromJson(response.data);
    _currentSession = session;
    _currentUser = session.user;

    return session;
  }

  /// Sign in an existing user
  /// [credentials] - User signin credentials
  /// Returns authentication session
  Future<Session> signIn(SignInCredentials credentials) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    final response = await _httpClient.post('/data/users/auth/signin', data: {
      'email': credentials.email,
      'password': credentials.password,
    });

    final session = Session.fromJson(response.data);
    _currentSession = session;
    _currentUser = session.user;

    return session;
  }

  /// Sign out the current user
  Future<void> signOut() async {
    if (_currentSession == null) return;

    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    await _httpClient.post('/data/users/auth/signout');

    _currentSession = null;
    _currentUser = null;
  }

  /// Refresh the authentication session
  /// Returns new authentication session
  Future<Session> refreshSession() async {
    if (_currentSession?.refreshToken == null) {
      throw Exception('No refresh token available');
    }

    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    final response = await _httpClient.post('/data/users/auth/refresh', data: {
      'refresh_token': _currentSession!.refreshToken,
    });

    final session = Session.fromJson(response.data);
    _currentSession = session;
    _currentUser = session.user;

    return session;
  }

  /// Update user profile
  /// [updates] - Profile updates
  /// Returns updated user
  Future<AuthUser> updateProfile(Map<String, dynamic> updates) async {
    if (_currentUser == null) {
      throw Exception('User must be authenticated to update profile');
    }

    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    final response =
        await _httpClient.patch('/data/users/auth/me', data: updates);

    final user = AuthUser.fromJson(response.data['user']);
    _currentUser = user;

    return user;
  }

  /// Change user password
  /// [currentPassword] - Current password
  /// [newPassword] - New password
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    if (_currentUser == null) {
      throw Exception('User must be authenticated to change password');
    }

    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    await _httpClient.post('/data/users/auth/change-password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  /// Request password reset
  /// [email] - User email
  Future<void> requestPasswordReset(String email) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    await _httpClient.post('/data/users/auth/reset-password', data: {
      'email': email,
    });
  }

  /// Confirm password reset
  /// [token] - Reset token
  /// [newPassword] - New password
  Future<void> confirmPasswordReset(String token, String newPassword) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    await _httpClient.post('/data/users/auth/confirm-reset', data: {
      'token': token,
      'password': newPassword,
    });
  }

  /// Verify email address
  /// [token] - Verification token
  Future<void> verifyEmail(String token) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    await _httpClient.post('/data/users/auth/verify-email', data: {
      'token': token,
    });

    // Update current user if authenticated
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(emailVerified: true);
    }
  }

  /// Resend email verification
  Future<void> resendEmailVerification() async {
    if (_currentUser == null) {
      throw Exception('User must be authenticated to resend verification');
    }

    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    await _httpClient.post('/data/users/auth/resend-verification');
  }

  /// Delete user account
  /// [password] - Current password for confirmation
  Future<void> deleteAccount(String password) async {
    if (_currentUser == null) {
      throw Exception('User must be authenticated to delete account');
    }

    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use the multi-tenant auth endpoint
    await _httpClient.post('/data/users/auth/delete-account', data: {
      'password': password,
    });

    _currentSession = null;
    _currentUser = null;
  }

  /// Get the current authenticated user
  /// Returns current user or null if not authenticated
  Future<AuthUser?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    try {
      // Use the multi-tenant auth endpoint
      final response = await _httpClient.get('/data/users/auth/me');

      if (response.data != null && response.data['user'] != null) {
        _currentUser = AuthUser.fromJson(response.data['user']);
        return _currentUser;
      }

      return null;
    } catch (e) {
      // User not authenticated
      return null;
    }
  }

  /// Get user by ID (admin function)
  /// [userId] - User ID
  /// Returns user information
  Future<AuthUser> getUser(String userId) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Note: Admin functions might need different implementation
    // For now, using data API to fetch user
    final response = await _httpClient.get('/data/users/$userId');
    return AuthUser.fromJson(response.data);
  }

  /// List users (admin function)
  /// [options] - Filter and pagination options
  /// Returns paginated list of users
  Future<UserListResponse> listUsers({
    int? limit,
    int? offset,
    String? search,
    bool? verified,
    bool? active,
  }) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use data API for listing users
    final queryParams = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (search != null) 'search': search,
      if (verified != null) 'email_verified': verified,
      if (active != null) 'active': active,
    };

    final response = await _httpClient.get('/data/users', params: queryParams);
    return UserListResponse(
      users: (response.data['data'] as List)
          .map((e) => AuthUser.fromJson(e))
          .toList(),
      total: response.data['total'] ?? response.data['data'].length,
    );
  }

  /// Update user (admin function)
  /// [userId] - User ID
  /// [updates] - User updates
  /// Returns updated user
  Future<AuthUser> updateUser(
      String userId, Map<String, dynamic> updates) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use data API for updating user
    final response =
        await _httpClient.patch('/data/users/$userId', data: updates);
    return AuthUser.fromJson(response.data);
  }

  /// Delete user (admin function)
  /// [userId] - User ID
  Future<void> deleteUser(String userId) async {
    if (_projectId == null && _appId == null) {
      throw Exception('Project ID or App ID must be set before authentication');
    }

    // Use data API for deleting user
    await _httpClient.delete('/data/users/$userId');
  }
}

// Supporting classes

class UserListResponse {
  final List<AuthUser> users;
  final int total;

  const UserListResponse({
    required this.users,
    required this.total,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      UserListResponse(
        users:
            (json['users'] as List).map((e) => AuthUser.fromJson(e)).toList(),
        total: json['total'],
      );
}

// Extension for AuthUser copyWith method
extension AuthUserCopyWith on AuthUser {
  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    Map<String, dynamic>? metadata,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      metadata: metadata ?? this.metadata,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
