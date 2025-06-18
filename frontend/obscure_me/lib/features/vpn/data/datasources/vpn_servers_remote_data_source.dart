import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:obscure_me/core/constants/constants.dart';
import 'package:obscure_me/core/error/exceptions.dart';
import 'package:obscure_me/features/vpn/data/models/vpn_model.dart';

abstract interface class VpnServersRemoteDataSource {
  Future<List<VpnModel>> getRemoteVpnServers();
}

class VpnServersRemoteDataSourceImpl implements VpnServersRemoteDataSource {
  @override
  Future<List<VpnModel>> getRemoteVpnServers() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.backendUrl}/vpn/vpn-servers'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final servers =
            List.from(
              jsonDecode(response.body)['servers'],
            ).map((server) => VpnModel.fromMap(server)).toList();
        return servers;
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
