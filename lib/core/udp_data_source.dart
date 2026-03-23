import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

class UdpDataSource {
  RawDatagramSocket? _socket;
  StreamController<Uint8List>? _incomingBuffer;
  StreamSubscription? _socketSub;

  UdpDataSource();

  Future<void> init(InternetAddress host, int port) async {
    _socket = await RawDatagramSocket.bind(host, port);
    _incomingBuffer = StreamController<Uint8List>.broadcast();

    if (_socket != null) {
      print('🟢 Socket bound to IP: ${_socket!.address.address} on Port: ${_socket!.port}');
    }
    _socketSub = _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram != null) {
          if (_incomingBuffer!.hasListener) {
            _incomingBuffer!.add(datagram.data);
          }
        }
      }
    }, onError: (e) {
      _incomingBuffer?.addError(e);
    }, onDone: () {
      _incomingBuffer?.close();
    });
  }

  Stream<Uint8List> get onData => _incomingBuffer?.stream ?? const Stream.empty();

  void dispose() {
    _socketSub?.cancel();
    _socket?.close();
    _incomingBuffer?.close();
    _socket = null;
    _incomingBuffer = null;
  }
}