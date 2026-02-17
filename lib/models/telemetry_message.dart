import 'dart:convert';
import 'power_dto.dart';
import 'rf_link_dto.dart';

enum PageType { power, rfLink }

class TelemetryMessage {
  final PageType pageType;
  final Object data;

  TelemetryMessage({
    required this.pageType,
    required this.data,
  });

  factory TelemetryMessage.fromRaw(String raw) {
    final jsonMap = jsonDecode(raw);

    final pageCode = jsonMap['page_code'] as String;
    final data = jsonMap['data'];

    switch (pageCode) {
      case 'POWER':
        return TelemetryMessage(
          pageType: PageType.power,
          data: PowerDto.fromJson(data),
        );

      case 'RF LINK':
        return TelemetryMessage(
          pageType: PageType.rfLink,
          data: RfLinkDto.fromJson(data),
        );

      default:
        throw UnsupportedError('Unknown page_code: $pageCode');
    }
  }
}