import 'dart:io';
import 'dart:typed_data';

import 'package:comm_module/comm_module.dart';

Future<void> main() async {
  await testTcp();
  await testUdp();
}

Future<void> testTcp() async {
  print('--- TCP TEST ---');

  final server = await ServerSocket.bind('127.0.0.1', 40000);

  server.listen((client) {
    client.listen((data) {
      print('TCP server received: $data');
    });
  });

  final Transport transport =
  TcpTransport(host: '127.0.0.1', port: 40000);

  await transport.connect();

  final payload = Uint8List.fromList([0x00, 0x11, 0x22]);
  transport.send(payload);

  await Future.delayed(const Duration(seconds: 1));
  await server.close();
  await transport.close();
  await transport.dispose();
}

Future<void> testUdp() async {
  print('--- UDP TEST ---');

  final Transport transport =
  UdpTransport(address: InternetAddress.loopbackIPv4, port: 40001, remoteAddress: InternetAddress.loopbackIPv4, remotePort: 40001);

  await transport.connect();

  final socket = await RawDatagramSocket.bind('127.0.0.1', 40001);

  socket.listen((event) {
    if (event == RawSocketEvent.read) {
      final datagram = socket.receive();
      if (datagram != null) {
        print('UDP server received: ${datagram.data}');
      }
    }
  });

  final payload = Uint8List.fromList([0xAA, 0xBB, 0xCC]);
  transport.send(payload);

  await Future.delayed(const Duration(seconds: 1));
  socket.close();
}