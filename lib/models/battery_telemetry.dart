
class BatteryTelemetry {
  final int soc;
  final int current;

  BatteryTelemetry({required this.soc, required this.current});

}

class BatteryTelemetrySchema {
  static const int offsetSOC = 0;
  static const int offsetCurrent = 1;
  static const int sizeSOC = 1;
  static const int sizeCurrent = 2;
  static const bool currentIsBigEndian = true;
  static const bool socIsSigned = false;
  static const bool currentIsSigned = true;
  static const int packetSize = 3;
}