import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../common/types.dart';
import '../common/exceptions.dart';
import '../utils/session_manager.dart';

/// Realtime subscription
class RealtimeSubscription {
  final String channel;
  final void Function(RealtimeMessage) onMessage;
  final void Function(dynamic)? onError;
  final void Function()? onClose;

  RealtimeSubscription({
    required this.channel,
    required this.onMessage,
    this.onError,
    this.onClose,
  });
}

/// Presence data
class PresenceData {
  final String userId;
  final Map<String, dynamic> metadata;
  final DateTime joinedAt;

  PresenceData({
    required this.userId,
    required this.metadata,
    required this.joinedAt,
  });
}

/// Realtime module for real-time subscriptions
class RealtimeModule {
  final ClientConfig _config;
  final SessionManager _sessionManager;

  io.Socket? _socket;
  final Map<String, RealtimeSubscription> _subscriptions = {};
  final Map<String, Set<PresenceData>> _presenceData = {};
  final _eventController = StreamController<RealtimeMessage>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  bool _autoReconnect = true;
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  RealtimeModule(this._config, this._sessionManager);

  /// Connection status stream
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Event stream
  Stream<RealtimeMessage> get eventStream => _eventController.stream;

  /// Check if connected
  bool get isConnected => _socket?.connected ?? false;

  /// Connect to realtime server
  Future<void> connect({
    bool autoReconnect = true,
    Map<String, dynamic>? options,
  }) async {
    _autoReconnect = autoReconnect;

    if (_socket?.connected ?? false) {
      return;
    }

    final url =
        _config.realtimeUrl ?? _config.baseUrl ?? 'http://localhost:8080';

    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({
            'token': _config.apiKey,
            'sessionToken': _sessionManager.currentSession?.accessToken,
          })
          .setReconnectionAttempts(autoReconnect ? 10 : 0)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .enableAutoConnect()
          .setExtraHeaders(_config.headers)
          .build(),
    );

    _setupEventHandlers();

    // Wait for connection
    final completer = Completer<void>();
    StreamSubscription? sub;

    _socket!.onConnect((_) {
      completer.complete();
    });

    _socket!.connect();

    await completer.future.timeout(
      _config.timeout,
      onTimeout: () {
        throw TimeoutException('Failed to connect to realtime server');
      },
    );
  }

  /// Setup socket event handlers
  void _setupEventHandlers() {
    _socket!.onConnect((_) {
      if (_config.debug) {
        print('Socket connected');
      }
      _connectionController.add(true);
      _reconnectAttempts = 0;

      // Resubscribe to channels
      for (final sub in _subscriptions.values) {
        _socket!.emit('subscribe', {'channel': sub.channel});
      }
    });

    _socket!.onDisconnect((_) {
      if (_config.debug) {
        print('Socket disconnected');
      }
      _connectionController.add(false);

      if (_autoReconnect) {
        _scheduleReconnect();
      }
    });

    _socket!.onError((error) {
      if (_config.debug) {
        print('Socket error: $error');
      }

      for (final sub in _subscriptions.values) {
        sub.onError?.call(error);
      }
    });

    _socket!.on('message', (data) {
      final message = RealtimeMessage.fromJson(data);

      _eventController.add(message);

      final subscription = _subscriptions[message.channel];
      subscription?.onMessage(message);
    });

    _socket!.on('presence', (data) {
      final channel = data['channel'] as String;
      final event = data['event'] as String;
      final userData = data['data'] as Map<String, dynamic>;

      if (!_presenceData.containsKey(channel)) {
        _presenceData[channel] = {};
      }

      final presence = PresenceData(
        userId: userData['userId'],
        metadata: userData['metadata'] ?? {},
        joinedAt: DateTime.parse(userData['joinedAt']),
      );

      switch (event) {
        case 'join':
          _presenceData[channel]!.add(presence);
          break;
        case 'leave':
          _presenceData[channel]!
              .removeWhere((p) => p.userId == presence.userId);
          break;
        case 'update':
          _presenceData[channel]!
              .removeWhere((p) => p.userId == presence.userId);
          _presenceData[channel]!.add(presence);
          break;
      }
    });
  }

  /// Subscribe to a channel
  RealtimeSubscription subscribe(
    String channel, {
    required void Function(RealtimeMessage) onMessage,
    void Function(dynamic)? onError,
    void Function()? onClose,
  }) {
    final subscription = RealtimeSubscription(
      channel: channel,
      onMessage: onMessage,
      onError: onError,
      onClose: onClose,
    );

    _subscriptions[channel] = subscription;

    if (_socket?.connected ?? false) {
      _socket!.emit('subscribe', {'channel': channel});
    }

    return subscription;
  }

  /// Unsubscribe from a channel
  void unsubscribe(String channel) {
    _subscriptions.remove(channel);

    if (_socket?.connected ?? false) {
      _socket!.emit('unsubscribe', {'channel': channel});
    }
  }

  /// Send a message to a channel
  Future<void> send(String channel, String event, dynamic data) async {
    if (!(_socket?.connected ?? false)) {
      throw RealtimeException('Not connected to realtime server');
    }

    _socket!.emit('message', {
      'channel': channel,
      'event': event,
      'data': data,
    });
  }

  /// Join presence for a channel
  Future<void> joinPresence(
    String channel, {
    Map<String, dynamic>? metadata,
  }) async {
    if (!(_socket?.connected ?? false)) {
      throw RealtimeException('Not connected to realtime server');
    }

    _socket!.emit('presence:join', {
      'channel': channel,
      'metadata': metadata ?? {},
    });
  }

  /// Leave presence for a channel
  Future<void> leavePresence(String channel) async {
    if (!(_socket?.connected ?? false)) {
      throw RealtimeException('Not connected to realtime server');
    }

    _socket!.emit('presence:leave', {
      'channel': channel,
    });
  }

  /// Update presence metadata
  Future<void> updatePresence(
    String channel, {
    required Map<String, dynamic> metadata,
  }) async {
    if (!(_socket?.connected ?? false)) {
      throw RealtimeException('Not connected to realtime server');
    }

    _socket!.emit('presence:update', {
      'channel': channel,
      'metadata': metadata,
    });
  }

  /// Get presence data for a channel
  Set<PresenceData> getPresence(String channel) {
    return _presenceData[channel] ?? {};
  }

  /// Schedule reconnection
  void _scheduleReconnect() {
    _reconnectTimer?.cancel();

    if (_reconnectAttempts >= 10) {
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);

    _reconnectTimer = Timer(delay, () {
      connect(autoReconnect: _autoReconnect);
    });
  }

  /// Disconnect from realtime server
  Future<void> disconnect() async {
    _autoReconnect = false;
    _reconnectTimer?.cancel();

    for (final sub in _subscriptions.values) {
      sub.onClose?.call();
    }

    _subscriptions.clear();
    _presenceData.clear();

    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;

    _connectionController.add(false);
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _eventController.close();
    _connectionController.close();
  }
}
