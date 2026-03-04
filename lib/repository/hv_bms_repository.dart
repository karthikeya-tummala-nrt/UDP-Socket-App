import 'dart:async';
import 'dart:typed_data';
import 'package:gcs_sockets/core/messages/message_type.dart';
import '../core/messages/message_router.dart';
import '../models/hv_bms_telemetry.dart';
import '../utils/binary_parser.dart';

class HvBmsRepository {
  final MessageRouter _router;

  final _controller = StreamController<HvBmsTelemetry>.broadcast();

  Stream<HvBmsTelemetry> get stream => _controller.stream;

  StreamSubscription<Uint8List>? _sub;

  HvBmsRepository(this._router);

  void start() {
    if (_sub != null) return;
    _sub = _router.packetsFor(MessageType.hvBms).listen(_handlePacket);
  }

  void _handlePacket(Uint8List bytes) {
    if (bytes.length < HvBmsTelemetry.packetSize) return;

    try {
      final telemetry = _parse(bytes);
      _controller.add(telemetry);
    } catch (_) {}
  }

  HvBmsTelemetry _parse(Uint8List bytes) {
    int cursor = 0;

    double readU16() {
      final v = parseBinaryData(
        bytes,
        cursor,
        2,
        isSigned: false,
        isBigEndian: false,
      );
      cursor += 2;
      return v.toDouble();
    }

    double readI16() {
      final v = parseBinaryData(
        bytes,
        cursor,
        2,
        isSigned: true,
        isBigEndian: false,
      );
      cursor += 2;
      return v.toDouble();
    }

    double readU8() {
      final v = parseBinaryData(
        bytes,
        cursor,
        1,
        isSigned: false,
        isBigEndian: false,
      );
      cursor += 1;
      return v.toDouble();
    }

    final packVoltage = readU16() / 10.0;
    final packCurrent = readI16() / 10.0;
    final soc = readU8();
    final soh = readU8();
    final capacityRemaining = readU16() / 10.0;
    final maxCellVoltage = readU16() / 1000.0;
    final minCellVoltage = readU16() / 1000.0;
    final maxTemp = readI16() / 10.0;
    final faults = readU8().toInt();

    return HvBmsTelemetry(
      packVoltage: packVoltage,
      packCurrent: packCurrent,
      soc: soc,
      soh: soh,
      capacityRemaining: capacityRemaining,
      maxCellVoltage: maxCellVoltage,
      minCellVoltage: minCellVoltage,
      maxTemp: maxTemp,
      faultFlags: faults,
    );
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
