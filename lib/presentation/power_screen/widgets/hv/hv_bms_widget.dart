import 'package:flutter/material.dart';
import '../../../../models/hv_bms_telemetry.dart';
import '../../../../repository/hv_bms_repository.dart';

class HvBmsWidget extends StatelessWidget {
  final HvBmsRepository repository;

  const HvBmsWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HvBmsTelemetry>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final t = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader("HV Battery (BMS)"),
                const Divider(height: 12),

                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    _dualRow(
                      "SOH",
                      "${t.soh.toStringAsFixed(0)} %",
                      _sohColor(t.soh),
                      "Capacity rem",
                      "${t.capacityRemaining.toStringAsFixed(0)} Ah",
                    ),
                    _dualRow(
                      "Pack Voltage",
                      "${t.packVoltage.toStringAsFixed(1)} V",
                      null,
                      "Pack Current",
                      "${t.packCurrent.toStringAsFixed(1)} A",
                    ),
                    _dualRow(
                      "Max Cell Voltage",
                      "${t.maxCellVoltage.toStringAsFixed(3)} V",
                      null,
                      "Min Cell Voltage",
                      "${t.minCellVoltage.toStringAsFixed(3)} V",
                    ),
                    _dualRow(
                      "Max Cell Temperature",
                      "${t.maxTemp.toStringAsFixed(1)} °C",
                      t.maxTemp > 50 ? Colors.red : null,
                      "",
                      "",
                    ),
                  ],
                ),

                const Divider(height: 12),

                const _SectionHeader("FAULTS"),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _faultBox("Over Voltage", (t.faultFlags & (1 << 0)) == 0),
                    _faultBox("Under Voltage", (t.faultFlags & (1 << 1)) == 0),
                    _faultBox(
                      "Over Temperature",
                      (t.faultFlags & (1 << 2)) == 0,
                    ),
                    _faultBox("Cell Imbalance", (t.faultFlags & (1 << 3)) == 0),
                  ],
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

  Widget _faultBox(String label, bool ok) {
    final color = ok ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _socColor(double soc) => soc > 60
      ? Colors.green
      : soc > 30
      ? Colors.orange
      : Colors.red;

  Color _sohColor(double soh) => soh > 80
      ? Colors.green
      : soh > 60
      ? Colors.orange
      : Colors.red;
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
