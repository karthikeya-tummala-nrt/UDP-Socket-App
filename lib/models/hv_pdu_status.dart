class HvPduStatus {
  static const int packetSize = 7;

  final bool mainContactor;
  final double motorCurrent;
  final int dcDcPercent;
  final int auxPercent;
  final double dcBusVoltage;

  const HvPduStatus({
    required this.mainContactor,
    required this.motorCurrent,
    required this.dcDcPercent,
    required this.auxPercent,
    required this.dcBusVoltage,
  });
}