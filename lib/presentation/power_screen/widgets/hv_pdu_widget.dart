import 'package:flutter/material.dart';
import '../../../models/hv_pdu_status.dart';
import '../../../repository/hv_pdu_repository.dart';
import '../widgets/telemetry_card.dart';
import 'dynamic_max_bar.dart';

class HvPduWidget extends StatelessWidget {
  final HvPduRepository repository;

  const HvPduWidget({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HvPduStatus>(
      stream: repository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const TelemetryCard(
            title: "HV PDU",
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;

        return TelemetryCard(
          title: "HV PDU",
          accentColor: _anyCriticalOpen(data)
              ? Colors.orangeAccent
              : Colors.blueAccent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              if (width > 900) {
                return _wideLayout(data);
              } else if (width > 600) {
                return _mediumLayout(data);
              } else {
                return _compactLayout(data);
              }
            },
          ),
        );
      },
    );
  }

  // ============================
  // LAYOUTS
  // ============================

  Widget _wideLayout(HvPduStatus data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dcBusSection(data),
        const SizedBox(height: 24),
        _contactorSection(data),
      ],
    );
  }

  Widget _mediumLayout(HvPduStatus data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dcBusSection(data),
        const SizedBox(height: 24),
        _contactorSection(data),
      ],
    );
  }

  Widget _compactLayout(HvPduStatus data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dcBusSection(data),
        const SizedBox(height: 20),
        _contactorSection(data),
      ],
    );
  }

  // ============================
  // DC BUS (UPDATED)
  // ============================

  Widget _dcBusSection(HvPduStatus data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("DC BUS"),
        const SizedBox(height: 16),
        DynamicMaxBar(
          value: data.dcBusVoltage,
          initialMax: 400,
          unit: " V",
        ),
      ],
    );
  }

  // ============================
  // CONTACTORS
  // ============================

  Widget _contactorSection(HvPduStatus data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("CONTACTORS"),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _contactorTile("Main", data.mainContactor),
            _contactorTile("Motor", data.motorContactor),
            _contactorTile("DC-DC", data.dcDcContactor),
            _contactorTile("Aux", data.auxContactor),
          ],
        ),
      ],
    );
  }

  Widget _contactorTile(String label, bool active) {
    final color = active ? Colors.greenAccent : Colors.redAccent;

    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            active ? Icons.power : Icons.power_off,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _anyCriticalOpen(HvPduStatus data) {
    return !data.mainContactor || !data.motorContactor;
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