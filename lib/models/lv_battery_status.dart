class LvBatteryStatus {
  static const int packetSize = 8;

  final double voltage;
  final double current;

  const LvBatteryStatus({
    required this.voltage,
    required this.current,
  });
}