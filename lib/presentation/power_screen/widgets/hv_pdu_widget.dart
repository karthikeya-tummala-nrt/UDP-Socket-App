import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/telemetry_card.dart';
import '../../../models/hv_pdu_status.dart';
import '../../../repository/hv_pdu_repository.dart';

class HvPduWidget extends StatelessWidget {
  final HvPduRepository repository;

  const HvPduWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HvPduStatus>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const TelemetryCard(
            title: "HV PDU",
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final t = snapshot.data!;

        return TelemetryCard(
          title: "HV PDU",
          child: Column(
            children: [
              _row("Bus Voltage", "${t.dcBusVoltage}", "V"),
              _row("Contactor Flags", "${t.contactorFlags}", ""),
            ],
          ),
        );
      },
    );
  }

  Widget _row(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(unit.isNotEmpty ? "$value $unit" : value),
        ],
      ),
    );
  }
}