import 'package:flutter/material.dart';
import '../../../../models/lv_battery_status.dart';
import '../../../../repository/lv_battery_repository.dart';

class LvBatteryWidget extends StatelessWidget {
  final LvBatteryRepository repository;

  const LvBatteryWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LvBatteryStatus>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final d = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader("LV Battery"),
              const Divider(height: 12),

              _denseMetric(
                "Voltage",
                "${d.voltage.toStringAsFixed(2)} V",
              ),

              const SizedBox(height: 8),

              _denseMetric(
                "Current",
                "${d.current.toStringAsFixed(2)} A",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _denseMetric(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}