part of 'vpn_bloc.dart';

@immutable
sealed class VpnState extends Equatable {
  const VpnState();

  @override
  List<Object> get props => [];
}

final class VpnInitial extends VpnState {}

final class VpnLoading extends VpnState {}

final class VpnSelect extends VpnState {
  final Vpn server;

  const VpnSelect({required this.server});

  Map<String, dynamic> toJson() => {'server': server.toJson()};

  factory VpnSelect.fromJson(Map<String, dynamic> json) {
    return VpnSelect(server: Vpn.fromJson(json['server']));
  }

  @override
  List<Object> get props => [server];
}

class VpnConnected extends VpnState {
  final Vpn server;

  const VpnConnected({required this.server});

  Map<String, dynamic> toJson() => {'server': server.toJson()};

  factory VpnConnected.fromJson(Map<String, dynamic> json) {
    return VpnConnected(server: Vpn.fromJson(json['server']));
  }

  @override
  List<Object> get props => [server];
}

class VpnDisconnected extends VpnState {
  final Vpn server;

  const VpnDisconnected({required this.server});

  Map<String, dynamic> toJson() => {'server': server.toJson()};

  factory VpnDisconnected.fromJson(Map<String, dynamic> json) {
    return VpnDisconnected(server: Vpn.fromJson(json['server']));
  }

  @override
  List<Object> get props => [server];
}
