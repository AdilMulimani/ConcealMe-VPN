import 'package:fpdart/fpdart.dart';
import 'package:obscure_me/core/error/failure.dart';
import 'package:obscure_me/core/usecase/usecase.dart';

import '../../repositories/local_auth_repository.dart';

class VerifyLockPatternUsecase
    implements Usecase<bool, VerifyLockPatternParams> {
  final AuthLocalRepository authRepository;

  @override
  Future<Either<Failure, bool>> call(VerifyLockPatternParams params) async {
    return await authRepository.verifyLockPattern(params.pattern);
  }

  const VerifyLockPatternUsecase({required this.authRepository});
}

class VerifyLockPatternParams {
  final List<int> pattern;

  VerifyLockPatternParams({required this.pattern});
}
