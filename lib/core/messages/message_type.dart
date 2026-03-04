enum MessageType {
  hvBms,
  hvPdu,
  lvBattery,
  lvPdu,
}

final Map<int, MessageType> _messageMap = {
  60001: MessageType.hvBms,
  60002: MessageType.hvPdu,
  60003: MessageType.lvBattery,
  60004: MessageType.lvPdu,
};

MessageType? decodeMessageType(int value) {
  return _messageMap[value];
}