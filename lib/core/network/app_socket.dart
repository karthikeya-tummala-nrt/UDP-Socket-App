import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppSocket {

  AppSocket._internal();
  static final AppSocket _instance = AppSocket._internal();
  factory AppSocket() => _instance;
  WebSocketChannel? _channel;

  final StreamController<dynamic> _localController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get stream => _localController.stream;

  bool _isManualDisconnect = false;

  void connect() {
    if (_channel != null) return;
    _isManualDisconnect = false;

    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse('ws://localhost:30000'),
        pingInterval: const Duration(seconds: 5),
      );

      // Listen to the actual channel stream
      _channel!.stream.listen(
            (message) {
          _localController.add(message);
        },
        onError: (error) {
          print("Socket Error: $error");
          _retry();
        },
        onDone: () {
          print("Socket Closed");
          if (!_isManualDisconnect) _retry();
        },
      );

      print("Successfully connected to GCS Server");
    } catch (e) {
      print("Connection error: $e");
      _retry();
    }
  }

  void _retry() {
    _channel = null;
    if (_isManualDisconnect) return;

    print("Attempting to reconnect in 3 seconds...");
    Future.delayed(const Duration(seconds: 3), () {
      connect();
    });
  }

  void send(dynamic data) {
    if (_channel != null && _channel!.sink != null) {
      _channel!.sink.add(data);
    } else {
      print("Cannot send data: Socket not connected.");
    }
  }

  void disconnect() {
    _isManualDisconnect = true;
    _channel?.sink.close();
    _channel = null;
  }
}
