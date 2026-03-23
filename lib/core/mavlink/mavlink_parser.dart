import 'dart:async';
import 'dart:typed_data';

import 'package:gcs_sockets/core/mavlink/mav_frame.dart';

enum _ParserState {
  waitStx,
  waitPayloadLength,
  waitIncompatibilityFlags,
  waitCompatibilityFlags,
  waitPacketSequence,
  waitSystemId,
  waitComponentId,
  waitMessageId,
  waitPayload,
  waitCrc,
}

class MavlinkParser {
  static const int _mavlinkMaximumPayloadSize = 255;
  static const int _crcInitialValue = 0xFFFF;

  final Stream<Uint8List> _binaryStream;
  StreamSubscription? _streamSubscription;
  _ParserState _state = _ParserState.waitStx;
  final StreamController<MavFrame> _frameController = StreamController<MavFrame>.broadcast();

  Stream<MavFrame> get frames => _frameController.stream;

  int _payloadLength = 0;
  int _incompatibilityFlags = 0;
  int _compatibilityFlags = 0;
  int _sequence = 0;
  int _systemId = 0;
  int _componentId = 0;
  int _messageId = 0;

  final Uint8List _payload = Uint8List(_mavlinkMaximumPayloadSize);

  int _payloadCursor = 0;

  final Uint8List _crc = Uint8List(2);
  int _crcCursor = 0;

  final Map<int, int> _crcExtra = {60001: 50, 60002: 51, 60003: 52, 60004: 53};

    MavlinkParser(this._binaryStream);

  void start() {
    _streamSubscription = _binaryStream.listen(_onData);
  }

  void _onData(Uint8List data) {
    for (final byte in data) {
      switch (_state) {
        case _ParserState.waitStx:
          if (byte == 0xFD) {
            _resetContext();
            _state = _ParserState.waitPayloadLength;
          }
          break;

        case _ParserState.waitPayloadLength:
          _payloadLength = byte;
          _state = _ParserState.waitIncompatibilityFlags;
          break;

        case _ParserState.waitIncompatibilityFlags:
          _incompatibilityFlags = byte;
          _state = _ParserState.waitCompatibilityFlags;
          break;

        case _ParserState.waitCompatibilityFlags:
          _compatibilityFlags = byte;
          _state = _ParserState.waitPacketSequence;
          break;

        case _ParserState.waitPacketSequence:
          _sequence = byte;
          _state = _ParserState.waitSystemId;
          break;

        case _ParserState.waitSystemId:
          _systemId = byte;
          _state = _ParserState.waitComponentId;
          break;

        case _ParserState.waitComponentId:
          _componentId = byte;
          _messageId = 0;
          _payloadCursor = 0;
          _state = _ParserState.waitMessageId;
          break;

        case _ParserState.waitMessageId:
          _messageId |= (byte << (_payloadCursor * 8));
          _payloadCursor++;

          if (_payloadCursor == 3) {
            _payloadCursor = 0;

            if (_payloadLength == 0) {
              _crcCursor = 0;
              _state = _ParserState.waitCrc;
            } else {
              _state = _ParserState.waitPayload;
            }
          }
          break;

        case _ParserState.waitPayload:
          _payload[_payloadCursor++] = byte;

          if (_payloadCursor == _payloadLength) {
            _crcCursor = 0;
            _state = _ParserState.waitCrc;
          }
          break;

        case _ParserState.waitCrc:
          _crc[_crcCursor++] = byte;

          if (_crcCursor == 2) {
            if (_validateCrc()) {
              _emitFrame();
            }
            _state = _ParserState.waitStx;
          }
          break;
      }
    }
  }

  bool _validateCrc() {
    int receivedCrc = _crc[0] | (_crc[1] << 8); // little-endian

    int crc = _crcInitialValue;

    // Header (from payload length onward)
    crc = _crcAccumulate(_payloadLength, crc);
    crc = _crcAccumulate(_incompatibilityFlags, crc);
    crc = _crcAccumulate(_compatibilityFlags, crc);
    crc = _crcAccumulate(_sequence, crc);
    crc = _crcAccumulate(_systemId, crc);
    crc = _crcAccumulate(_componentId, crc);

    // Message ID (3 bytes)
    crc = _crcAccumulate(_messageId & 0xFF, crc);
    crc = _crcAccumulate((_messageId >> 8) & 0xFF, crc);
    crc = _crcAccumulate((_messageId >> 16) & 0xFF, crc);

    // Payload
    for (int i = 0; i < _payloadLength; i++) {
      crc = _crcAccumulate(_payload[i], crc);
    }

    // CRC Extra
    final extra = _crcExtra[_messageId] ?? 0;
    crc = _crcAccumulate(extra, crc);

    return crc == receivedCrc;
  }

  int _crcAccumulate(int byte, int crc) {
    int tmp = byte ^ (crc & 0xFF);
    tmp ^= (tmp << 4) & 0xFF;

    return (((crc >> 8) ^ (tmp << 8) ^ (tmp << 3) ^ (tmp >> 4))) & 0xFFFF;
  }

  void _emitFrame() {
    _frameController.add(
      MavFrame(_messageId, Uint8List.fromList(
        _payload.sublist(0, _payloadLength),
      )),
    );
  }

  void _resetContext() {
    _payloadLength = 0;
    _incompatibilityFlags = 0;
    _compatibilityFlags = 0;
    _sequence = 0;
    _systemId = 0;
    _componentId = 0;
    _messageId = 0;
    _payloadCursor = 0;
    _crcCursor = 0;
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}
