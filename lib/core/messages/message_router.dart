import 'dart:async';
import 'dart:typed_data';
import 'package:gcs_sockets/core/mavlink/mav_frame.dart';
import 'package:gcs_sockets/core/mavlink/mavlink_parser.dart';
import 'message_type.dart';

class MessageRouter {
  final MavlinkParser _source;

  final Map<MessageType, StreamController<Uint8List>> _controllers = {};

  StreamSubscription? _sub;

  MessageRouter(this._source);

  Stream<Uint8List> packetsFor(MessageType type) {
    return _controllers
        .putIfAbsent(type, () => StreamController<Uint8List>.broadcast())
        .stream;
  }

  void start() {
    _sub = _source.frames.listen(_route);
  }

  void _route(MavFrame frame) {
    final type = decodeMessageType(frame.messageId);
    if (type == null) return;

    final controller = _controllers[type];
    controller?.add(frame.payload);
  }

  void dispose() {
    _sub?.cancel();
    for (final c in _controllers.values) {
      c.close();
    }
  }
}
