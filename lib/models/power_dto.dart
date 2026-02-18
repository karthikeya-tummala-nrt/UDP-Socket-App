class PowerDto {
  final HvBattery hvBattery;
  final HvPdu hvPdu;
  final LvPdu lvPdu;
  final LvBattery lvBattery;

  PowerDto({
    required this.hvBattery,
    required this.hvPdu,
    required this.lvPdu,
    required this.lvBattery,
  });

  factory PowerDto.fromJson(Map<String, dynamic> json) {
    return PowerDto(
      hvBattery: HvBattery.fromJson(json['hv_battery']),
      hvPdu: HvPdu.fromJson(json['hv_pdu']),
      lvPdu: LvPdu.fromJson(json['lv_pdu']),
      lvBattery: LvBattery.fromJson(json['lv_battery']),
    );
  }
}

class HvBattery {
  final double packVoltage;
  final double packCurrent;
  final int soc;
  final int soh;
  final int capacityRemaining;
  final double maxCellVoltage;
  final double minCellVoltage;
  final int maxCellTemp;
  final bool overVoltage;
  final bool underVoltage;
  final bool overTemp;
  final bool cellImbalance;
  final bool canStatus;

  HvBattery({
    required this.packVoltage,
    required this.packCurrent,
    required this.soc,
    required this.soh,
    required this.capacityRemaining,
    required this.maxCellVoltage,
    required this.minCellVoltage,
    required this.maxCellTemp,
    required this.overVoltage,
    required this.underVoltage,
    required this.overTemp,
    required this.cellImbalance,
    required this.canStatus,
  });

  factory HvBattery.fromJson(Map<String, dynamic> json) {
    return HvBattery(
      packVoltage: (json['pack_voltage'] as num).toDouble(),
      packCurrent: (json['pack_current'] as num).toDouble(),
      soc: json['soc'],
      soh: json['soh'],
      capacityRemaining: json['capacity_remaining'],
      maxCellVoltage: (json['max_cell_voltage'] as num).toDouble(),
      minCellVoltage: (json['min_cell_voltage'] as num).toDouble(),
      maxCellTemp: json['max_cell_temp'],
      overVoltage: json['over_voltage'],
      underVoltage: json['under_voltage'],
      overTemp: json['over_temp'],
      cellImbalance: json['cell_imbalance'],
      canStatus: json['can_status'],
    );
  }
}

class HvPdu {
  final String mainContactor;
  final double motorContactor;
  final double dcDcContactor;
  final double auxContactor;
  final double dcBusVoltage;

  HvPdu({
    required this.mainContactor,
    required this.motorContactor,
    required this.dcDcContactor,
    required this.auxContactor,
    required this.dcBusVoltage,
  });

  factory HvPdu.fromJson(Map<String, dynamic> json) {
    return HvPdu(
      mainContactor: json['main_contactor'],
      motorContactor: (json['motor_contactor'] as num).toDouble(),
      dcDcContactor: (json['dc_dc_contactor'] as num).toDouble(),
      auxContactor: (json['aux_contactor'] as num).toDouble(),
      dcBusVoltage: (json['dc_bus_voltage'] as num).toDouble(),
    );
  }
}

class LvPdu {
  final double inputVoltage;
  final double inputCurrent;
  final double inputPower;
  final double outputCurrent;
  final double loadPower;
  final int temperature;
  final bool canStatus;
  final List<Channel> channels;

  LvPdu({
    required this.inputVoltage,
    required this.inputCurrent,
    required this.inputPower,
    required this.outputCurrent,
    required this.loadPower,
    required this.temperature,
    required this.canStatus,
    required this.channels,
  });

  factory LvPdu.fromJson(Map<String, dynamic> json) {
    return LvPdu(
      inputVoltage: (json['input_voltage'] as num).toDouble(),
      inputCurrent: (json['input_current'] as num).toDouble(),
      inputPower: (json['input_power'] as num).toDouble(),
      outputCurrent: (json['output_current'] as num).toDouble(),
      loadPower: (json['load_power'] as num).toDouble(),
      temperature: json['temperature'],
      canStatus: json['can_status'],
      channels: (json['channels'] as List)
          .map((e) => Channel.fromJson(e))
          .toList(),
    );
  }
}

class Channel {
  final int id;
  final double current;
  final String status;

  Channel({required this.id, required this.current, required this.status});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      current: (json['current'] as num).toDouble(),
      status: json['status'],
    );
  }
}

class LvBattery {
  final double voltage;
  final double current;

  LvBattery({required this.voltage, required this.current});

  factory LvBattery.fromJson(Map<String, dynamic> json) {
    return LvBattery(
      voltage: (json['voltage'] as num).toDouble(),
      current: (json['current'] as num).toDouble(),
    );
  }
}