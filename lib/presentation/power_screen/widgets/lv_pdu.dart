import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/telemetry_card.dart';
import '../../../models/lv_pdu_status.dart';
import '../../../repository/lv_pdu_repository.dart';

class LvPduWidget extends StatelessWidget {
  final LvPduRepository repository;

  const LvPduWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LvPduStatus>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const TelemetryCard(
            title: "LV PDU",
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final t = snapshot.data!;

        return TelemetryCard(
          title: "LV PDU",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row("Input Voltage", "${t.inputVoltage}", "V"),
              _row("Input Current", "${t.inputCurrent}", "A"),
              _row("Input Power", "${t.inputPower}", "W"),
              _row("Temperature", "${t.temperature}", "°C"),
              _row("CAN Status", "${t.canStatus}", ""),
              const SizedBox(height: 8),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(6, (i) {
                  final active =
                      (t.channelMask & (1 << i)) != 0;

                  final current =
                  t.channelCurrents != null &&
                      i < t.channelCurrents!.length
                      ? t.channelCurrents![i]
                      : 0;

                  return Container(
                    width: 70,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.blueAccent
                          : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        Text("CH${i + 1}"),
                        Text(current.toStringAsFixed(1)),
                      ],
                    ),
                  );
                }),
              ),
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