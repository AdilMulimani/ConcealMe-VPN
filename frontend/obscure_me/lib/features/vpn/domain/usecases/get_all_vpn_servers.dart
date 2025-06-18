import 'package:fpdart/fpdart.dart';
import 'package:obscure_me/core/error/failure.dart';
import 'package:obscure_me/core/usecase/usecase.dart';
import 'package:obscure_me/features/vpn/domain/repositories/vpn_repository.dart';

import '../entities/vpn.dart';

class GetVpnServersUsecase implements Usecase<List<Vpn>, GetVpnServerParams> {
  final VpnRepository vpnRepository;
  const GetVpnServersUsecase({required this.vpnRepository});
  @override
  Future<Either<Failure, List<Vpn>>> call(GetVpnServerParams params) async {
    return await vpnRepository.getVpnServers(
      refreshServerList: params.refreshServerList,
    );
  }
}

class GetVpnServerParams {
  final bool refreshServerList;

  const GetVpnServerParams({required this.refreshServerList});
}
