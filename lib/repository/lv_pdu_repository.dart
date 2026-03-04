import 'dart:async';
import 'dart:typed_data';
import 'package:gcs_sockets/core/messages/message_type.dart';

import '../core/messages/message_router.dart';
import '../models/lv_pdu_status.dart';
import '../utils/binary_parser.dart';

class LvPduRepository {
  final MessageRouter _router;

  final _controller = StreamController<LvPduStatus>.broadcast();
  Stream<LvPduStatus> get stream => _controller.stream;

  StreamSubscription<Uint8List>? _sub;

  LvPduRepository(this._router);

  void start() {
    if (_sub != null) return;
    _sub = _router.packetsFor(MessageType.lvPdu).listen(_handlePacket);
  }

  void _handlePacket(Uint8List bytes) {
    if (bytes.length < LvPduStatus.packetSize) return;

    try {
      final status = _parse(bytes);
      _controller.add(status);
    } catch (_) {}
  }

  LvPduStatus _parse(Uint8List bytes) {
    int cursor = 0;

    double readU16() {
      final v = parseBinaryData(bytes, cursor, 2,
          isSigned: false, isBigEndian: false);
      cursor += 2;
      return v.toDouble();
    }

    double readI16() {
      final v = parseBinaryData(bytes, cursor, 2,
          isSigned: true, isBigEndian: false);
      cursor += 2;
      return v.toDouble();
    }

    final inputVoltage = readU16() / 10.0;
    final inputCurrent = readU16() / 10.0;
    final inputPower = readU16();

    final channelMask =
    parseBinaryData(bytes, cursor, 1, isSigned: false, isBigEndian: false);
    cursor += 1;

    final channelCurrents = <double>[];
    for (int i = 0; i < 6; i++) {
      channelCurrents.add(readI16() / 10.0);
    }

    final temperature = readI16() / 10.0;

    final canStatus =
    parseBinaryData(bytes, cursor, 1, isSigned: false, isBigEndian: false);

    return LvPduStatus(
      inputVoltage: inputVoltage,
      inputCurrent: inputCurrent,
      inputPower: inputPower,
      channelMask: channelMask,
      channelCurrents: channelCurrents,
      temperature: temperature,
      canStatus: canStatus,
    );
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}