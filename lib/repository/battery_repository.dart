import 'dart:async';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:gcs_sockets/core/udp_data_source.dart';
import 'package:gcs_sockets/models/battery_telemetry.dart';
import 'package:gcs_sockets/utils/binary_parser.dart';

class BatteryRepository {
  final UdpDataSource _dataSource;

  final StreamController<BatteryTelemetry> _controller = StreamController<BatteryTelemetry>.broadcast();

  StreamSubscription<Uint8List>? _rawSub;

  BatteryTelemetry? _latest;

  BatteryRepository(this._dataSource);

  BatteryTelemetry? get latest => _latest;

  Stream<BatteryTelemetry> get stream => _controller.stream;

  void start() {
    if (_rawSub != null) return;

    _rawSub = _dataSource.rawPackets.listen(_handlePacket);
  }

  void _handlePacket(Uint8List bytes) {
    if (bytes.length < BatteryTelemetrySchema.packetSize) return;

    try {
      final telemetry = _parse(bytes);

      _latest = telemetry;
      dev.log(
          'PARSED PACKET: SOC: ${telemetry.soc}, Current: ${telemetry.current}',
          name: 'battery_repository'
      );
      _controller.add(telemetry);
    } catch (e) {
      _controller.addError(e);
    }
  }

  BatteryTelemetry _parse(Uint8List bytes) {
    final soc = parseBinaryData(
      bytes,
      BatteryTelemetrySchema.offsetSOC,
      BatteryTelemetrySchema.sizeSOC,
    );

    final current = parseBinaryData(
      bytes,
      BatteryTelemetrySchema.offsetCurrent,
      BatteryTelemetrySchema.sizeCurrent,
    );

    return BatteryTelemetry(soc: soc, current: current);
  }

  void dispose() {
    _rawSub?.cancel();
    _controller.close();
  }
}