import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../../../core/network/app_socket.dart';
import '../../domain/entities/telemetry_data.dart'; // The parent class
import '../../domain/repositories/i_telemetry_repository.dart'; // The interface
import '../models/power_dto.dart';
import '../models/rf_link_dto.dart';

class TelemetryRepositoryImpl implements ITelemetryRepository {
  final AppSocket _socket;
  final StreamController<TelemetryData> _controller = StreamController.broadcast();

  TelemetryRepositoryImpl({AppSocket? socket}) : _socket = socket ?? AppSocket();

  @override
  Stream<TelemetryData> get telemetryStream => _controller.stream;

  @override
  void connect() {
    _socket.connect();
    // Listen to the raw "Pipe"
    _socket.stream.listen((message) {
      if (message is String) {
        _handleMessage(message);
      }
    });
  }

  @override
  void disconnect() {
    _socket.disconnect();
    _controller.close();
  }

  void _handleMessage(String rawJson) {
    try {
      final Map<String, dynamic> json = jsonDecode(rawJson);
      final String? pageCode = json['page_code'];

      TelemetryData? data;

      switch (pageCode) {
        case 'POWER':
          data = PowerDto.fromJson(json);
          break;
        case 'RF_LINK':
          data = RfLinkDto.fromJson(json);
          break;
        default:
          debugPrint('Unknown page code: $pageCode');
      }

      if (data != null) {
        _controller.add(data);
      }
    } catch (e) {
      debugPrint('Error parsing telemetry: $e');
    }
  }
}