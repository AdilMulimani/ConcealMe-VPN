import 'package:bloc/bloc.dart';
import 'package:conceal_me/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/usecases/local_auth_usecases/check_lock_pattern.dart';
import '../../../domain/usecases/local_auth_usecases/set_lock_pattern.dart';
import '../../../domain/usecases/local_auth_usecases/verify_lock_pattern.dart';

part 'lock_pattern_event.dart';
part 'lock_pattern_state.dart';

class LockPatternBloc extends Bloc<LockPatternEvent, LockPatternState> {
  final AppUserCubit _appUserCubit;
  final SaveLockPatternUsecase _saveLockPatternUsecase;
  final VerifyLockPatternUsecase _verifyLockPatternUsecase;

  final CheckLockPatternUsecase _checkLockPatternUsecase;

  LockPatternBloc({
    required AppUserCubit appUserCubit,
    required SaveLockPatternUsecase saveLockPatternUsecase,
    required VerifyLockPatternUsecase verifyLockPatternUsecase,
    required CheckLockPatternUsecase checkLockPatternUsecase,
  }) : _appUserCubit = appUserCubit,
       _saveLockPatternUsecase = saveLockPatternUsecase,
       _verifyLockPatternUsecase = verifyLockPatternUsecase,
       _checkLockPatternUsecase = checkLockPatternUsecase,
       super(LockPatternInitial()) {
    on<LockPatternEvent>((event, emit) => emit(LockPatternLoading()));

    on<LockPatternSetup>((event, emit) async {
      final response = await _saveLockPatternUsecase(
        SetLockPatternParams(pattern: event.pattern),
      );
      response.fold(
        (failure) => emit(LockPatternFailure(message: failure.message)),
        (set) {
          if (set) {
            emit(
              LockPatternSuccess(message: 'Lock Pattern saved successfully'),
            );
          } else {
            emit(LockPatternFailure(message: 'Error in saving lock pattern'));
          }
        },
      );
    });

    on<LockPatternVerification>((event, emit) async {
      final response = await _verifyLockPatternUsecase(
        VerifyLockPatternParams(pattern: event.pattern),
      );
      response.fold(
        (failure) => emit(LockPatternFailure(message: failure.message)),
        (verified) {
          if (verified) {
            //  _appUserCubit.updateLockVerification();
            emit(LockPatternSuccess(message: 'Lock Pattern Verified'));
          } else {
            emit(LockPatternFailure(message: 'Lock Pattern failed'));
          }
        },
      );
    });
  }
}
