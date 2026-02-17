import 'package:flutter/foundation.dart';
import 'package:gcs_sockets/features/telemetry/domain/entities/telemetry_data.dart';

@immutable
class RfLinkDto extends TelemetryData{
  final TxDto tx;
  final RxDto rx;
  final LinkQualityDto linkQuality;

  const RfLinkDto({
    required String pageCode,
    required this.tx,
    required this.rx,
    required this.linkQuality,
  }) : super(pageCode);

  factory RfLinkDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return RfLinkDto(
      pageCode: json['page_code'] as String? ?? 'UNKNOWN',
      tx: TxDto.fromJson(data['tx'] ?? {}),
      rx: RxDto.fromJson(data['rx'] ?? {}),
      linkQuality: LinkQualityDto.fromJson(data['link_quality'] ?? {}),
    );
  }
}

// --- SUB-CLASSES ---

@immutable
class TxDto {
  final int frequency;    // 1421 MHz
  final int powerOutput;  // 28 dBm
  final int dataRate;     // 256 kbp/s
  final bool isFecOn;     // Enabled/Disabled
  final int errors;       // 0 pps

  const TxDto({
    required this.frequency,
    required this.powerOutput,
    required this.dataRate,
    required this.isFecOn,
    required this.errors,
  });

  factory TxDto.fromJson(Map<String, dynamic> json) {
    return TxDto(
      frequency: json['frequency'] as int? ?? 0,
      powerOutput: json['power_output'] as int? ?? 0,
      dataRate: json['data_rate'] as int? ?? 0,
      isFecOn: json['fec'] as bool? ?? false,
      errors: json['errors'] as int? ?? 0,
    );
  }
}

@immutable
class RxDto {
  final int frequency;      // 1424 MHz
  final int rssi;           // -20 dBm
  final int dsnr;           // 15 dB
  final int dataRate;       // 256 kbps
  final bool isLocked;      // LOCKED / UNLOCKED

  const RxDto({
    required this.frequency,
    required this.rssi,
    required this.dsnr,
    required this.dataRate,
    required this.isLocked,
  });

  factory RxDto.fromJson(Map<String, dynamic> json) {
    return RxDto(
      frequency: json['frequency'] as int? ?? 0,
      rssi: json['rssi'] as int? ?? 0,
      dsnr: json['dsnr'] as int? ?? 0,
      dataRate: json['data_rate'] as int? ?? 0,
      isLocked: json['lock_status'] as bool? ?? false,
    );
  }
}

@immutable
class LinkQualityDto {
  final String status;      // "OK"
  final int linkMargin;     // 12 db
  final int rtt;            // 50 ms
  final int auxContactor;   // 96 % (Included here per image layout)
  final int throughputUp;   // 928 kbps
  final int throughputDown; // 200 kbps

  const LinkQualityDto({
    required this.status,
    required this.linkMargin,
    required this.rtt,
    required this.auxContactor,
    required this.throughputUp,
    required this.throughputDown,
  });

  factory LinkQualityDto.fromJson(Map<String, dynamic> json) {
    return LinkQualityDto(
      status: json['status'] as String? ?? 'N/A',
      linkMargin: json['link_margin'] as int? ?? 0,
      rtt: json['rtt'] as int? ?? 0,
      auxContactor: json['aux_contactor'] as int? ?? 0,
      throughputUp: json['throughput_up'] as int? ?? 0,
      throughputDown: json['throughput_down'] as int? ?? 0,
    );
  }
}