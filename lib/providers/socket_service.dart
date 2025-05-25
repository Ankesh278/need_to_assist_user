import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();
  late IO.Socket socket;
  void connect() {
    socket = IO.io('http:needtoassist.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setReconnectionAttempts(5)
            .setTimeout(5000)
            .build()
    );

    socket.connect();
    socket.onConnect((_) {
      if (kDebugMode) {
        print('✅ Socket connected!');
      }
    });

    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('❌ Socket disconnected!');
      }
    });

    socket.onConnectError((data) {
      if (kDebugMode) {
        print('⚠️ Connect Error: $data');
      }
    });

    socket.onError((data) {
      if (kDebugMode) {
        print('⚠️ General Error: $data');
      }
    });
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    socket.on('message', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  void sendMessage(String message, String userId) {
    socket.emit('message', {
      'senderId': userId,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  bool isConnected() {
    return socket.connected;
  }
}