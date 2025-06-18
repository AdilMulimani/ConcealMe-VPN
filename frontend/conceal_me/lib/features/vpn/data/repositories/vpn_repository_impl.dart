import 'package:conceal_me/core/error/exceptions.dart';
import 'package:conceal_me/core/error/failure.dart';
import 'package:conceal_me/features/vpn/data/datasources/vpn_servers_local_data_source.dart';
import 'package:conceal_me/features/vpn/data/datasources/vpn_servers_remote_data_source.dart';
import 'package:conceal_me/features/vpn/domain/entities/vpn.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/repositories/vpn_repository.dart';

class VpnRepositoryImpl implements VpnRepository {
  final VpnServersRemoteDataSource vpnServersRemoteDataSource;
  final VpnServersLocalDataSource vpnServersLocalDataSource;
  // final VpnHistoryLocalDataSource vpnHistoryLocalDataSource;

  const VpnRepositoryImpl({
    required this.vpnServersRemoteDataSource,
    required this.vpnServersLocalDataSource,
    // required this.vpnHistoryLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Vpn>>> getVpnServers({
    required bool refreshServerList,
  }) async {
    try {
      final localVpnServers = vpnServersLocalDataSource.getLocalVpnServers();
      if (localVpnServers.isNotEmpty && !refreshServerList) {
        return right(localVpnServers);
      }

      final remoteVpnServers =
          await vpnServersRemoteDataSource.getRemoteVpnServers();
      remoteVpnServers.shuffle();
      vpnServersLocalDataSource.uploadLocalVpnServers(
        vpnServers: remoteVpnServers,
      );
      // var set = Set();
      // for (VpnModel server in remoteVpnServers) {
      //   set.add(server.speed);
      // }
      // for (String ping in set) {
      //   print(ping);
      // }
      return right(remoteVpnServers);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  // @override
  // List<VpnHistory> getHistory() {
  //   return vpnHistoryLocalDataSource.getHistory();
  // }
  //
  // @override
  // void uploadHistory({required VpnHistory vpnHistory}) {
  //   vpnHistoryLocalDataSource.uploadHistory(vpnHistory: vpnHistory);
  // }
}
