part of 'telemetry_bloc.dart';

abstract class TelemetryEvent {}

/// Triggered when the app starts or user clicks "Connect"
class ConnectTelemetry extends TelemetryEvent {}

/// Triggered when the user clicks "Disconnect"
class DisconnectTelemetry extends TelemetryEvent {}

/// INTERNAL USE ONLY: Triggered when the Repository sends new data
class _NewTelemetryDataReceived extends TelemetryEvent {
  final TelemetryData data;
  _NewTelemetryDataReceived(this.data);
}