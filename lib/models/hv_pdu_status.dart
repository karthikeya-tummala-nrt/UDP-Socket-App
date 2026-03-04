import 'dart:typed_data';

class HvPduStatus {
  static const int packetSize = 3;

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

  factory HvPduStatus.fromBytes(Uint8List bytes) {
    final contactors = bytes[1];

    final voltageRaw = (bytes[2] << 8) | bytes[3];
    final voltage = voltageRaw / 10.0;

    return HvPduStatus(
      contactorFlags: contactors,
      dcBusVoltage: voltage,
    );
  }
}