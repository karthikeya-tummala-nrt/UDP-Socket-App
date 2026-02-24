import 'package:gcs_sockets/controllers/battery_screen_controller.dart';
import 'package:gcs_sockets/core/udp_data_source.dart';
import 'package:gcs_sockets/repository/battery_repository.dart';

void main() async {
  print("Started exec::::::::::::::::::::");
  // WidgetsFlutterBinding.ensureInitialized();
  final udpSource = UdpDataSource();
  final batteryRepository = BatteryRepository(udpSource);
  // final batteryController = BatteryScreenController(batteryRepository);

  await udpSource.init('0.0.0.0', 7400);

  udpSource.rawPackets.listen((packet) {
    print('RAW PACKET: $packet');
  });

  batteryRepository.start();

  batteryRepository.stream.listen(
    (telemetry) {
      print(
        'PARSED → SOC: ${telemetry.soc}, '
        'Current: ${telemetry.current}',
      );
    },
    onError: (e) {
      print('ERROR: $e');
    },
  );

  // runApp(MyApp(controller: batteryController));
}

// class MyApp extends StatelessWidget {
//   final BatteryScreenController controller;
//   const MyApp({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'GCS - Binary',
//       home: BatteryScreen(controller: controller),
//     );
//   }
// }
