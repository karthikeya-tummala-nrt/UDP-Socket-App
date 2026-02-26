enum MessageType {
  batteryTelemetry,
}

MessageType decodeMessageType(int value) {
  switch (value) {
    case 0x01:
      return MessageType.batteryTelemetry;
    default:
      throw UnsupportedError('Unknown message type: $value');
  }
}

