import 'dart:async';
import 'package:gcs_sockets/repository/battery_repository.dart';
import 'package:gcs_sockets/models/battery_telemetry.dart';

typedef BatteryDisplay = ({
  double soc,
  double current,
});

class BatteryScreenController {
  final BatteryRepository _repository;

  BatteryScreenController(this._repository);

  Stream<BatteryDisplay> get stream =>
      _repository.stream.map(_toDisplay);

  BatteryDisplay _toDisplay(BatteryTelemetry telemetry) {
    return (
    soc: telemetry.soc.toDouble(),
    current: telemetry.current.toDouble()
    );
  }
}
