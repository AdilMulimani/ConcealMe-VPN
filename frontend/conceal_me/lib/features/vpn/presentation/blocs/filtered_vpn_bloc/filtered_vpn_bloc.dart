import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/vpn.dart';

part 'filtered_vpn_event.dart';
part 'filtered_vpn_state.dart';

class FilteredVpnBloc extends Bloc<FilteredVpnEvent, FilteredVpnState> {
  final List<Vpn> initialVpnServers;

  FilteredVpnBloc({required this.initialVpnServers})
    : super(FilteredVpnState(filteredVpnServers: initialVpnServers)) {
    on<CalculateFilteredVpnEvent>((event, emit) {
      emit(state.copyWith(filteredVpnServers: event.filteredVpnServers));
    });
  }
}
