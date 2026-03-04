import 'package:flutter/material.dart';
import '../../../repository/hv_bms_repository.dart';
import '../../../models/hv_bms_telemetry.dart';
import '../widgets/telemetry_card.dart';
import 'dynamic_max_bar.dart';

class HvBmsWidget extends StatelessWidget {
  final HvBmsRepository repository;

  const HvBmsWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HvBmsTelemetry>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const TelemetryCard(
            title: "HV BMS",
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final t = snapshot.data!;

        final sohColor = t.soh > 80
            ? Colors.greenAccent
            : t.soh > 60
            ? Colors.orangeAccent
            : Colors.redAccent;

        return TelemetryCard(
          title: "HV BMS",
          accentColor: Colors.blueAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _socGauge(t.soc),
              const SizedBox(height: 20),

              /// ALL METRICS IN ONE RESPONSIVE WRAP
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _metricTile(
                    "Pack Voltage",
                    "${t.packVoltage.toStringAsFixed(1)} V",
                  ),
                  _metricTile(
                    "Pack Current",
                    "${t.packCurrent.toStringAsFixed(1)} A",
                  ),
                  _sohTile("SOH", "${t.soh.toStringAsFixed(0)} %", sohColor),
                  _metricTile(
                    "Capacity",
                    "${t.capacityRemaining.toStringAsFixed(1)} Ah",
                  ),
                  _metricTile(
                    "Max Cell",
                    "${t.maxCellVoltage.toStringAsFixed(3)} V",
                  ),
                  _metricTile(
                    "Min Cell",
                    "${t.minCellVoltage.toStringAsFixed(3)} V",
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Max Temperature",
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 8),

              DynamicMaxBar(value: t.maxTemp, initialMax: 50, unit: " °C"),

              const SizedBox(height: 24),

              const Text(
                "Faults",
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 12),

              _protectionStatus(t.faultFlags),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // FAULT SECTION
  // =========================

  Widget _protectionStatus(int faults) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _statusTile("Over Voltage", (faults & (1 << 0)) == 0),
        _statusTile("Under Voltage", (faults & (1 << 1)) == 0),
        _statusTile("Over Temperature", (faults & (1 << 2)) == 0),
        _statusTile("Cell Imbalance", (faults & (1 << 3)) == 0),
      ],
    );
  }

  Widget _statusTile(String label, bool isOk) {
    final color = isOk ? Colors.greenAccent : Colors.redAccent;

    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label)),
          Text(
            isOk ? "OK" : "FAULT",
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  // =========================
  // SOC
  // =========================

  Widget _socGauge(double soc) {
    final color = soc > 60
        ? Colors.greenAccent
        : soc > 30
        ? Colors.orangeAccent
        : Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("State of Charge"),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            FractionallySizedBox(
              widthFactor: soc.clamp(0, 100) / 100,
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  "${soc.toStringAsFixed(0)} %",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // SOH TILE (FULL GLOW)
  // =========================

  Widget _sohTile(String label, String value, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // HELPERS
  // =========================

  Widget _metricRow(List<Widget> children) {
    return Wrap(spacing: 12, runSpacing: 12, children: children);
  }

  Widget _metricTile(String label, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
