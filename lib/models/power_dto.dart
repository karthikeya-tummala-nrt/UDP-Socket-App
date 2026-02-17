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

  HvBattery({
    required this.packVoltage,
    required this.packCurrent,
    required this.soc,
  });

  factory HvBattery.fromJson(Map<String, dynamic> json) {
    return HvBattery(
      packVoltage: (json['pack_voltage'] as num).toDouble(),
      packCurrent: (json['pack_current'] as num).toDouble(),
      soc: json['soc'],
    );
  }
}

class HvPdu {
  final String mainContactor;
  final double motorContactor;

  HvPdu({required this.mainContactor, required this.motorContactor});

  factory HvPdu.fromJson(Map<String, dynamic> json) {
    return HvPdu(
      mainContactor: json['main_contactor'],
      motorContactor: (json['motor_contactor'] as num).toDouble(),
    );
  }
}

class LvPdu {
  final double inputVoltage;
  final double inputCurrent;
  final List<Channel> channels;

  LvPdu({
    required this.inputVoltage,
    required this.inputCurrent,
    required this.channels,
  });

  factory LvPdu.fromJson(Map<String, dynamic> json) {
    return LvPdu(
      inputVoltage: (json['input_voltage'] as num).toDouble(),
      inputCurrent: (json['input_current'] as num).toDouble(),
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
