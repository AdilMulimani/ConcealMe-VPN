// import 'package:go_router/go_router.dart';
// import 'package:obscure_me/features/ip/presentation/pages/globe_position_page.dart';
// import 'package:obscure_me/features/ip/presentation/pages/ip_network_test_page.dart';
// import 'package:obscure_me/features/vpn/presentation/pages/vpn_home_test_page.dart';
//
// import '../../features/auth/presentation/pages/forgot_password_page.dart';
// import '../../features/auth/presentation/pages/lock_pattern_page.dart';
// import '../../features/auth/presentation/pages/reset_password_page.dart';
// import '../../features/auth/presentation/pages/set_lock_pattern_page.dart';
// import '../../features/auth/presentation/pages/sign_in_page.dart';
// import '../../features/auth/presentation/pages/sign_up_page.dart';
// import '../../features/auth/presentation/pages/verify_email_otp_page.dart';
// import '../../features/auth/presentation/pages/verify_reset_otp_page.dart';
// import '../../features/vpn/presentation/pages/vpn_locations_page.dart';
// import 'route_paths.dart';
//
// final GoRouter appRouter = GoRouter(
//   // initialLocation: RoutePaths.signIn,
//   initialLocation: '/vpn-test-home-page',
//   debugLogDiagnostics: true,
//   //refreshListenable: GoRouterRefreshStream(getIt<AppUserCubit>().stream),
//   // redirect: (context, state) {
//   //   final appUserState = context.read<AppUserCubit>().state;
//   //
//   //   if (appUserState is AppUserInitial &&
//   //       state.matchedLocation != '/sign-in') {
//   //     return '/sign-in';
//   //   }
//   //
//   //   if (appUserState is AppUserLoggedIn &&
//   //       state.matchedLocation == '/sign-in') {
//   //     return '/vpn-home-page';
//   //   }
//   //
//   //   return null;
//   // },
//   routes: [
//     GoRoute(path: RoutePaths.signUp, builder: (_, __) => const SignUpPage()),
//     GoRoute(path: RoutePaths.signIn, builder: (_, __) => const SignInPage()),
//     GoRoute(
//       path: RoutePaths.forgotPassword,
//       builder: (_, __) => const ForgotPasswordPage(),
//     ),
//     GoRoute(
//       path: RoutePaths.verifyEmailOtp,
//       builder: (_, __) => const VerifyEmailOtpPage(),
//     ),
//     GoRoute(
//       path: RoutePaths.verifyResetOtp,
//       builder: (_, __) => const VerifyResetOtpPage(),
//     ),
//     GoRoute(
//       path: RoutePaths.resetPassword,
//       builder: (_, __) => const ResetPasswordPage(),
//     ),
//     GoRoute(
//       path: RoutePaths.setLockPattern,
//       builder: (_, __) => SetLockPatternPage(),
//     ),
//     GoRoute(
//       path: RoutePaths.lockPattern,
//       builder: (_, __) => LockPatternPage(),
//     ),
//     GoRoute(path: RoutePaths.vpn, builder: (_, __) => VpnLocationsPage()),
//     GoRoute(path: RoutePaths.vpnHome, builder: (_, __) => VpnHomePage()),
//     GoRoute(path: '/vpn-test-home-page', builder: (_, __) => VpnHomeTestPage()),
//     GoRoute(
//       path: RoutePaths.ipNetworkTest,
//       builder: (_, __) => IpNetworkTestPage(),
//     ),
//     GoRoute(
//       path: RoutePaths.globalPosition,
//       builder: (_, __) => GlobePositionPage(),
//     ),
//   ],
// );

import 'package:conceal_me/features/ip/presentation/pages/globe_position_page.dart';
import 'package:conceal_me/features/ip/presentation/pages/ip_network_test_page.dart';
import 'package:conceal_me/features/ip/presentation/pages/speed_test_page.dart';
import 'package:conceal_me/features/vpn/presentation/pages/vpn_history_page.dart';
import 'package:conceal_me/features/vpn/presentation/pages/vpn_home_page.dart';
import 'package:conceal_me/features/vpn/presentation/pages/vpn_locations_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/lock_pattern_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/set_lock_pattern_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/verify_email_otp_page.dart';
import '../../features/auth/presentation/pages/verify_reset_otp_page.dart';
import 'app_routes.dart';
import 'bottom_navigator_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.signIn,
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  routes: [
    ///  Public / Auth routes (NO bottom nav)
    GoRoute(path: AppRoutes.signUp, builder: (_, __) => const SignUpPage()),
    GoRoute(path: AppRoutes.signIn, builder: (_, __) => const SignInPage()),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, __) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.verifyEmailOtp,
      builder: (_, __) => const VerifyEmailOtpPage(),
    ),
    GoRoute(
      path: AppRoutes.verifyResetOtp,
      builder: (_, __) => const VerifyResetOtpPage(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (_, __) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.setLockPattern,
      builder: (_, __) => SetLockPatternPage(),
    ),
    GoRoute(path: AppRoutes.lockPattern, builder: (_, __) => LockPatternPage()),

    ///  Shell route for all authenticated pages WITH bottom nav
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.vpnHome,
              builder: (_, __) => VpnHomePage(),
              routes: [
                GoRoute(
                  path: AppRoutes.vpnLocation,
                  builder: (_, __) => VpnLocationsPage(),
                ),
                GoRoute(
                  path: AppRoutes.vpnHistory,
                  builder: (_, __) => VpnHistoryPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.ipNetworkTest,
              builder: (_, __) => IpNetworkTestPage(),
              routes: [
                GoRoute(
                  path: AppRoutes.globalPosition,
                  builder: (_, __) => GlobePositionPage(),
                ),
                GoRoute(
                  path: AppRoutes.speedTest,
                  builder: (_, __) => SpeedTestScreen(),
                  routes: [],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.vpnHistory,
              builder: (_, __) => VpnHistoryPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
