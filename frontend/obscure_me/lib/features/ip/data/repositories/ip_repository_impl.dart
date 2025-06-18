import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:obscure_me/core/error/failure.dart';
import 'package:obscure_me/features/ip/domain/entities/ip_details.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/ip_repository.dart';
import '../datasources/ip_remote_data_source.dart';

class IpRepositoryImpl implements IpRepository {
  final IpRemoteDataSource ipRemoteDataSource;

  @override
  Future<Either<Failure, IpDetails>> getIpDetails() async {
    try {
      final ipDetails = await ipRemoteDataSource.getIpDetails();
      return right(ipDetails);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  const IpRepositoryImpl({required this.ipRemoteDataSource});
}
