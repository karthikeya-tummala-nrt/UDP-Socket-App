import 'dart:developer' as dev;
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

class UdpDataSource {
  RawDatagramSocket? _socket;
  StreamController<Uint8List>? _incomingBuffer;
  StreamSubscription? _socketSub;

  UdpDataSource();

  Future<void> init(String host, int port) async {
    _socket = await RawDatagramSocket.bind(InternetAddress(host, type: InternetAddressType.any), port);
    _incomingBuffer = StreamController<Uint8List>.broadcast();

    _socketSub = _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram != null) {
          dev.log(datagram.data.toString(), name: 'udp_source');
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

  @override
  Stream<Uint8List> get rawPackets => _incomingBuffer?.stream ?? const Stream.empty();


  void dispose() {
    _socketSub?.cancel();
    _socket?.close();
    _incomingBuffer?.close();
    _socket = null;
    _incomingBuffer = null;
  }
}