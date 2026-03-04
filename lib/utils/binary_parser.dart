import 'dart:typed_data';

int parseBinaryData(
    Uint8List data,
    int offset,
    int size, {
      bool isBigEndian = false,
      bool isSigned = false,
    }) {
  int value = 0;

  if (isBigEndian) {
    for (int i = 0; i < size; i++) {
      value = (value << 8) | data[offset + i];
    }
  } else {
    for (int i = size - 1; i >= 0; i--) {
      value = (value << 8) | data[offset + i];
    }
  }

  if (isSigned) {
    final signBit = 1 << (size * 8 - 1);
    if ((value & signBit) != 0) {
      value = value - (1 << (size * 8));
    }
  }

  return value;
}