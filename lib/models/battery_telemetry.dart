enum Endianness { big, little }

class FieldSchema {
  final int size;
  final bool isSigned;
  final Endianness endianness;

  const FieldSchema({
    required this.size,
    required this.isSigned,
    this.endianness = Endianness.big,
  });
}

class BatteryTelemetry {
  static const int messageId = 0x01;

  static const socField = FieldSchema(
    size: 1,
    isSigned: false,
  );

  static const currentField = FieldSchema(
    size: 2,
    isSigned: true,
    endianness: Endianness.big,
  );

  static const fields = [socField, currentField];

  static int get payloadSize =>
      fields.fold(0, (sum, f) => sum + f.size);

  static int get packetSize =>
      1 + payloadSize;

  final int soc;
  final int current;

  BatteryTelemetry({
    required this.soc,
    required this.current,
  });
}