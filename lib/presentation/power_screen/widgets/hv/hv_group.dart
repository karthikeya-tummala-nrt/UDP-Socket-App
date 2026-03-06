import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/hv/hv_bms_widget.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/hv/hv_pdu_widget.dart';

import '../../../../repository/hv_bms_repository.dart';
import '../../../../repository/hv_pdu_repository.dart';

class HvGroup extends StatelessWidget {
  final HvBmsRepository hvBmsRepository;
  final HvPduRepository hvPduRepository;

  const HvGroup({
    super.key,
    required this.hvBmsRepository,
    required this.hvPduRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: HvBmsWidget(repository: hvBmsRepository),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: HvPduWidget(repository: hvPduRepository),
        ),
      ],
    );
  }
}