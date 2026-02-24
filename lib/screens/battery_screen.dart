import 'package:flutter/material.dart';
import '../controllers/battery_screen_controller.dart';

class BatteryScreen extends StatelessWidget {
  final BatteryScreenController controller;

  const BatteryScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Data')),
      body: StreamBuilder<BatteryDisplay>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SOC: ${data.soc.toStringAsFixed(1)} %',
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                Text('Current: ${data.current.toStringAsFixed(2)} A',
                    style: const TextStyle(fontSize: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}