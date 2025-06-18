part of 'lock_pattern_bloc.dart';

@immutable
sealed class LockPatternState {}

final class LockPatternInitial extends LockPatternState {}

final class LockPatternLoading extends LockPatternState {}

final class LockPatternSuccess extends LockPatternState {
  final String message;

  LockPatternSuccess({required this.message});
}

final class LockPatternSave extends LockPatternState {
  final List<int> pattern;

  LockPatternSave({required this.pattern});
}

final class LockPatternFailure extends LockPatternState {
  final String message;
  LockPatternFailure({required this.message});
}
