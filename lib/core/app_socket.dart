import 'dart:async';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppSocket {
  AppSocket._internal();

  static final AppSocket _instance = AppSocket._internal();

  factory AppSocket() => _instance;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;

  final StreamController<String> _streamController =
      StreamController<String>.broadcast();

  final Duration retryDelay = Duration(seconds: 5);

  Stream<String> get stream => _streamController.stream;

  bool get isConnected => _channel != null;

  bool _manualDisconnect = false;

  void connect(String url) {
    if (_channel != null) return;

    _manualDisconnect = false; // reset manual flag

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _socketSubscription = _channel!.stream.listen(
            (message) {
          if (message is String) {
            _streamController.add(message);
          } else if (message is Uint8List) {
            _streamController.add(String.fromCharCodes(message));
          }
        },
        onError: (error) {
          print('Socket error: $error');
          if (!_manualDisconnect) _reconnect(url);
        },
        onDone: () {
          print('Socket closed');
          if (!_manualDisconnect) _reconnect(url);
          _cleanup();
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Failed to connect: $e');
      if (!_manualDisconnect) _reconnect(url);
    }
  }

  void _reconnect(String url) {
    _cleanup();
    print('Reconnecting in ${retryDelay.inSeconds} seconds...');
    Future.delayed(retryDelay, () => connect(url));
  }

  void disconnect() {
    _manualDisconnect = true;
    _cleanup();
  }

  void _cleanup() {
    _socketSubscription?.cancel();
    _socketSubscription = null;

    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _manualDisconnect = true;
    _cleanup();
    _streamController.close();
  }
}
