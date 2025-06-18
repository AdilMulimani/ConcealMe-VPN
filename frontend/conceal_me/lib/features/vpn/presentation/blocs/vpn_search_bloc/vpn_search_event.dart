part of 'vpn_search_bloc.dart';

sealed class VpnSearchEvent extends Equatable {
  const VpnSearchEvent();

  @override
  List<Object> get props => [];
}

final class SetSearchTermEvent extends VpnSearchEvent {
  const SetSearchTermEvent({
    required this.newSearchTerm,
  });

  final String newSearchTerm;

  @override
  String toString() => 'SetSearchTermEvent(newSearchTerm: $newSearchTerm)';

  @override
  List<Object> get props => [newSearchTerm];
}
