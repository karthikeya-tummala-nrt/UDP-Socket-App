class LvPduStatus {
  static const int packetSize = 27;
  final double inputVoltage;
  final double inputCurrent;
  final double inputPower;
  final double outputCurrent;
  final double loadPower;
  final List<double> channelCurrents;
  final int channelMask;
  final double temperature;
  final bool canStatus;

  const LvPduStatus({
    required this.inputVoltage,
    required this.inputCurrent,
    required this.inputPower,
    required this.outputCurrent,
    required this.loadPower,
    required this.channelCurrents,
    required this.channelMask,
    required this.temperature,
    required this.canStatus,
  });

  bool channelEnabled(int index) {
    if (index < 0 || index > 5) return false;
    return (channelMask & (1 << index)) != 0;
  }

  bool get canOk => canStatus;
}