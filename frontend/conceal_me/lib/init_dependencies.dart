import 'package:conceal_me/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:conceal_me/core/services/secure_storage_service.dart';
import 'package:conceal_me/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:conceal_me/features/auth/presentation/blocs/lock_pattern_bloc/lock_pattern_bloc.dart';
import 'package:conceal_me/features/vpn/data/datasources/vpn_servers_remote_data_source.dart';
import 'package:conceal_me/features/vpn/data/repositories/vpn_repository_impl.dart';
import 'package:conceal_me/features/vpn/domain/repositories/vpn_repository.dart';
import 'package:conceal_me/features/vpn/domain/usecases/get_all_vpn_servers.dart';
import 'package:conceal_me/features/vpn/presentation/blocs/filtered_vpn_bloc/filtered_vpn_bloc.dart';
import 'package:conceal_me/features/vpn/presentation/blocs/vpn_bloc/vpn_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/hive/models/vpn_history.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_local_repository_impl.dart';
import 'features/auth/data/repositories/auth_remote_repository_impl.dart';
import 'features/auth/domain/repositories/local_auth_repository.dart';
import 'features/auth/domain/repositories/remote_auth_repository.dart';
import 'features/auth/domain/usecases/local_auth_usecases/check_lock_pattern.dart';
import 'features/auth/domain/usecases/local_auth_usecases/set_lock_pattern.dart';
import 'features/auth/domain/usecases/local_auth_usecases/verify_lock_pattern.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/current_user.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/email_verification.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/forgot_password.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/reset_password.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/reset_password_verification.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/signin.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/signup.dart';
import 'features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'features/ip/data/datasources/ip_remote_data_source.dart';
import 'features/ip/data/repositories/ip_repository_impl.dart';
import 'features/ip/domain/repositories/ip_repository.dart';
import 'features/ip/domain/usecases/get_ip_details.dart';
import 'features/ip/presentation/blocs/ip_bloc/ip_bloc.dart';
import 'features/vpn/data/datasources/vpn_servers_local_data_source.dart';
import 'features/vpn/presentation/blocs/vpn_list_bloc/vpn_list_bloc.dart';
import 'features/vpn/presentation/blocs/vpn_search_bloc/vpn_search_bloc.dart';

//global instance of get_it
final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  // initialise Hive
  await Hive.initFlutter();
  await Hive.openBox('vpn_servers_list');
  await Hive.openBox('ip_details');
  //await Hive.deleteBoxFromDisk('vpnHistoryBox');
  Hive.registerAdapter(VpnHistoryAdapter());
  await Hive.openBox<VpnHistory>('vpnHistoryBox');
  // initialise auth
  _initAuth();
  // initialise vpn
  _initVpn();
  // initialise ip
  _initIp();
}

// All Authentication Objects
void _initAuth() {
  // Initialize Cubit Singleton
  getIt.registerLazySingleton<AppUserCubit>(() => AppUserCubit());

  //initialize flutter secure storage singleton
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );

  // initialize secure storage service
  getIt.registerCachedFactory<SecureStorageService>(
    () => SecureStorageServiceImpl(storage: getIt<FlutterSecureStorage>()),
  );

  // initialize auth local data source
  getIt.registerCachedFactory<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );

  // initialize auth remote data source
  getIt.registerCachedFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // initialize auth repository with auth data sources
  getIt.registerCachedFactory<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(
      authLocalDataSource: getIt<AuthLocalDataSource>(),
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  // initialize auth repository with auth data sources
  getIt.registerCachedFactory<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  //Auth Bloc use cases
  getIt.registerCachedFactory<SignupUsecase>(
    () => SignupUsecase(authRepository: getIt.get<AuthRemoteRepository>()),
  );
  getIt.registerCachedFactory<SigninUsecase>(
    () => SigninUsecase(authRepository: getIt<AuthRemoteRepository>()),
  );
  getIt.registerCachedFactory<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(authRepository: getIt<AuthRemoteRepository>()),
  );
  getIt.registerCachedFactory<ResetPasswordVerificationUsecase>(
    () => ResetPasswordVerificationUsecase(
      authRepository: getIt<AuthRemoteRepository>(),
    ),
  );
  getIt.registerCachedFactory<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(authRepository: getIt<AuthRemoteRepository>()),
  );
  getIt.registerCachedFactory<EmailVerificationUsecase>(
    () =>
        EmailVerificationUsecase(authRepository: getIt<AuthRemoteRepository>()),
  );
  getIt.registerCachedFactory<CurrentUserUsecase>(
    () => CurrentUserUsecase(authRepository: getIt<AuthRemoteRepository>()),
  );

  // Auth Bloc
  getIt.registerLazySingleton(
    () => AuthBloc(
      appUserCubit: getIt<AppUserCubit>(),
      signUpUsecase: getIt<SignupUsecase>(),
      signInUsecase: getIt<SigninUsecase>(),
      emailVerificationUsecase: getIt<EmailVerificationUsecase>(),
      forgotPasswordUsecase: getIt<ForgotPasswordUsecase>(),
      resetPasswordVerificationUsecase:
          getIt<ResetPasswordVerificationUsecase>(),
      resetPasswordUsecase: getIt<ResetPasswordUsecase>(),
      currentUser: getIt<CurrentUserUsecase>(),
    ),
  );

  // Lock Pattern Bloc

  // Use cases
  getIt.registerCachedFactory<SaveLockPatternUsecase>(
    () => SaveLockPatternUsecase(authRepository: getIt<AuthLocalRepository>()),
  );

  getIt.registerCachedFactory<VerifyLockPatternUsecase>(
    () =>
        VerifyLockPatternUsecase(authRepository: getIt<AuthLocalRepository>()),
  );

  getIt.registerCachedFactory<CheckLockPatternUsecase>(
    () => CheckLockPatternUsecase(authRepository: getIt<AuthLocalRepository>()),
  );

  getIt.registerLazySingleton(
    () => LockPatternBloc(
      checkLockPatternUsecase: getIt<CheckLockPatternUsecase>(),
      saveLockPatternUsecase: getIt<SaveLockPatternUsecase>(),
      verifyLockPatternUsecase: getIt<VerifyLockPatternUsecase>(),
      appUserCubit: getIt<AppUserCubit>(),
    ),
  );
}

// All Vpn Objects
void _initVpn() async {
  // Vpn Servers Hive Box
  getIt.registerLazySingleton<Box>(
    () => Hive.box('vpn_servers_list'),
    instanceName: 'vpn_servers_list',
  );

  // Remote data source
  getIt.registerCachedFactory<VpnServersRemoteDataSource>(
    () => VpnServersRemoteDataSourceImpl(),
  );

  // Local data source
  getIt.registerCachedFactory<VpnServersLocalDataSource>(
    () => VpnServersLocalDataSourceImpl(
      box: getIt<Box>(instanceName: 'vpn_servers_list'),
    ),
  );
  // Repository
  getIt.registerCachedFactory<VpnRepository>(
    () => VpnRepositoryImpl(
      vpnServersRemoteDataSource: getIt<VpnServersRemoteDataSource>(),
      vpnServersLocalDataSource: getIt<VpnServersLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerCachedFactory<GetVpnServersUsecase>(
    () => GetVpnServersUsecase(vpnRepository: getIt<VpnRepository>()),
  );

  // Bloc
  getIt.registerLazySingleton<VpnBloc>(() => VpnBloc());
  getIt.registerLazySingleton<VpnSearchBloc>(() => VpnSearchBloc());
  getIt.registerLazySingleton<FilteredVpnBloc>(
    () => FilteredVpnBloc(initialVpnServers: []),
  );

  getIt.registerLazySingleton<VpnListBloc>(
    () => VpnListBloc(getAllVpnServersUsecase: getIt<GetVpnServersUsecase>()),
  );
}

// All Ip Objects
void _initIp() async {
  // Vpn Servers Hive Box
  getIt.registerLazySingleton<Box>(
    () => Hive.box('ip_details'),
    instanceName: 'ip_details',
  );

  // Remote data source
  getIt.registerCachedFactory<IpRemoteDataSource>(
    () => IpRemoteDataSourceImpl(),
  );

  // Local data source
  // getIt.registerCachedFactory<IpLocalDataSource>(
  //       () => IpLocalDataSourceImpl(
  //     box: getIt<Box>(instanceName: 'ip_details'),
  //   ),
  // );
  // Repository
  getIt.registerCachedFactory<IpRepository>(
    () => IpRepositoryImpl(
      ipRemoteDataSource: getIt<IpRemoteDataSource>(),
      // vpnLocalDataSource: getIt<VpnLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerCachedFactory<GetIpDetailsUsecase>(
    () => GetIpDetailsUsecase(ipRepository: getIt<IpRepository>()),
  );

  // Bloc
  getIt.registerLazySingleton<IpBloc>(
    () => IpBloc(getIpDetailsUsecase: getIt<GetIpDetailsUsecase>()),
  );
}
