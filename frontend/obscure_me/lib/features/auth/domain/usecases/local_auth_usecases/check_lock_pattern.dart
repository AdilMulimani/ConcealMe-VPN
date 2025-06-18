import 'package:fpdart/fpdart.dart';
import 'package:obscure_me/core/error/failure.dart';
import 'package:obscure_me/core/usecase/usecase.dart';

import '../../repositories/local_auth_repository.dart';

class CheckLockPatternUsecase implements Usecase<bool, NoParams> {
  final AuthLocalRepository authRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.containsLockPattern();
  }

  const CheckLockPatternUsecase({required this.authRepository});
}
