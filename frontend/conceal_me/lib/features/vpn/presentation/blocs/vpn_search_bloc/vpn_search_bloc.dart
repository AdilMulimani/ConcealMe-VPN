import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'vpn_search_event.dart';
part 'vpn_search_state.dart';

class VpnSearchBloc extends Bloc<VpnSearchEvent, VpnSearchState> {
  VpnSearchBloc() : super(VpnSearchState.initial()) {
    on<SetSearchTermEvent>((event, emit) {
      emit(state.copyWith(searchTerm: event.newSearchTerm));
    }, transformer: debounce(const Duration(milliseconds: 2000)));
  }

  EventTransformer<SetSearchTermEvent> debounce<SetSearchTermEvent>(
    Duration duration,
  ) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
