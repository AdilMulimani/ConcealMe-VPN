import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

abstract interface class AuthLocalRepository {
  // Local Authentication  DataSource
  // Lock Pattern
  Future<Either<Failure, bool>> saveLockPattern(List<int> pattern);
  Future<Either<Failure, List<int>?>> getLockPattern([
    String key = 'LOCK_PATTERN_KEY',
  ]);

  Future<Either<Failure, bool>> verifyLockPattern(
    List<int> pattern, [
    String key = 'LOCK_PATTERN_KEY',
  ]);

  Future<Either<Failure, bool>> containsLockPattern([
    String key = 'LOCK_PATTERN_KEY',
  ]);

  Future<void> deleteLockPattern();
}
