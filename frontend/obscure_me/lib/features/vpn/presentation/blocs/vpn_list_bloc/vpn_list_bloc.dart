import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/vpn.dart';
import '../../../domain/usecases/get_all_vpn_servers.dart';

part 'vpn_list_event.dart';
part 'vpn_list_state.dart';

class VpnListBloc extends Bloc<VpnListEvent, VpnListState> {
  final GetVpnServersUsecase _getAllVpnServersUsecase;

  VpnListBloc({required GetVpnServersUsecase getAllVpnServersUsecase})
    : _getAllVpnServersUsecase = getAllVpnServersUsecase,
      super(VpnListInitial()) {
    on<VpnListEvent>((event, emit) {
      emit(VpnListLoading());
    });
    on<FetchVpnListEvent>((event, emit) async {
      final res = await _getAllVpnServersUsecase(
        GetVpnServerParams(refreshServerList: event.refreshServerList),
      );
      res.fold(
        (failure) => emit(VpnListFailure(error: failure.message)),
        (servers) => emit(VpnListFetched(servers: servers)),
      );
    });
  }
}
