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

                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    _dualRow(
                      "Input Voltage",
                      "${d.inputVoltage.toStringAsFixed(2)} V",
                      null,
                      "Input Current",
                      "${d.inputCurrent.toStringAsFixed(1)} A",
                    ),
                    _dualRow(
                      "Input Power",
                      "${d.inputPower.toStringAsFixed(1)} W",
                      null,
                      "Output Current",
                      "${d.outputCurrent.toStringAsFixed(1)} A",
                    ),
                    _dualRow(
                      "Load Power",
                      "${d.loadPower.toStringAsFixed(1)} W",
                      null,
                      "Temperature",
                      "${d.temperature.toStringAsFixed(1)} °C",
                    ),
                    _dualRow(
                      "CAN Status",
                      d.canOk ? "ON" : "OFF",
                      d.canOk ? Colors.green : Colors.red,
                      "",
                      "",
                    ),
                  ],
                ),

                const Divider(height: 12),
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

  TableRow _dualRow(
      String l1,
      String v1,
      Color? c1,
      String l2,
      String v2, [
        Color? c2,
      ]) {
    return TableRow(children: [_metric(l1, v1, c1), _metric(l2, v2, c2)]);
  }

  Widget _metric(String label, String value, Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
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