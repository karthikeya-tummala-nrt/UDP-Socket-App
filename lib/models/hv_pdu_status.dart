class HvPduStatus {
  static const int packetSize = 8;

  final int contactorFlags;
  final double dcBusVoltage;

  const HvPduStatus({
    required this.contactorFlags,
    required this.dcBusVoltage,
  });

  bool get mainContactor => (contactorFlags & (1 << 0)) != 0;
  bool get motorContactor => (contactorFlags & (1 << 1)) != 0;
  bool get dcDcContactor => (contactorFlags & (1 << 2)) != 0;
  bool get auxContactor => (contactorFlags & (1 << 3)) != 0;
}