import 'package:flutter/material.dart';
import '../controllers/battery_screen_controller.dart';

class PduScreen extends StatefulWidget {
  const PduScreen({super.key});

  @override
  State<PduScreen> createState() => _PduScreenState();
}

class _PduScreenState extends State<PduScreen> {
  late final BatteryScreenManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = BatteryScreenManager();
    _manager.start();
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Data')),
      body: StreamBuilder<BatteryDisplay>(
        stream: _manager.processedStream,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SOC: ${data.socText}', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                Text('Current: ${data.currentText}', style: const TextStyle(fontSize: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}