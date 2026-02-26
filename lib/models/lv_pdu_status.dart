class LvPduStatus {
  static const int packetSize = 24;

  final double inputVoltage;
  final double inputCurrent;
  final double inputPower;
  final int channelMask;
  final List<double> channelCurrents;
  final double temperature;
  final int canStatus;

  const LvPduStatus({
    required this.inputVoltage,
    required this.inputCurrent,
    required this.inputPower,
    required this.channelMask,
    required this.channelCurrents,
    required this.temperature,
    required this.canStatus,
  });

  bool channelEnabled(int index) {
    if (index < 0 || index > 5) return false;
    return (channelMask & (1 << index)) != 0;
  }

  bool get canOk => canStatus == 1;
}