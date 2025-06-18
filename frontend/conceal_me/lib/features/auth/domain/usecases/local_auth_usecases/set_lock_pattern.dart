import 'package:conceal_me/core/error/failure.dart';
import 'package:conceal_me/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/local_auth_repository.dart';

class SaveLockPatternUsecase implements Usecase<bool, SetLockPatternParams> {
  final AuthLocalRepository authRepository;

  @override
  Future<Either<Failure, bool>> call(SetLockPatternParams params) async {
    return await authRepository.saveLockPattern(params.pattern);
  }

  const SaveLockPatternUsecase({required this.authRepository});
}

class SetLockPatternParams {
  List<int> pattern;

  SetLockPatternParams({required this.pattern});
}
