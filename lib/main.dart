import 'package:flutter/material.dart';
import 'package:gcs_sockets/controllers/battery_screen_controller.dart';
import 'package:gcs_sockets/core/udp_data_source.dart';
import 'package:gcs_sockets/repository/battery_repository.dart';
import 'package:gcs_sockets/screens/battery_screen.dart';

import 'core/messages/message_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final udpSource = UdpDataSource();
  await udpSource.init('0.0.0.0', 7400);

  final messageRouter = MessageRouter(udpSource);
  messageRouter.start();

  final batteryRepository = BatteryRepository(messageRouter);
  batteryRepository.start();

  final batteryController = BatteryScreenController(batteryRepository);

  udpSource.rawPackets.listen((packet) {
  });


  batteryRepository.stream.listen(
    (telemetry) {
    },
    onError: (e) {
    },
  );

  runApp(MyApp(controller: batteryController));
}

class MyApp extends StatelessWidget {
  final BatteryScreenController controller;
  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GCS - Binary',
      home: BatteryScreen(controller: controller),
    );
  }
}
