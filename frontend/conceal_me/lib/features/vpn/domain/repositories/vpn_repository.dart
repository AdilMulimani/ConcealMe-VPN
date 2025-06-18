import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/vpn.dart';

abstract interface class VpnRepository {
  Future<Either<Failure, List<Vpn>>> getVpnServers({
    required bool refreshServerList,
  });
  //
  // List<VpnHistory> getHistory();
  //
  // void uploadHistory({required VpnHistory vpnHistory});
}
