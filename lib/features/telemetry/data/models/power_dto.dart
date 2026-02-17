import 'package:flutter/foundation.dart';
import 'package:gcs_sockets/features/telemetry/domain/entities/telemetry_data.dart';

@immutable
class PowerDto extends TelemetryData {
  final HvBatteryDto hvBattery;
  final HvPduDto hvPdu;
  final LvPduDto lvPdu;
  final LvBatteryDto lvBattery;

  const PowerDto({
    required String pageCode,
    required this.hvBattery,
    required this.hvPdu,
    required this.lvPdu,
    required this.lvBattery,
  }) : super(pageCode);

  factory PowerDto.fromJson(Map<String, dynamic> json) {
    // Safety check: ensure 'data' exists before parsing sub-objects
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return PowerDto(
      pageCode: json['page_code'] as String? ?? 'UNKNOWN',
      hvBattery: HvBatteryDto.fromJson(data['hv_battery'] ?? {}),
      hvPdu: HvPduDto.fromJson(data['hv_pdu'] ?? {}),
      lvPdu: LvPduDto.fromJson(data['lv_pdu'] ?? {}),
      lvBattery: LvBatteryDto.fromJson(data['lv_battery'] ?? {}),
    );
  }
}

// --- SUB-CLASSES ---

@immutable
class HvBatteryDto {
  final double packVoltage; // 48 V
  final double packCurrent; // -10 A
  final int soc; // 81 %
  final int soh; // 96 %
  final int capacityRemaining; // 100 Ah
  final double maxCellVoltage; // 4.0 V
  final double minCellVoltage; // 3.9 V
  final int maxCellTemp; // 34 C

  // Boolean Flags (Green/Red indicators)
  final bool isOverVoltage;
  final bool isUnderVoltage;
  final bool isOverTemp;
  final bool isCellImbalance; // The Red one in your image
  final bool isCanActive; // "CAN" indicator

  const HvBatteryDto({
    required this.packVoltage,
    required this.packCurrent,
    required this.soc,
    required this.soh,
    required this.capacityRemaining,
    required this.maxCellVoltage,
    required this.minCellVoltage,
    required this.maxCellTemp,
    required this.isOverVoltage,
    required this.isUnderVoltage,
    required this.isOverTemp,
    required this.isCellImbalance,
    required this.isCanActive,
  });

  factory HvBatteryDto.fromJson(Map<String, dynamic> json) {
    return HvBatteryDto(
      packVoltage: (json['pack_voltage'] as num?)?.toDouble() ?? 0.0,
      packCurrent: (json['pack_current'] as num?)?.toDouble() ?? 0.0,
      soc: json['soc'] as int? ?? 0,
      soh: json['soh'] as int? ?? 0,
      capacityRemaining: json['capacity_remaining'] as int? ?? 0,
      maxCellVoltage: (json['max_cell_voltage'] as num?)?.toDouble() ?? 0.0,
      minCellVoltage: (json['min_cell_voltage'] as num?)?.toDouble() ?? 0.0,
      maxCellTemp: json['max_cell_temp'] as int? ?? 0,

      // Assume these come as booleans. If your JSON sends 1/0, change to: json['val'] == 1
      isOverVoltage: json['over_voltage'] as bool? ?? false,
      isUnderVoltage: json['under_voltage'] as bool? ?? false,
      isOverTemp: json['over_temp'] as bool? ?? false,
      isCellImbalance: json['cell_imbalance'] as bool? ?? false,
      isCanActive: json['can_status'] as bool? ?? false,
    );
  }
}

@immutable
class HvPduDto {
  final bool mainContactor;
  final double motorContactorCurrent;
  final int dcDcContactor;
  final int auxContactor;
  final int
  dcBusVoltage;

  const HvPduDto({
    required this.mainContactor,
    required this.motorContactorCurrent,
    required this.dcDcContactor,
    required this.auxContactor,
    required this.dcBusVoltage,
  });

  factory HvPduDto.fromJson(Map<String, dynamic> json) {
    return HvPduDto(
      mainContactor:
          json['main_contactor'] == "ON" || json['main_contactor'] == true,
      motorContactorCurrent:
          (json['motor_contactor'] as num?)?.toDouble() ?? 0.0,
      dcDcContactor: json['dc_dc_contactor'] as int? ?? 0,
      auxContactor: json['aux_contactor'] as int? ?? 0,
      dcBusVoltage: json['dc_bus_voltage'] as int? ?? 0,
    );
  }
}

@immutable
class LvPduDto {
  final double inputVoltage;
  final double inputCurrent;
  final int inputPower;
  final double outputCurrent;
  final int loadPower;
  final int temperature;
  final bool isCanActive;

  // Output Channels 1-6
  final List<OutputChannelDto> channels;

  const LvPduDto({
    required this.inputVoltage,
    required this.inputCurrent,
    required this.inputPower,
    required this.outputCurrent,
    required this.loadPower,
    required this.temperature,
    required this.isCanActive,
    required this.channels,
  });

  factory LvPduDto.fromJson(Map<String, dynamic> json) {
    // Map the 6 channels dynamically
    var rawChannels = json['channels'] as List<dynamic>? ?? [];
    List<OutputChannelDto> parsedChannels = rawChannels
        .map((c) => OutputChannelDto.fromJson(c))
        .toList();

    return LvPduDto(
      inputVoltage: (json['input_voltage'] as num?)?.toDouble() ?? 0.0,
      inputCurrent: (json['input_current'] as num?)?.toDouble() ?? 0.0,
      inputPower: json['input_power'] as int? ?? 0,
      outputCurrent: (json['output_current'] as num?)?.toDouble() ?? 0.0,
      loadPower: json['load_power'] as int? ?? 0,
      temperature: json['temperature'] as int? ?? 0,
      isCanActive: json['can_status'] as bool? ?? false,
      channels: parsedChannels,
    );
  }
}

@immutable
class OutputChannelDto {
  final int id;
  final double current;
  final bool isOn;
  final String status;

  const OutputChannelDto({
    required this.id,
    required this.current,
    required this.isOn,
    required this.status
  });

  factory OutputChannelDto.fromJson(Map<String, dynamic> json) {
    return OutputChannelDto(
      id: json['id'] as int? ?? 0,
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
      isOn: json['status'] == "ON" || json['status'] == true,
      status: json['status'] as String? ?? 'OFF',
    );
  }
}

@immutable
class LvBatteryDto {
  final double voltage;
  final double current;

  const LvBatteryDto({required this.voltage, required this.current});

  factory LvBatteryDto.fromJson(Map<String, dynamic> json) {
    return LvBatteryDto(
      voltage: (json['voltage'] as num?)?.toDouble() ?? 0.0,
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
