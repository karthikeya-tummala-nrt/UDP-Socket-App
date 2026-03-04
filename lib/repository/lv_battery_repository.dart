import 'dart:async';
import 'dart:typed_data';
import 'package:gcs_sockets/core/messages/message_type.dart';

import '../core/messages/message_router.dart';
import '../models/lv_battery_status.dart';
import '../utils/binary_parser.dart';

class LvBatteryRepository {
  final MessageRouter _router;

  final _controller = StreamController<LvBatteryStatus>.broadcast();
  Stream<LvBatteryStatus> get stream => _controller.stream;

  StreamSubscription<Uint8List>? _sub;

  LvBatteryRepository(this._router);

  void start() {
    if (_sub != null) return;
    _sub = _router.packetsFor(MessageType.lvBattery).listen(_handlePacket);
  }

  void _handlePacket(Uint8List bytes) {
    if (bytes.length < LvBatteryStatus.packetSize) return;

    try {
      final status = _parse(bytes);
      _controller.add(status);
    } catch (_) {}
  }

  LvBatteryStatus _parse(Uint8List bytes) {
    int cursor = 0;

    final voltageRaw =
    parseBinaryData(bytes, cursor, 2, isSigned: false, isBigEndian: false);
    cursor += 2;

    final currentRaw =
    parseBinaryData(bytes, cursor, 2, isSigned: true, isBigEndian: false);

    final voltage = voltageRaw / 10.0;
    final current = currentRaw / 10.0;

    return LvBatteryStatus(
      voltage: voltage,
      current: current,
    );
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}