import 'package:conceal_me/core/error/failure.dart';
import 'package:conceal_me/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/local_auth_repository.dart';

class CheckLockPatternUsecase implements Usecase<bool, NoParams> {
  final AuthLocalRepository authRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.containsLockPattern();
  }

  const CheckLockPatternUsecase({required this.authRepository});
}
