import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/telemetry_controller.dart';
import '../models/telemetry_message.dart';
import '../models/power_dto.dart';
import '../models/rf_link_dto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final controller = Provider.of<TelemetryController>(context, listen: false);

    controller.start('ws://localhost:30000');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TelemetryController>(
      builder: (context, controller, _) {
        final pageTypes = controller.pages.keys.toList();

        if (pageTypes.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Waiting for telemetry...")),
          );
        }

        return DefaultTabController(
          length: pageTypes.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("GCS"),
              bottom: TabBar(
                tabs: pageTypes
                    .map((type) => Tab(text: _titleFor(type)))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: pageTypes
                  .map((type) => _buildPage(type, controller))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  String _titleFor(PageType type) {
    switch (type) {
      case PageType.power:
        return 'POWER';
      case PageType.rfLink:
        return 'RF LINK';
    }
  }

  String _displayValue<T>({
    required T? value,
    required bool isStale,
    String Function(T v)? formatter,
  }) {
    if (isStale || value == null) return '--';
    return formatter != null ? formatter(value) : value.toString();
  }

  Widget _buildPage(PageType type, TelemetryController controller) {
    final isStale = controller.isPageStale(type);

    switch (type) {
      case PageType.power:
        final dto = controller.getData<PowerDto>(type);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HV BATTERY
              const Text("HV BATTERY", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Pack Voltage: ${_displayValue(value: dto?.hvBattery.packVoltage, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} V')}'),
              Text('Pack Current: ${_displayValue(value: dto?.hvBattery.packCurrent, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} A')}'),
              Text('SOC: ${_displayValue(value: dto?.hvBattery.soc, isStale: isStale, formatter: (v) => '$v%')}'),
              Text('SOH: ${_displayValue(value: dto?.hvBattery.soh, isStale: isStale, formatter: (v) => '$v%')}'),
              Text('Capacity Remaining: ${_displayValue(value: dto?.hvBattery.capacityRemaining, isStale: isStale, formatter: (v) => '$v%')}'),
              Text('Max Cell Voltage: ${_displayValue(value: dto?.hvBattery.maxCellVoltage, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} V')}'),
              Text('Min Cell Voltage: ${_displayValue(value: dto?.hvBattery.minCellVoltage, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} V')}'),
              Text('Max Cell Temp: ${_displayValue(value: dto?.hvBattery.maxCellTemp, isStale: isStale, formatter: (v) => '$v °C')}'),
              Text('Over Voltage: ${_displayValue(value: dto?.hvBattery.overVoltage, isStale: isStale)}'),
              Text('Under Voltage: ${_displayValue(value: dto?.hvBattery.underVoltage, isStale: isStale)}'),
              Text('Over Temp: ${_displayValue(value: dto?.hvBattery.overTemp, isStale: isStale)}'),
              Text('Cell Imbalance: ${_displayValue(value: dto?.hvBattery.cellImbalance, isStale: isStale)}'),
              Text('CAN Status: ${_displayValue(value: dto?.hvBattery.canStatus, isStale: isStale)}'),

              const SizedBox(height: 20),
              // HV PDU
              const Text("HV PDU", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Main Contactor: ${_displayValue(value: dto?.hvPdu.mainContactor, isStale: isStale)}'),
              Text('Motor Contactor: ${_displayValue(value: dto?.hvPdu.motorContactor, isStale: isStale)}'),
              Text('DC-DC Contactor: ${_displayValue(value: dto?.hvPdu.dcDcContactor, isStale: isStale)}'),
              Text('Aux Contactor: ${_displayValue(value: dto?.hvPdu.auxContactor, isStale: isStale)}'),
              Text('DC Bus Voltage: ${_displayValue(value: dto?.hvPdu.dcBusVoltage, isStale: isStale)}'),

              const SizedBox(height: 20),
              // LV PDU
              const Text("LV PDU", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Input Voltage: ${_displayValue(value: dto?.lvPdu.inputVoltage, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} V')}'),
              Text('Input Current: ${_displayValue(value: dto?.lvPdu.inputCurrent, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} A')}'),
              Text('Input Power: ${_displayValue(value: dto?.lvPdu.inputPower, isStale: isStale)}'),
              Text('Output Current: ${_displayValue(value: dto?.lvPdu.outputCurrent, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} A')}'),
              Text('Load Power: ${_displayValue(value: dto?.lvPdu.loadPower, isStale: isStale)}'),
              Text('Temperature: ${_displayValue(value: dto?.lvPdu.temperature, isStale: isStale)}'),
              Text('CAN Status: ${_displayValue(value: dto?.lvPdu.canStatus, isStale: isStale)}'),

              const SizedBox(height: 10),
              // CHANNELS
              const Text("CHANNELS", style: TextStyle(fontWeight: FontWeight.bold)),
              if (dto?.lvPdu.channels != null)
                ...dto!.lvPdu.channels.map(
                      (c) => Text(
                    'CH${c.id} → ${_displayValue(value: c.current, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} A')} '
                        '(${_displayValue(value: c.status, isStale: isStale)})',
                  ),
                ),

              const SizedBox(height: 20),
              // LV BATTERY
              const Text("LV BATTERY", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Voltage: ${_displayValue(value: dto?.lvBattery.voltage, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} V')}'),
              Text('Current: ${_displayValue(value: dto?.lvBattery.current, isStale: isStale, formatter: (v) => '${v.toStringAsFixed(2)} A')}'),
            ],
          ),
        );

      case PageType.rfLink:
        final dto = controller.getData<RfLinkDto>(type);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RX Section
              const Text("RX", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Frequency: ${_displayValue(value: dto?.rx.frequency, isStale: isStale, formatter: (v) => '$v MHz')}'),
              Text('RSSI: ${_displayValue(value: dto?.rx.rssi, isStale: isStale, formatter: (v) => '$v dBm')}'),
              Text('DSNR: ${_displayValue(value: dto?.rx.dsnr, isStale: isStale, formatter: (v) => '$v dB')}'),
              Text('Data Rate: ${_displayValue(value: dto?.rx.dataRate, isStale: isStale, formatter: (v) => '$v kbps')}'),
              Text('Lock Status: ${_displayValue(value: dto?.rx.lockStatus, isStale: isStale)}'),

              const SizedBox(height: 20),
              // LINK QUALITY Section
              const Text("LINK QUALITY", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Status: ${_displayValue(value: dto?.linkQuality.status, isStale: isStale)}'),
              Text('Link Margin: ${_displayValue(value: dto?.linkQuality.linkMargin, isStale: isStale, formatter: (v) => '$v dB')}'),
              Text('RTT: ${_displayValue(value: dto?.linkQuality.rtt, isStale: isStale, formatter: (v) => '$v ms')}'),
              Text('Aux Contactor: ${_displayValue(value: dto?.linkQuality.auxContactor, isStale: isStale)}'),
              Text('Throughput Up: ${_displayValue(value: dto?.linkQuality.throughputUp, isStale: isStale, formatter: (v) => '$v kbps')}'),
              Text('Throughput Down: ${_displayValue(value: dto?.linkQuality.throughputDown, isStale: isStale, formatter: (v) => '$v kbps')}'),
            ],
          ),
        );
    }
  }
}
