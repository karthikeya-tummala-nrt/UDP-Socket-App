import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/telemetry_data.dart';
import '../../domain/repositories/i_telemetry_repository.dart';
import '../../data/models/power_dto.dart';
import '../../data/models/rf_link_dto.dart';

part 'telemetry_event.dart';
part 'telemetry_state.dart';

class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final ITelemetryRepository _repository;
  StreamSubscription? _subscription;

  TelemetryBloc(this._repository) : super(const TelemetryState()) {

    on<ConnectTelemetry>((event, emit) {
      _repository.connect();
      emit(state.copyWith(isConnected: true));

      _subscription?.cancel();
      _subscription = _repository.telemetryStream.listen((data) {
        add(_NewTelemetryDataReceived(data));
      });
    });

    on<DisconnectTelemetry>((event, emit) {
      _subscription?.cancel();
      _repository.disconnect();
      emit(state.copyWith(isConnected: false));
    });

    on<_NewTelemetryDataReceived>((event, emit) {
      final data = event.data;
      if (data is PowerDto) {
        emit(state.copyWith(power: data));
      } else if (data is RfLinkDto) {
        emit(state.copyWith(rf: data));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}