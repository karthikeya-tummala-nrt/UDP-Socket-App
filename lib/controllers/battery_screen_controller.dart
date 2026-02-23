import 'dart:async';
import 'dart:typed_data';
import '../utils/binary_parser.dart';
import '../core/listener.dart';
import '../models/battery_telemetry.dart';

typedef BatteryDisplay = ({
  double soc,
  double current,
  String socText,
  String currentText,
});

class BatteryScreenManager {
  StreamSubscription<Uint8List>? _rawSubscription;
  final _processedController = StreamController<BatteryDisplay>.broadcast();

  Stream<BatteryDisplay> get processedStream => _processedController.stream;

  BatteryScreenManager();

  void start() {
    if (_rawSubscription != null) return;

    _rawSubscription = UdpListener.instance.rawStream.listen(
      (Uint8List rawBytes) {
        _handleIncoming(rawBytes);
      },
      onError: (error, stack) {
        _processedController.addError(error, stack);
      },
      cancelOnError: false,
    );
  }

  void _handleIncoming(Uint8List data) {
    if (data.length < BatteryTelemetrySchema.packetSize) {
      return;
    }

    try {

      final soc = parseBinaryData(
        data,
        BatteryTelemetrySchema.offsetSOC,
        BatteryTelemetrySchema.sizeSOC,
        isSigned: BatteryTelemetrySchema.socIsSigned,
      );

      final current = parseBinaryData(
        data,
        BatteryTelemetrySchema.offsetCurrent,
        BatteryTelemetrySchema.sizeCurrent,
        isBigEndian: BatteryTelemetrySchema.currentIsBigEndian,
        isSigned: BatteryTelemetrySchema.currentIsSigned,
      );

      final telemetry = BatteryTelemetry(
        soc: soc,
        current: current,
      );

      _processedController.add((
      soc: telemetry.soc.toDouble(),
      current: telemetry.current.toDouble(),
      socText: "${telemetry.soc.toDouble().toStringAsFixed(1)} %",
      currentText: "${telemetry.current.toDouble().toStringAsFixed(2)} A",
      ));

    } catch (e) {
      _processedController.addError(e);
    }
  }

  void stop() {
    _rawSubscription?.cancel();
    _rawSubscription = null;
  }

  void dispose() {
    stop();
    _processedController.close();
  }
}
