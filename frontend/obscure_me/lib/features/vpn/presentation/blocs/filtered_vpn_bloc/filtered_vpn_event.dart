part of 'filtered_vpn_bloc.dart';

sealed class FilteredVpnEvent extends Equatable {
  const FilteredVpnEvent();

  @override
  List<Object> get props => [];
}

class CalculateFilteredVpnEvent extends FilteredVpnEvent {
  const CalculateFilteredVpnEvent({
    required this.filteredVpnServers,
  });

  final List<Vpn> filteredVpnServers;


  @override
  String toString() {
    return 'CalculateFilteredVpnEvent{filteredVpnServers: $filteredVpnServers}';
  }

  @override
  List<Object> get props => [filteredVpnServers];
}
