import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/telemetry_card.dart';
import '../../../models/lv_battery_status.dart';
import '../../../repository/lv_battery_repository.dart';

class LvBatteryWidget extends StatelessWidget {
  final LvBatteryRepository repository;

  const LvBatteryWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LvBatteryStatus>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const TelemetryCard(
            title: "LV Battery",
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final t = snapshot.data!;

        return TelemetryCard(
          title: "LV Battery",
          child: Column(
            children: [
              _row("Voltage", "${t.voltage}", "V"),
              _row("Current", "${t.current}", "A"),
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