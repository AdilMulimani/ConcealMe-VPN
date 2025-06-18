import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/ip_details.dart';

abstract interface class IpRepository {
  Future<Either<Failure, IpDetails>> getIpDetails();
}
