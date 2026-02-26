enum MessageType {
  hvBms,
  hvPdu,
  lvBattery,
  lvPdu,
}

final Map<int, MessageType> _messageMap = {
  0x01: MessageType.hvBms,
  0x02: MessageType.hvPdu,
  0x03: MessageType.lvBattery,
  0x04: MessageType.lvPdu,
};

MessageType? decodeMessageType(int value) {
  return _messageMap[value];
}