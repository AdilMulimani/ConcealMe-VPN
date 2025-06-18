import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:obscure_me/core/usecase/usecase.dart';
import 'package:obscure_me/features/ip/domain/entities/ip_details.dart';
import 'package:obscure_me/features/ip/domain/usecases/get_ip_details.dart';

part 'ip_event.dart';
part 'ip_state.dart';

class IpBloc extends Bloc<IpEvent, IpState> {
  final GetIpDetailsUsecase _getIpDetailsUsecase;
  IpBloc({required GetIpDetailsUsecase getIpDetailsUsecase})
    : _getIpDetailsUsecase = getIpDetailsUsecase,
      super(IpInitial()) {
    on<IpEvent>((event, emit) {
      emit(IpLoading());
    });

    on<FetchIpDetails>((event, emit) async {
      final response = await _getIpDetailsUsecase(NoParams());
      response.fold(
        (failure) => emit(IpFailure(error: failure.message)),
        (ipDetails) => emit(IpSuccess(ipDetails: ipDetails)),
      );
    });
  }
}
