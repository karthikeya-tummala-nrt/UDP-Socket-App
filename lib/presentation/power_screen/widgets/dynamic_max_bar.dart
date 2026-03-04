import 'package:flutter/material.dart';

class DynamicMaxBar extends StatefulWidget {
  final double value;
  final double initialMax;
  final String unit;

  const DynamicMaxBar({
    super.key,
    required this.value,
    required this.initialMax,
    this.unit = "",
  });

  @override
  State<DynamicMaxBar> createState() => _DynamicMaxBarState();
}

class _DynamicMaxBarState extends State<DynamicMaxBar> {
  late double _maxSeen;

  @override
  void initState() {
    super.initState();
    _maxSeen = widget.initialMax;
  }

  @override
  void didUpdateWidget(covariant DynamicMaxBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value > _maxSeen) {
      _maxSeen = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = _maxSeen == 0
        ? 0.0
        : (widget.value / _maxSeen).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current: ${widget.value.toStringAsFixed(2)}${widget.unit}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            Text(
              "Max: ${_maxSeen.toStringAsFixed(2)}${widget.unit}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 12,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  height: 12,
                  width: constraints.maxWidth * percent,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}