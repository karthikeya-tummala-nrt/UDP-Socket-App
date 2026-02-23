import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

class UdpListener {
  static final UdpListener instance = UdpListener._();
  UdpListener._();

  RawDatagramSocket? _socket;
  StreamController<Uint8List>? _rawController;
  StreamSubscription? _socketSub;

  bool get isBound => _socket != null;

  Future<void> ensureBound(String host, int port) async {
    if (isBound) return;

    _socket = await RawDatagramSocket.bind(InternetAddress(host, type: InternetAddressType.any), port);
    _rawController = StreamController<Uint8List>.broadcast();

    _socketSub = _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram != null) {
          if (_rawController!.hasListener) {
            _rawController!.add(datagram.data);
          }
        }
      }
    }, onError: (e) {
      _rawController?.addError(e);
    }, onDone: () {
      _rawController?.close();
    });
  }

  Stream<Uint8List> get rawStream {
    if (!isBound) throw StateError("Call ensureBound() first");
    return _rawController!.stream;
  }

  void dispose() {
    _socketSub?.cancel();
    _socket?.close();
    _rawController?.close();
    _socket = null;
    _rawController = null;
  }
}