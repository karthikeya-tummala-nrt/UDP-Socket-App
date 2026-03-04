import 'package:flutter/material.dart';
import '../../../models/lv_pdu_status.dart';
import '../../../repository/lv_pdu_repository.dart';
import '../widgets/telemetry_card.dart';

class LvPduWidget extends StatelessWidget {
  final LvPduRepository repository;

  const LvPduWidget({
    super.key,
    required this.repository,
  });

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

        final data = snapshot.data!;

        return TelemetryCard(
          title: "LV PDU",
          accentColor:
          data.canOk ? Colors.blueAccent : Colors.redAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inputSection(data),
              const SizedBox(height: 32),
              _channelSection(data),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // INPUT SECTION
  // =========================

  Widget _inputSection(LvPduStatus data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("INPUT"),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _tile("Voltage",
                "${data.inputVoltage.toStringAsFixed(2)} V"),
            _tile("Current",
                "${data.inputCurrent.toStringAsFixed(1)} A"),
            _tile("Power",
                "${data.inputPower.toStringAsFixed(1)} W"),
            _tile("Temperature",
                "${data.temperature.toStringAsFixed(1)} °C"),
            _statusTile("CAN", data.canOk),
          ],
        ),
      ],
    );
  }

  // =========================
  // CHANNEL SECTION
  // =========================

  Widget _channelSection(LvPduStatus data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("CHANNELS"),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(6, (index) {
            final enabled = data.channelEnabled(index);
            final current = index < data.channelCurrents.length
                ? data.channelCurrents[index]
                : 0.0;

            return _channelTile(index, enabled, current);
          }),
        ),
      ],
    );
  }

  // =========================
  // TILES
  // =========================

  Widget _tile(String label, String value) {
    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  color: Colors.white60)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _statusTile(String label, bool ok) {
    final color = ok ? Colors.greenAccent : Colors.redAccent;

    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.error,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }

  Widget _channelTile(int index, bool enabled, double current) {
    final color = enabled
        ? Colors.greenAccent
        : Colors.redAccent;

    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("CH ${index + 1}",
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text("${current.toStringAsFixed(1)} A",
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(enabled ? "ENABLED" : "DISABLED",
              style: TextStyle(
                  fontSize: 12,
                  color: color)),
        ],
      ),
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
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }
}