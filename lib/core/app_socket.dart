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

  Stream<String> get stream => _streamController.stream;
  bool get isConnected => _channel != null;

  void connect(String url) {
    if (_channel != null) {
      return; // prevent multiple connections
    }

    _channel = WebSocketChannel.connect(Uri.parse(url));

    _socketSubscription = _channel!.stream.listen(
      (message) {
        if (message is String) {
          _streamController.add(message);
        } else if (message is Uint8List) {
          final decoded = String.fromCharCodes(message);
          _streamController.add(decoded);
        }
      },
      onError: (error) {
        print('Socket error: $error');
      },
      onDone: () {
        print('Socket closed');
        _cleanup();
      },
      cancelOnError: true,
    );
  }

  void disconnect() {
    _cleanup();
  }

  void _cleanup() {
    _socketSubscription?.cancel();
    _socketSubscription = null;

    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _cleanup();
    _streamController.close();
  }
}
