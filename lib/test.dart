import 'dart:async';
import 'dart:typed_data';

import 'package:mavlink_nrt/mavlink.dart';

// import YOUR generated dialect
import 'package:gcs_sockets/dialects/nrt.dart';

void main() {
  runCustomDialectTest();
}

Future<void> runCustomDialectTest() async {

  final dialect = MavlinkDialectNrt(); // your dialect
  final parser = MavlinkParser(dialect);

  final completer = Completer<void>();

  parser.stream.listen((decodedFrame) {
    print('\n--- FRAME DECODED ---');

    print('MessageType: ${decodedFrame.message.runtimeType}');
    print('MsgID: ${decodedFrame.message.mavlinkMessageId}');

    if (decodedFrame.message is NrtCompanyInfo) {
      final msg = decodedFrame.message as NrtCompanyInfo;

      print('\nDecoded Fields:');
      print('foundedYear: ${msg.foundedYear}');
      print('operational: ${msg.operational}');
      print('headquarters: ${msg.headquarters}');

      // validation
      assert(msg.foundedYear == 2017);
      assert(msg.operational == 1);

      print('\nCustom dialect round-trip passed.');
      completer.complete();
    }
  });

  // ---- CREATE MESSAGE (your custom type) ----
  final message = NrtCompanyInfo(
    foundedYear: 2017,
    headquarters: List.filled(20, 65), // 'A' * 20
    operational: 1,
  );

  // ---- WRAP IN FRAME (library class) ----
  final frame = MavlinkFrame(
    MavlinkVersion.v2,
    0,
    1,
    1,
    message,
  );

  final Uint8List bytes = frame.serialize();

  print('Serialized bytes (${bytes.length}):');
  print(bytes);

  // ---- FEED BYTE-BY-BYTE (realistic stream parsing) ----
  for (final b in bytes) {
    parser.parse(Uint8List.fromList([b]));
  }

  await completer.future;
}