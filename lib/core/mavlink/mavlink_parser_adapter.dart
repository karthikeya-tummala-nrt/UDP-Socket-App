import 'dart:async';
import 'dart:typed_data';

class MavlinkParserAdapter {
  final Stream<Uint8List> _stream;
  StreamSubscription<Uint8List>? _streamSubscription;
  
  MavlinkParserAdapter(this._stream);
  
  void start() {
    _streamSubscription = _stream.listen(_onData);
  }

  void _onData(Uint8List data) {
    _onData?.call(data);
  }
}