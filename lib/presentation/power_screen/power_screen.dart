import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/hv_bms_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/hv_pdu_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/lv_battery_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/lv_pdu.dart';

import '../../repository/hv_bms_repository.dart';
import '../../repository/hv_pdu_repository.dart';
import '../../repository/lv_battery_repository.dart';
import '../../repository/lv_pdu_repository.dart';

class PowerScreen extends StatelessWidget {
  final HvBmsRepository hvBmsRepository;
  final HvPduRepository hvPduRepository;
  final LvBatteryRepository lvBatteryRepository;
  final LvPduRepository lvPduRepository;

  const PowerScreen({
    super.key,
    required this.hvBmsRepository,
    required this.hvPduRepository,
    required this.lvBatteryRepository,
    required this.lvPduRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Power")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: HvBmsWidget(repository: hvBmsRepository)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  HvPduWidget(repository: hvPduRepository),
                  const SizedBox(height: 16),
                  LvBatteryWidget(repository: lvBatteryRepository),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: LvPduWidget(repository: lvPduRepository)),
          ],
        ),
      ),
    );
  }}