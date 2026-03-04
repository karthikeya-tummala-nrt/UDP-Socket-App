import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/hv_bms_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/hv_pdu_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/lv_battery_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/lv_pdu.dart';

import '../../repository/hv_bms_repository.dart';
import '../../repository/hv_pdu_repository.dart';
import '../../repository/lv_battery_repository.dart';
import '../../repository/lv_pdu_repository.dart';
import 'widgets/status_app_bar.dart';

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
      appBar: StatusAppBar(
        repository: hvBmsRepository,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 1200;

          if (!isWide) {
            // SMALL SCREEN → SINGLE COLUMN
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  HvBmsWidget(repository: hvBmsRepository),
                  const SizedBox(height: 20),
                  LvBatteryWidget(repository: lvBatteryRepository),
                  const SizedBox(height: 20),
                  HvPduWidget(repository: hvPduRepository),
                  const SizedBox(height: 20),
                  LvPduWidget(repository: lvPduRepository),
                ],
              ),
            );
          }

          // WIDE SCREEN → 3 COLUMNS
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1 — HV BMS
                Expanded(
                  child: HvBmsWidget(
                    repository: hvBmsRepository,
                  ),
                ),

                const SizedBox(width: 20),

                // Column 2 — LV Battery + HV PDU stacked
                Expanded(
                  child: Column(
                    children: [
                      LvBatteryWidget(
                          repository: lvBatteryRepository),
                      const SizedBox(height: 20),
                      HvPduWidget(repository: hvPduRepository),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Column 3 — LV PDU
                Expanded(
                  child: LvPduWidget(repository: lvPduRepository),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}