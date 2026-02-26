import 'dart:async';
import 'dart:typed_data';
import '../udp_data_source.dart';
import 'message_type.dart';

class MessageRouter {
  final UdpDataSource _source;

  final Map<MessageType, StreamController<Uint8List>> _controllers = {};

  StreamSubscription? _sub;

  MessageRouter(this._source);

  Stream<Uint8List> packetsFor(MessageType type) {
    return _controllers
        .putIfAbsent(type, () => StreamController<Uint8List>.broadcast())
        .stream;
  }

  void start() {
    _sub = _source.rawPackets.listen(_route);
  }

  void _route(Uint8List bytes) {
    if (bytes.isEmpty) return;

    final type = decodeMessageType(bytes[0]);
    if (type == null) return;

    final controller = _controllers[type];
    controller?.add(bytes);
  }

  void dispose() {
    _sub?.cancel();
    for (final c in _controllers.values) {
      c.close();
    }
  }
}
