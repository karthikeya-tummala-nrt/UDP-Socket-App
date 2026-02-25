import 'dart:async';
import 'dart:typed_data';
import '../core/messages/message_router.dart';
import '../models/battery_telemetry.dart';
import '../utils/binary_parser.dart';

class BatteryRepository {
  final MessageRouter _router;

  final StreamController<BatteryTelemetry> _controller =
      StreamController<BatteryTelemetry>.broadcast();

  StreamSubscription<Uint8List>? _sub;

  BatteryTelemetry? _latest;

  BatteryRepository(this._router);

  BatteryTelemetry? get latest => _latest;

  Stream<BatteryTelemetry> get stream => _controller.stream;

  void start() {
    if (_sub != null) return;

    _sub = _router.batteryPackets.listen(_handlePacket);
  }

  void _handlePacket(Uint8List bytes) {
    if (bytes.length < BatteryTelemetry.packetSize) return;

    try {
      final telemetry = _parse(bytes);
      _latest = telemetry;
      _controller.add(telemetry);
    } catch (e) {
      _controller.addError(e);
    }
  }

  BatteryTelemetry _parse(Uint8List bytes) {
    int cursor = 1;

    final socField = BatteryTelemetry.socField;
    final soc = parseBinaryData(
      bytes,
      cursor,
      socField.size,
      isSigned: socField.isSigned,
      isBigEndian: socField.endianness == Endianness.big,
    );

    cursor += socField.size;

    final currentField = BatteryTelemetry.currentField;
    final current = parseBinaryData(
      bytes,
      cursor,
      currentField.size,
      isSigned: currentField.isSigned,
      isBigEndian: currentField.endianness == Endianness.big,
    );

    return BatteryTelemetry(soc: soc, current: current);
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
