import 'dart:async';
import 'dart:typed_data';
import '../udp_data_source.dart';
import 'message_type.dart';

class MessageRouter {
  final UdpDataSource _source;

  final _batteryController = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get batteryPackets => _batteryController.stream;

  StreamSubscription? _sub;

  MessageRouter(this._source);

  void start() {
    _sub = _source.rawPackets.listen(_route);
  }

  void _route(Uint8List bytes) {
    if (bytes.isEmpty) return;

    final type = decodeMessageType(bytes[0]);

    switch (type) {
      case MessageType.batteryTelemetry:
        _batteryController.add(bytes);
        break;
    }
  }

  void dispose() {
    _sub?.cancel();
    _batteryController.close();
  }
}