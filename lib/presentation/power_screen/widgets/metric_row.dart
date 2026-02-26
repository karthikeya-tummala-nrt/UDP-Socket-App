import 'package:flutter/material.dart';

class MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;

  const MetricRow({
    super.key,
    required this.label,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            unit != null ? "$value $unit" : value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}