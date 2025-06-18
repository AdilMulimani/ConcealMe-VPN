import 'package:fpdart/fpdart.dart';
import 'package:obscure_me/core/error/failure.dart';
import 'package:obscure_me/core/usecase/usecase.dart';

import '../entities/ip_details.dart';
import '../repositories/ip_repository.dart';

class GetIpDetailsUsecase implements Usecase<IpDetails, NoParams> {
  final IpRepository ipRepository;
  const GetIpDetailsUsecase({required this.ipRepository});
  @override
  Future<Either<Failure, IpDetails>> call(NoParams params) async {
    return await ipRepository.getIpDetails();
  }
}
