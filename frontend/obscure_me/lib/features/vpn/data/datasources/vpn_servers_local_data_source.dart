import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/vpn_model.dart';

abstract interface class VpnServersLocalDataSource {
  List<VpnModel> getLocalVpnServers();

  void uploadLocalVpnServers({required List<VpnModel> vpnServers});
}

class VpnServersLocalDataSourceImpl implements VpnServersLocalDataSource {
  final Box box;

  const VpnServersLocalDataSourceImpl({required this.box});

  @override
  List<VpnModel> getLocalVpnServers() {
    List<VpnModel> vpnServers = [];
    final List<dynamic> jsonVpnServers = jsonDecode(
      box.get('vpn_servers_list') ?? '[]',
    );
    for (var jsonVpnServer in jsonVpnServers) {
      vpnServers.add(VpnModel.fromMap(jsonVpnServer));
    }
    return vpnServers;
  }

  @override
  void uploadLocalVpnServers({required List<VpnModel> vpnServers}) {
    box.clear();
    final List<Map<String, dynamic>> jsonVpnServers =
        vpnServers.map((vpn) => vpn.toMap()).toList();
    final String encodedVpnServers = jsonEncode(jsonVpnServers);
    box.put('vpn_servers_list', encodedVpnServers);
  }
}
