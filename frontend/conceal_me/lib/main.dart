import 'dart:async';

import 'package:conceal_me/core/routes/app_router.dart';
import 'package:conceal_me/features/vpn/presentation/blocs/filtered_vpn_bloc/filtered_vpn_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'features/auth/presentation/blocs/lock_pattern_bloc/lock_pattern_bloc.dart';
import 'features/ip/presentation/blocs/ip_bloc/ip_bloc.dart';
import 'features/vpn/presentation/blocs/vpn_bloc/vpn_bloc.dart';
import 'features/vpn/presentation/blocs/vpn_list_bloc/vpn_list_bloc.dart';
import 'features/vpn/presentation/blocs/vpn_search_bloc/vpn_search_bloc.dart';
import 'init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load env variables
  await dotenv.load(fileName: '.env');
  // Setup Hydrated Bloc Storage
  // // Clear previous storage if needed
  // final directory = await getTemporaryDirectory();
  // final storageDir = Directory('${directory.path}/hydrated_bloc');
  // if (await storageDir.exists()) {
  //   await storageDir.delete(recursive: true);
  //   debugPrint('Cleared previous hydrated storage');
  // }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  //Set up code dependencies
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AppUserCubit>()),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<LockPatternBloc>()),
        BlocProvider(create: (context) => getIt<VpnBloc>()),
        BlocProvider(create: (context) => getIt<VpnListBloc>()),
        BlocProvider(create: (context) => getIt<VpnSearchBloc>()),
        BlocProvider(create: (context) => getIt<FilteredVpnBloc>()),
        BlocProvider(create: (context) => getIt<IpBloc>()),
      ],
      child: ToastificationWrapper(child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Trigger authentication check on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // context.read<AuthBloc>().add(AuthIsUserSignedIn());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VPN App',
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
            child: ClampingScrollWrapper(child: child!),
          ),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      routerConfig: appRouter,
    );
  }
}
