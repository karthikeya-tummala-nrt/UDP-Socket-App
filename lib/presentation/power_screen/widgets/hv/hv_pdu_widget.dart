import 'package:flutter/material.dart';
import '../../../../models/hv_pdu_status.dart';
import '../../../../repository/hv_pdu_repository.dart';

class HvPduWidget extends StatelessWidget {
  final HvPduRepository repository;

  const HvPduWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HvPduStatus>(
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
              const _SectionHeader("HV PDU"),
              const Divider(height: 12),

              _denseMetric("Main Contactor", d.mainContactor ? "ON" : "OFF"),

              const SizedBox(height: 8),

              _denseMetric(
                "Motor Current",
                "${d.motorCurrent.toStringAsFixed(1)} A",
              ),

              const SizedBox(height: 8),

              _denseMetric("DC-DC Contactor", "${d.dcDcPercent} %"),

              const SizedBox(height: 8),

              _denseMetric("Aux Contactor", "${d.auxPercent} %"),

              const SizedBox(height: 8),

              _denseMetric(
                "DC Bus Voltage",
                "${d.dcBusVoltage.toStringAsFixed(1)} V",
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
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    );
  }
}
