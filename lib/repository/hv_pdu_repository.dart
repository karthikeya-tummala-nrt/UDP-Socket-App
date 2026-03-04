import 'dart:async';
import 'dart:typed_data';
import 'package:gcs_sockets/core/messages/message_type.dart';

import '../core/messages/message_router.dart';
import '../models/hv_pdu_status.dart';
import '../utils/binary_parser.dart';

class HvPduRepository {
  final MessageRouter _router;

  final _controller = StreamController<HvPduStatus>.broadcast();
  Stream<HvPduStatus> get stream => _controller.stream;

  StreamSubscription<Uint8List>? _sub;

  HvPduRepository(this._router);

  void start() {
    if (_sub != null) return;
    _sub = _router.packetsFor(MessageType.hvPdu).listen(_handlePacket);
  }

  void _handlePacket(Uint8List bytes) {
    if (bytes.length < HvPduStatus.packetSize) return;

    try {
      final status = _parse(bytes);
      _controller.add(status);
    } catch (_) {}
  }

  HvPduStatus _parse(Uint8List bytes) {
    int cursor = 0;

    final contactors =
    parseBinaryData(bytes, cursor, 1, isSigned: false, isBigEndian: false);
    cursor += 1;

    final dcBusRaw =
    parseBinaryData(bytes, cursor, 2, isSigned: false, isBigEndian: false);

    final dcBusVoltage = dcBusRaw / 10.0;

    return HvPduStatus(
      contactorFlags: contactors,
      dcBusVoltage: dcBusVoltage,
    );
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}