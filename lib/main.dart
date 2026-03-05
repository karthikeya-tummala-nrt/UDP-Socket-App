import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gcs_sockets/core/udp_data_source.dart';
import 'package:gcs_sockets/presentation/power_screen/power_screen.dart';
import 'package:gcs_sockets/repository/hv_bms_repository.dart';
import 'package:gcs_sockets/repository/hv_pdu_repository.dart';
import 'package:gcs_sockets/repository/lv_battery_repository.dart';
import 'package:gcs_sockets/repository/lv_pdu_repository.dart';

import 'core/mavlink/mav_link_parser.dart';
import 'core/messages/message_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final udpSource = UdpDataSource();
  await udpSource.init(InternetAddress.anyIPv4, 7400);

  final mavParser = MavLinkParser(udpSource.packetStream);
  mavParser.start();

  final messageRouter = MessageRouter(mavParser);
  messageRouter.start();

  final hvBmsRepository = HvBmsRepository(messageRouter);
  final hvPduRepository = HvPduRepository(messageRouter);
  final lvBatteryRepository = LvBatteryRepository(messageRouter);
  final lvPduRepository = LvPduRepository(messageRouter);

  hvBmsRepository.start();
  hvPduRepository.start();
  lvBatteryRepository.start();
  lvPduRepository.start();

  runApp(MyApp(
    hvBmsRepository: hvBmsRepository,
    hvPduRepository: hvPduRepository,
    lvBatteryRepository: lvBatteryRepository,
    lvPduRepository: lvPduRepository,
  ));
}

class MyApp extends StatelessWidget {
  final HvBmsRepository hvBmsRepository;
  final HvPduRepository hvPduRepository;
  final LvBatteryRepository lvBatteryRepository;
  final LvPduRepository lvPduRepository;

  const MyApp({
    super.key,
    required this.hvBmsRepository,
    required this.hvPduRepository,
    required this.lvBatteryRepository,
    required this.lvPduRepository,
  });


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      title: 'GCS - Binary',
      home: PowerScreen(
        hvBmsRepository: hvBmsRepository,
        hvPduRepository: hvPduRepository,
        lvBatteryRepository: lvBatteryRepository,
        lvPduRepository: lvPduRepository,
      ),
    );
  }
}
