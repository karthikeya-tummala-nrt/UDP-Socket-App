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