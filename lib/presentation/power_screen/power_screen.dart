import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/hv/hv_group.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/lv/lv_group.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/status_app_bar.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: StatusAppBar(repository: hvBmsRepository),
        body: Row(
          children: [
            const _LeftNavRail(),
            Expanded(
              child: Column(
                children: [
                  const _PowerTabBar(),
                  Expanded(
                    child: TabBarView(
                      children: [
                        HvGroup(
                          hvBmsRepository: hvBmsRepository,
                          hvPduRepository: hvPduRepository,
                        ),
                        LvGroup(
                          lvBatteryRepository: lvBatteryRepository,
                          lvPduRepository: lvPduRepository,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftNavRail extends StatelessWidget {
  const _LeftNavRail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Colors.black,
      alignment: Alignment.topCenter,
      child: const Padding(
        padding: EdgeInsets.only(top: 20),
        child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            "POWER",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _PowerTabBar extends StatelessWidget {
  const _PowerTabBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E293B),
      child: const TabBar(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        tabs: [
          Tab(text: "HV"),
          Tab(text: "LV"),
        ],
      ),
    );
  }
}