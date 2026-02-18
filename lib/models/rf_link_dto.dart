class RfLinkDto {
  final Rx rx;
  final LinkQuality linkQuality;

  RfLinkDto({
    required this.rx,
    required this.linkQuality,
  });

  factory RfLinkDto.fromJson(Map<String, dynamic> json) {
    return RfLinkDto(
      rx: Rx.fromJson(json['rx']),
      linkQuality: LinkQuality.fromJson(json['link_quality']),
    );
  }
}

class Rx {
  final int frequency;
  final int rssi;
  final int dsnr;
  final int dataRate; // NEW
  final bool lockStatus;

  Rx({
    required this.frequency,
    required this.rssi,
    required this.dsnr,
    required this.dataRate,
    required this.lockStatus,
  });

  factory Rx.fromJson(Map<String, dynamic> json) {
    return Rx(
      frequency: json['frequency'],
      rssi: json['rssi'],
      dsnr: json['dsnr'],
      dataRate: json['data_rate'], // NEW
      lockStatus: json['lock_status'],
    );
  }
}

class LinkQuality {
  final String status;
  final int linkMargin;
  final int rtt;
  final int auxContactor; // NEW
  final int throughputUp;
  final int throughputDown;

  LinkQuality({
    required this.status,
    required this.linkMargin,
    required this.rtt,
    required this.auxContactor,
    required this.throughputUp,
    required this.throughputDown,
  });

  factory LinkQuality.fromJson(Map<String, dynamic> json) {
    return LinkQuality(
      status: json['status'],
      linkMargin: json['link_margin'],
      rtt: json['rtt'],
      auxContactor: json['aux_contactor'], // NEW
      throughputUp: json['throughput_up'],
      throughputDown: json['throughput_down'],
    );
  }
}