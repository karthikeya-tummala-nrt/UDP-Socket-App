import 'dart:typed_data';

class MavFrame {
  final int messageId;
  final Uint8List payload;

  MavFrame(this.messageId, this.payload);
}