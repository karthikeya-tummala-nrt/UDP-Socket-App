import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gcs_sockets/ui/home_page.dart';
import 'package:gcs_sockets/controllers/telemetry_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TelemetryController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GCS - Sockets',
      home: HomePage(),
    );
  }

}