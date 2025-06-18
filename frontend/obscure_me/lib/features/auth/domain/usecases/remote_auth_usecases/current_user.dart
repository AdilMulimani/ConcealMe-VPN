import 'package:fpdart/fpdart.dart';
import 'package:obscure_me/core/error/failure.dart';
import 'package:obscure_me/core/usecase/usecase.dart';
import 'package:obscure_me/features/auth/domain/repositories/remote_auth_repository.dart';

import '../../../../../core/entities/auth/user.dart';

class CurrentUserUsecase implements Usecase<User, NoParams> {
  final AuthRemoteRepository authRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }

  const CurrentUserUsecase({required this.authRepository});
}
