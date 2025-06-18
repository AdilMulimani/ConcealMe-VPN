part of 'filtered_vpn_bloc.dart';

final class FilteredVpnState extends Equatable {
  const FilteredVpnState({
    required this.filteredVpnServers,
  });

  factory FilteredVpnState.initial() {
    return const FilteredVpnState(filteredVpnServers: []);
  }

  final List<Vpn> filteredVpnServers;

  @override
  List<Object> get props => [filteredVpnServers];

  @override
  String toString() => 'FilteredVpnState(filteredVpnServers: $filteredVpnServers)';

  FilteredVpnState copyWith({
    List<Vpn>? filteredVpnServers,
  }) {
    return FilteredVpnState(
      filteredVpnServers: filteredVpnServers ?? this.filteredVpnServers,
    );
  }
}
