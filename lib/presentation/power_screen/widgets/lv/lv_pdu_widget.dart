import 'package:flutter/material.dart';
import '../../../../models/lv_pdu_status.dart';
import '../../../../repository/lv_pdu_repository.dart';

class LvPduWidget extends StatelessWidget {
  final LvPduRepository repository;

  const LvPduWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LvPduStatus>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final d = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader("LV PDU"),
                const Divider(height: 12),

                // INPUT
                _denseMetric(
                  "Input Voltage",
                  "${d.inputVoltage.toStringAsFixed(2)} V",
                ),
                const SizedBox(height: 8),

                _denseMetric(
                  "Input Current",
                  "${d.inputCurrent.toStringAsFixed(1)} A",
                ),
                const SizedBox(height: 8),

                _denseMetric(
                  "Input Power",
                  "${d.inputPower.toStringAsFixed(1)} W",
                ),
                const SizedBox(height: 8),

                // OUTPUT
                _denseMetric(
                  "Output Current",
                  "${d.outputCurrent.toStringAsFixed(1)} A",
                ),
                const SizedBox(height: 8),

                _denseMetric(
                  "Load Power",
                  "${d.loadPower.toStringAsFixed(1)} W",
                ),
                const SizedBox(height: 8),

                // SYSTEM
                _denseMetric(
                  "Temperature",
                  "${d.temperature.toStringAsFixed(1)} °C",
                ),
                const SizedBox(height: 8),

                _denseMetric("CAN Status", d.canOk ? "ON" : "OFF"),

                const SizedBox(height: 8),
                const _SectionHeader("Output Channels"),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(6, (index) {
                    final enabled = d.channelEnabled(index);
                    final current = index < d.channelCurrents.length
                        ? d.channelCurrents[index]
                        : 0.0;

                    return _channel("CH ${index + 1}", enabled, current);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _denseMetric(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _channel(String label, bool enabled, double current) {
    final color = enabled ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: Text(
        "$label  ${current.toStringAsFixed(1)}A",
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
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
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    );
  }
}
