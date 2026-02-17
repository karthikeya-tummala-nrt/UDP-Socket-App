import '../entities/telemetry_data.dart';

abstract class ITelemetryRepository {
  Stream<TelemetryData> get telemetryStream;

  void connect();

  void disconnect();
}