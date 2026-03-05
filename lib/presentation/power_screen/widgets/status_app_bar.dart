import 'dart:async';
import 'package:flutter/material.dart';
import '../../../repository/hv_bms_repository.dart';
import '../../../models/hv_bms_telemetry.dart';

class StatusAppBar extends StatefulWidget implements PreferredSizeWidget {
  final HvBmsRepository repository;

  const StatusAppBar({super.key, required this.repository});

  @override
  Size get preferredSize => const Size.fromHeight(25);

  @override
  State<StatusAppBar> createState() => _StatusAppBarState();
}

class _StatusAppBarState extends State<StatusAppBar> {
  final ValueNotifier<double> _socNotifier = ValueNotifier<double>(0);
  StreamSubscription<HvBmsTelemetry>? _subscription;

  final Stopwatch _stopwatch = Stopwatch()..start();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    widget.repository.start();

    _subscription = widget.repository.stream.listen((telemetry) {
      if (_socNotifier.value != telemetry.soc) {
        _socNotifier.value = telemetry.soc;
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    _socNotifier.dispose();
    super.dispose();
  }

  String _formatUptime() {
    final duration = _stopwatch.elapsed;

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "MODE: SAFE HOLD",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),

          Text("UP TIME : ${_formatUptime()}", style: TextStyle(fontSize: 18)),

          Row(
            children: [
              const Icon(Icons.wifi, size: 20, color: Colors.green),
              const SizedBox(width: 16),
              Text(date, style: TextStyle(fontSize: 18)),
              const SizedBox(width: 16),

              ValueListenableBuilder<double>(
                valueListenable: _socNotifier,
                builder: (_, soc, _) {
                  return _BatteryIndicator(percentage: soc);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BatteryIndicator extends StatelessWidget {
  final double percentage;

  const _BatteryIndicator({required this.percentage});

  Color getBatteryColor(num percentage) {
    if (percentage > 60) {
      return Colors.green;
    } else if (percentage > 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clamped = percentage.clamp(0, 100);
    final fill = clamped / 100.0;

    return Container(
      width: 40,
      height: 18,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fill,
              child: Container(
                decoration: BoxDecoration(
                  color: getBatteryColor(clamped),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Text
          Center(
            child: Text(
              "${clamped.toStringAsFixed(0)}%",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
