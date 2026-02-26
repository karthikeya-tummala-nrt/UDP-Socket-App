import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  final bool active;

  const StatusDot({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.green : Colors.grey,
      ),
    );
  }
}