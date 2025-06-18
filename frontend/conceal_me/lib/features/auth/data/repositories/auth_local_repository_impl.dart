import 'package:conceal_me/core/error/failure.dart';
import 'package:conceal_me/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/repositories/local_auth_repository.dart';

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDataSource authLocalDataSource;
  const AuthLocalRepositoryImpl({required this.authLocalDataSource});

  // TOKEN

  // LOCK
  @override
  Future<void> deleteLockPattern([String key = 'LOCK_PATTERN_KEY']) async {
    await authLocalDataSource.deleteLockPattern(key);
  }

  @override
  Future<Either<Failure, List<int>?>> getLockPattern([
    String key = 'LOCK_PATTERN_KEY',
  ]) async {
    try {
      final lockPattern = await authLocalDataSource.getLockPattern(key);
      return right(lockPattern);
    } catch (e) {
      debugPrint(e.toString());
      return left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveLockPattern(List<int> pattern) async {
    try {
      final isPatternSet = await authLocalDataSource.saveLockPattern(pattern);
      return right(isPatternSet);
    } catch (e) {
      debugPrint(e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyLockPattern(
    List<int> pattern, [
    String key = 'LOCK_PATTERN_KEY',
  ]) async {
    try {
      final lockPattern = await authLocalDataSource.verifyLockPattern(pattern);
      return right(lockPattern);
    } catch (e) {
      debugPrint(e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> containsLockPattern([
    String key = 'LOCK_PATTERN_KEY',
  ]) async {
    try {
      final lockPattern = await authLocalDataSource.containsLockPattern(key);
      return right(lockPattern);
    } catch (e) {
      debugPrint(e.toString());
      return left(Failure(e.toString()));
    }
  }
}
