import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/remote_auth_repository.dart';

class ForgotPasswordUsecase implements Usecase<String, ForgotPasswordParams> {
  final AuthRemoteRepository authRepository;

  @override
  Future<Either<Failure, String>> call(params) async {
    return await authRepository.forgotPasswordWithEmail(email: params.email);
  }

  const ForgotPasswordUsecase({required this.authRepository});
}

class ForgotPasswordParams {
  String email;

  ForgotPasswordParams({required this.email});
}
