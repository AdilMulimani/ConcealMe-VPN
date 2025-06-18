import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obscure_me/core/usecase/usecase.dart';

import '../../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../../core/entities/auth/user.dart';
import '../../../domain/usecases/remote_auth_usecases/current_user.dart';
import '../../../domain/usecases/remote_auth_usecases/email_verification.dart';
import '../../../domain/usecases/remote_auth_usecases/forgot_password.dart';
import '../../../domain/usecases/remote_auth_usecases/reset_password.dart';
import '../../../domain/usecases/remote_auth_usecases/reset_password_verification.dart';
import '../../../domain/usecases/remote_auth_usecases/signin.dart';
import '../../../domain/usecases/remote_auth_usecases/signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final SignupUsecase _signUpUsecase;
  final SigninUsecase _signInUsecase;

  final EmailVerificationUsecase _emailVerificationUsecase;

  final ForgotPasswordUsecase _forgotPasswordUsecase;

  final ResetPasswordVerificationUsecase _resetPasswordVerificationUsecase;

  final ResetPasswordUsecase _resetPasswordUsecase;

  final CurrentUserUsecase _currentUser;

  AuthBloc({
    required AppUserCubit appUserCubit,
    required SignupUsecase signUpUsecase,
    required SigninUsecase signInUsecase,
    required EmailVerificationUsecase emailVerificationUsecase,
    required ForgotPasswordUsecase forgotPasswordUsecase,
    required ResetPasswordVerificationUsecase resetPasswordVerificationUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
    required CurrentUserUsecase currentUser,
  }) : _appUserCubit = appUserCubit,
       _signUpUsecase = signUpUsecase,
       _signInUsecase = signInUsecase,
       _emailVerificationUsecase = emailVerificationUsecase,
       _forgotPasswordUsecase = forgotPasswordUsecase,
       _resetPasswordVerificationUsecase = resetPasswordVerificationUsecase,
       _resetPasswordUsecase = resetPasswordUsecase,
       _currentUser = currentUser,
       super(AuthInitial()) {
    // Any Auth Event
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    // Sign up event
    on<AuthSignUp>((event, emit) async {
      final response = await _signUpUsecase(
        SignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      response.fold((failure) => emit(AuthFailure(message: failure.message)), (
        user,
      ) {
        _appUserCubit.updateUserStatus(user);
        emit(AuthSuccess(user: user));
      });
    });

    // Sign in event
    on<AuthSignIn>((event, emit) async {
      final response = await _signInUsecase(
        SignInParams(email: event.email, password: event.password),
      );

      response.fold((failure) => emit(AuthFailure(message: failure.message)), (
        user,
      ) {
        _appUserCubit.updateUserStatus(user);
        emit(AuthSuccess(user: user));
      });
    });

    // Email Verification event
    on<AuthEmailVerification>((event, emit) async {
      final response = await _emailVerificationUsecase(
        EmailVerificationParams(verificationToken: event.verificationToken),
      );
      response.fold(
        (failure) =>
            emit(AuthEmailVerificationFailure(message: failure.message)),
        (user) => emit(AuthEmailVerificationSuccess(user: user)),
      );
    });

    // Forgot password event
    on<AuthForgotPassword>((event, emit) async {
      final response = await _forgotPasswordUsecase(
        ForgotPasswordParams(email: event.email),
      );
      response.fold(
        (failure) => emit(AuthForgotPasswordFailure(message: failure.message)),
        (message) => emit(AuthForgotPasswordSuccess(message: message)),
      );
    });

    // Reset password otp verification event
    on<AuthResetPasswordVerification>((event, emit) async {
      final response = await _resetPasswordVerificationUsecase(
        ResetPasswordVerificationParams(
          resetPasswordToken: event.resetPasswordToken,
        ),
      );
      response.fold(
        (failure) =>
            emit(AuthResetPasswordVerificationFailure(error: failure.message)),
        (message) =>
            emit(AuthResetPasswordVerificationSuccess(message: message)),
      );
    });

    // Reset password event
    on<AuthResetPassword>((event, emit) async {
      final response = await _resetPasswordUsecase(
        ResetPasswordParams(
          password: event.password,
          resetPasswordToken: event.resetPasswordToken,
        ),
      );

      response.fold(
        (failure) => emit(AuthResetPasswordFailure(error: failure.message)),
        (message) => emit(AuthResetPasswordSuccess(message: message)),
      );
    });

    //Check current user
    on<AuthIsUserSignedIn>((event, emit) async {
      final response = await _currentUser(NoParams());
      response.fold((failure) {
        emit(AuthFailure(message: failure.message));
        _appUserCubit.updateUserStatus(null);
      }, (user) => _emitAuthSuccess(user, emit));
    });
  }

  // Helper function to update cubit and bloc auth status
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUserStatus(user);
    emit(AuthSuccess(user: user));
  }
}
