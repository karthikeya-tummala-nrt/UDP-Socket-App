import 'package:flutter/material.dart';
import 'package:gcs_sockets/core/listener.dart';
import 'screens/battery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UdpListener.instance.ensureBound("0.0.0.0", 7400);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GCS - Binary',
      home: PduScreen(),
    );
  }
}