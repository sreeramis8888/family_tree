import 'package:familytree/src/data/globals.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer';

typedef MessageCallback = void Function(Map<String, dynamic> message);
typedef StatusCallback = void Function(SocketStatus status);

enum SocketStatus { connected, disconnected, connecting, error }

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  SocketStatus status = SocketStatus.disconnected;
  bool debug = true;
  StatusCallback? onStatusChange;

  void connect() {
    if (_socket != null && _socket!.connected) {
      _log("Socket already connected. Skipping new connection.");
      return;
    }

    _log("Connecting to socket...");
    status = SocketStatus.connecting;
    _notifyStatus();

    _socket = IO.io(
      'http://192.168.1.5:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'extraHeaders': {
          'token': token, 
        },
        'query': {
          'userId': id,
        },
      },
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      status = SocketStatus.connected;
      _log("Connected to socket. Socket ID: ${_socket?.id}");
      _notifyStatus();
    });

    _socket!.onDisconnect((_) {
      status = SocketStatus.disconnected;
      _log("Disconnected from socket.");
      _notifyStatus();
    });

    _socket!.onError((err) {
      status = SocketStatus.error;
      _log("Socket error: $err");
      _notifyStatus();
    });

    _socket!.onConnectError((err) {
      status = SocketStatus.error;
      _log("Socket connection error: $err");
      _notifyStatus();
    });
  }

  void disconnect() {
    _log("Disconnecting socket...");
    _socket?.disconnect();
    _socket = null;
    status = SocketStatus.disconnected;
    _notifyStatus();
  }

  void joinRoom(String conversationId) {
    _log("Joining room: $conversationId");
    _socket?.emit('join_conversation', {'conversationId': conversationId});
  }

  void leaveRoom(String conversationId) {
    _log("Leaving room: $conversationId");
    _socket?.emit('leave_conversation', {'conversationId': conversationId});
  }

  void onMessage(MessageCallback callback) {
    _log("Listening to 'new_message' events");
    _socket?.on('new_message', (data) {
      _log("Message received: $data");
      if (data is Map<String, dynamic>) {
        callback(data);
      } else if (data is Map) {
        callback(Map<String, dynamic>.from(data));
      } else {
        _log("Invalid message format: $data");
      }
    });
  }

  // void sendTyping(String conversationId) {
  //   _log("Sending typing event for $conversationId");
  //   _socket?.emit('typing_start', {'conversationId': conversationId, 'userId': id});
  // }

  // void sendStopTyping(String conversationId) {
  //   _log("Sending stop_typing event for $conversationId");
  //   _socket?.emit('typing_stop', {'conversationId': conversationId, 'userId': id});
  // }

  // void onTyping(void Function(String userId) callback) {
  //   _log("Listening to 'typing' events");
  //   _socket?.on('typing', (data) {
  //     if (data is Map && data['userId'] != null) {
  //       callback(data['userId']);
  //     }
  //   });
  // }

  // void onStopTyping(void Function(String userId) callback) {
  //   _log("Listening to 'stop_typing' events");
  //   _socket?.on('stop_typing', (data) {
  //     if (data is Map && data['userId'] != null) {
  //       callback(data['userId']);
  //     }
  //   });
  // }


  void onUserStatusUpdate(
      void Function(String userId, String status, String? lastSeen) callback) {
    _log("Listening to 'user_status_update' events");
    _socket?.on('user_status_update', (data) {
      if (data is Map && data['userId'] != null && data['status'] != null) {
        callback(
          data['userId'].toString(),
          data['status'].toString(),
          data['lastSeen']?.toString(),
        );
      }
    });
  }

  void onMessagesRead(
      void Function(
              String conversationId, List<String> messageIds, String readBy)
          callback) {
    _log("Listening to 'messages_read' events");
    _socket?.on('messages_read', (data) {
      if (data is Map &&
          data['conversationId'] != null &&
          data['messageIds'] != null &&
          data['readBy'] != null) {
        final ids =
            (data['messageIds'] as List).map((e) => e.toString()).toList();
        callback(
            data['conversationId'].toString(), ids, data['readBy'].toString());
      }
    });
  }

  void onUserTyping(
      void Function(String userId, String conversationId) callback) {
    _log("Listening to 'user_typing' events");
    _socket?.on('user_typing', (data) {
      if (data is Map &&
          data['userId'] != null &&
          data['conversationId'] != null) {
        callback(data['userId'].toString(), data['conversationId'].toString());
      }
    });
  }

  void onUserStopTyping(
      void Function(String userId, String conversationId) callback) {
    _log("Listening to 'user_stop_typing' events");
    _socket?.on('user_stop_typing', (data) {
      if (data is Map &&
          data['userId'] != null &&
          data['conversationId'] != null) {
        callback(data['userId'].toString(), data['conversationId'].toString());
      }
    });
  }

  void onPresenceUpdate(void Function(String userId, String status) callback) {
    _log("Listening to 'update_presence' events");
    _socket?.on('update_presence', (data) {
      if (data is Map && data['userId'] != null && data['status'] != null) {
        callback(data['userId'].toString(), data['status'].toString());
      }
    });
  }

  void _log(String message) {
    if (debug) {
      log('[SocketService] $message');
    }
  }

  void _notifyStatus() {
    if (onStatusChange != null) {
      onStatusChange!(status);
    }
  }

  // Public methods to emit typing events
  void emitTypingStart(String? conversationId, String userId) {
    if (_socket != null && _socket!.connected && conversationId != null) {
      _socket!.emit('typing_start', {
        'conversationId': conversationId,
        'userId': userId,
      });
    }
  }

  void emitTypingStop(String? conversationId, String userId) {
    if (_socket != null && _socket!.connected && conversationId != null) {
      _socket!.emit('typing_stop', {
        'conversationId': conversationId,
        'userId': userId,
      });
    }
  }

  // Emit message delivered event
  void emitMessageDelivered(String messageId) {
    if (_socket != null && _socket!.connected && messageId.isNotEmpty) {
      _log("Emitting message_delivered for $messageId");
      _socket!.emit('message_delivered', {
        'messageId': messageId,
      });
    }
  }

  // Emit message read event
  void emitMessageRead(String messageId) {
    if (_socket != null && _socket!.connected && messageId.isNotEmpty) {
      _log("Emitting message_read for $messageId");
      _socket!.emit('message_read', {
        'messageId': messageId,
      });
    }
  }
}
