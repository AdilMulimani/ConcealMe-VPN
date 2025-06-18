part of 'lock_pattern_bloc.dart';

@immutable
sealed class LockPatternEvent {}

final class LockPatternSetup extends LockPatternEvent {
  final List<int> pattern;
  LockPatternSetup({required this.pattern});
}

final class LockPatternVerification extends LockPatternEvent {
  final List<int> pattern;
  LockPatternVerification({required this.pattern});
}

final class LockPatternIsSet extends LockPatternEvent {}
