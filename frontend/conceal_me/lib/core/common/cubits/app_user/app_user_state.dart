part of 'app_user_cubit.dart';

sealed class AppUserState extends Equatable {
  const AppUserState();

  @override
  List<Object> get props => [];
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;

  //final bool isPatternVerified;

  const AppUserLoggedIn({
    required this.user,
    //this.isPatternVerified = false
  });
//
// AppUserLoggedIn copyWith({bool? isPatternVerified}) {
//   return AppUserLoggedIn(
//     user: user,
//     isPatternVerified: isPatternVerified ?? this.isPatternVerified,
//   );
// }
}

final class AppUserSessionExpired extends AppUserState {}
