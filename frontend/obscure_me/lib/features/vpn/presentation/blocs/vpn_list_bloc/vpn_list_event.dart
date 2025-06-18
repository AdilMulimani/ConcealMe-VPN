part of 'vpn_list_bloc.dart';

sealed class VpnListEvent extends Equatable {
  const VpnListEvent();
}

final class FetchVpnListEvent extends VpnListEvent {
  final bool refreshServerList;
  @override
  List<Object?> get props => [refreshServerList];

  const FetchVpnListEvent({required this.refreshServerList});
}
