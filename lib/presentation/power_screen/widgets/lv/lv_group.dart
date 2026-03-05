import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/lv/lv_battery_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/lv/lv_pdu_widget.dart';

import '../../../../repository/lv_battery_repository.dart';
import '../../../../repository/lv_pdu_repository.dart';

class LvGroup extends StatelessWidget {
  final LvBatteryRepository lvBatteryRepository;
  final LvPduRepository lvPduRepository;

  const LvGroup({
    super.key,
    required this.lvBatteryRepository,
    required this.lvPduRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: LvBatteryWidget(repository: lvBatteryRepository),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 6,
          child: LvPduWidget(repository: lvPduRepository),
        ),
      ],
    );
  }
}