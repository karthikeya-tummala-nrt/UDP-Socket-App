import 'package:flutter/material.dart';
import 'package:gcs_sockets/presentation/power_screen/widgets/telemetry_card.dart';
import '../../../models/hv_bms_telemetry.dart';
import '../../../repository/hv_bms_repository.dart';

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
            title: "HV Battery",
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final t = snapshot.data!;

        final tempColor = t.maxTemp > 70
            ? Colors.red
            : t.maxTemp > 60
            ? Colors.orange
            : Colors.green;

        final socColor = t.soc < 20
            ? Colors.red
            : t.soc < 50
            ? Colors.orange
            : Colors.green;

        return TelemetryCard(
          title: "HV Battery",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // SOC (Primary Indicator)
              Text(
                "SOC: ${t.soc} %",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: socColor,
                ),
              ),

              const SizedBox(height: 12),

              _section("Electrical", [
                _metric("Pack Voltage", t.packVoltage, "V"),
                _metric("Pack Current", t.packCurrent, "A"),
                _metric("Capacity Remaining", t.capacityRemaining, "Ah"),
              ]),

              const SizedBox(height: 8),

              _section("Health", [
                _metric("SOH", t.soh, "%"),
              ]),

              const SizedBox(height: 8),

              _section("Cell Monitoring", [
                _metric("Max Cell Voltage", t.maxCellVoltage, "V"),
                _metric("Min Cell Voltage", t.minCellVoltage, "V"),
              ]),

              const SizedBox(height: 8),

              _section("Thermal", [
                Text(
                  "Max Temp: ${t.maxTemp} °C",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: tempColor,
                  ),
                ),
              ]),

              const SizedBox(height: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fault Flags",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  _faultRow("Overvoltage", t.faultFlags, 0),
                  _faultRow("Undervoltage", t.faultFlags, 1),
                  _faultRow("Overtemperature", t.faultFlags, 2),
                  _faultRow("Cell Imbalance", t.faultFlags, 3),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        ...children,
      ],
    );
  }

  Widget _metric(String label, double? value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value != null
                ? "$value $unit"
                : "--",
          ),
        ],
      ),
    );
  }
}

Widget _faultRow(String label, int? flags, int bit) {
  final active = flags != null && (flags & (1 << bit)) != 0;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.red : Colors.green,
          ),
        ),
      ],
    ),
  );
}