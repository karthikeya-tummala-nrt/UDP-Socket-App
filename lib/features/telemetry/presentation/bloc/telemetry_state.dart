part of 'telemetry_bloc.dart';

class TelemetryState {
  final bool isConnected;
  final PowerDto? power;  // Holds the latest Power data
  final RfLinkDto? rf;    // Holds the latest RF Link data

  const TelemetryState({
    this.isConnected = false,
    this.power,
    this.rf,
  });

  /// Helper to copy the state safely (updates only what changed)
  TelemetryState copyWith({
    bool? isConnected,
    PowerDto? power,
    RfLinkDto? rf,
  }) {
    return TelemetryState(
      isConnected: isConnected ?? this.isConnected,
      power: power ?? this.power,
      rf: rf ?? this.rf,
    );
  }
}