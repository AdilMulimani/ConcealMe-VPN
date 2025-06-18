part of 'vpn_list_bloc.dart';

sealed class VpnListState extends Equatable {}

final class VpnListInitial extends VpnListState {
  @override
  List<Object> get props => [];
}

final class VpnListLoading extends VpnListState {
  @override
  List<Object> get props => [];
}

final class VpnListFetched extends VpnListState {
  final List<Vpn> servers;

  VpnListFetched({required this.servers});

  factory VpnListFetched.initial() {
    return VpnListFetched(servers: <Vpn>[]);
  }

  VpnListFetched copyWith({List<Vpn>? servers}) {
    return VpnListFetched(servers: servers ?? this.servers);
  }

  @override
  List<Object> get props => [servers];

  @override
  String toString() {
    return 'VpnListState{servers: $servers}';
  }
}

final class VpnListFailure extends VpnListState {
  final String error;

  VpnListFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
