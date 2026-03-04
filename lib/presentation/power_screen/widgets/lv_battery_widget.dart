import 'package:flutter/material.dart';
import '../../../models/lv_battery_status.dart';
import '../../../repository/lv_battery_repository.dart';
import '../widgets/telemetry_card.dart';
import 'dynamic_max_bar.dart';

class LvBatteryWidget extends StatelessWidget {
  final LvBatteryRepository repository;

  const LvBatteryWidget({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LvBatteryStatus>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const TelemetryCard(
            title: "LV BATTERY",
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final d = snapshot.data!;

        return TelemetryCard(
          title: "LV BATTERY",
          accentColor: Colors.blueAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _voltageSection(d),
              const SizedBox(height: 24),
              _currentSection(d),
            ],
          ),
        );
      },
    );
  }

  // ============================
  // VOLTAGE
  // ============================

  Widget _voltageSection(LvBatteryStatus d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("VOLTAGE"),
        const SizedBox(height: 12),

        DynamicMaxBar(
          value: d.voltage,
          initialMax: 14.5,
        ),

      ],
    );
  }

  // ============================
  // CURRENT
  // ============================

  Widget _currentSection(LvBatteryStatus d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("CURRENT"),
        const SizedBox(height: 12),

        DynamicMaxBar(
          value: d.current.abs(),
          initialMax: 10,
        ),

      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        letterSpacing: 1.4,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }
}