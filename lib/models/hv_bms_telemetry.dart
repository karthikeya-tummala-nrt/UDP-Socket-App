class HvBmsTelemetry {
  static const int packetSize = 21;

  final double packVoltage;
  final double packCurrent;
  final double soc;
  final double soh;
  final double capacityRemaining;
  final double maxCellVoltage;
  final double minCellVoltage;
  final double maxTemp;
  final int faultFlags;

  const HvBmsTelemetry({
    required this.packVoltage,
    required this.packCurrent,
    required this.soc,
    required this.soh,
    required this.capacityRemaining,
    required this.maxCellVoltage,
    required this.minCellVoltage,
    required this.maxTemp,
    required this.faultFlags,
  });
}