import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../domain/entities/vpn.dart';

part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnState> {
  VpnBloc() : super(VpnInitial()) {
    on<VpnEvent>((event, emit) {
      emit(VpnLoading());
    });

    on<VpnSelectVpn>((event, emit) {
      emit(VpnSelect(server: event.server));
    });

    on<VpnConnect>((event, emit) {
      emit(VpnConnected(server: event.server));
    });

    on<VpnDisconnect>((event, emit) {
      emit(VpnDisconnected(server: event.server));
    });
  }
}
