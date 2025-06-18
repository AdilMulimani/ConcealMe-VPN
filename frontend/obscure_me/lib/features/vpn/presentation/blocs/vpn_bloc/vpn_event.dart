part of 'vpn_bloc.dart';

@immutable
sealed class VpnEvent {}

final class VpnSelectVpn extends VpnEvent {
  final Vpn server;
  VpnSelectVpn({required this.server});
}

final class VpnConnect extends VpnEvent {
  final Vpn server;
  VpnConnect({required this.server});
}

final class VpnDisconnect extends VpnEvent {
  final Vpn server;
  VpnDisconnect({required this.server});
}
