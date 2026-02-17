import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/app_socket.dart';
import 'features/telemetry/data/repositories/telemetry_repository_impl.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';

void main() {
  final socket = AppSocket();

  final repository = TelemetryRepositoryImpl(socket: socket);

  runApp(
    BlocProvider(
      create: (context) => TelemetryBloc(repository)..add(ConnectTelemetry()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GcsDashboard(),
      ),
    ),
  );
}

class GcsDashboard extends StatelessWidget {
  const GcsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("GCS Telemetry"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bolt), text: "POWER"),
              Tab(icon: Icon(Icons.settings_input_antenna), text: "RF LINK"),
            ],
          ),
        ),
        body: BlocBuilder<TelemetryBloc, TelemetryState>(
          builder: (context, state) {
            // This builder redraws the screen every time the BLoC emits a new state
            return TabBarView(
              children: [
                _buildPowerPage(state),
                _buildRfPage(state),
              ],
            );
          },
        ),
      ),
    );
  }

  // Functional Power Page
  Widget _buildPowerPage(TelemetryState state) {
    final p = state.power;
    if (p == null) return const Center(child: Text("Waiting for Power Data..."));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _dataTile("HV Pack Voltage", "${p.hvBattery.packVoltage} V"),
        _dataTile("HV SOC", "${p.hvBattery.soc} %"),
        _dataTile("LV Input", "${p.lvPdu.inputVoltage} V"),
        _dataTile("Main Contactor", p.hvPdu.mainContactor ? "ON" : "OFF"),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text("LV Channels", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...p.lvPdu.channels.map((c) => _dataTile("CH ${c.id}", "${c.current} A [${c.status}]")),
      ],
    );
  }

  // Functional RF Page
  Widget _buildRfPage(TelemetryState state) {
    final r = state.rf;
    if (r == null) return const Center(child: Text("Waiting for RF Link..."));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _dataTile("TX Frequency", "${r.tx.frequency} MHz"),
        _dataTile("RX RSSI", "${r.rx.rssi} dBm"),
        _dataTile("DSNR", "${r.rx.dsnr} dB"),
        _dataTile("Link Status", r.linkQuality.status),
        _dataTile("Link Margin", "${r.linkQuality.linkMargin} dB"),
        _dataTile("Latency (RTT)", "${r.linkQuality.rtt} ms"),
      ],
    );
  }

  Widget _dataTile(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)
      ),
    );
  }
}