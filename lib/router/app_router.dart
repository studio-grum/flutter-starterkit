import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../features/auth/presentation/auth_provider.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/media/presentation/audio_player_screen.dart';
import '../features/media/presentation/video_player_screen.dart';
import '../features/paywall/presentation/paywall_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppConstants.routeHome,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull?.session != null;
      final isOnAuth = state.matchedLocation == AppConstants.routeLogin ||
          state.matchedLocation == AppConstants.routeRegister;

      if (!isLoggedIn && !isOnAuth) return AppConstants.routeLogin;
      if (isLoggedIn && isOnAuth) return AppConstants.routeHome;
      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.routeHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.routePaywall,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: AppConstants.routeVideoPlayer,
        builder: (context, state) {
          final url = state.extra as String? ?? '';
          return VideoPlayerScreen(url: url);
        },
      ),
      GoRoute(
        path: AppConstants.routeAudioPlayer,
        builder: (context, state) {
          final url = state.extra as String? ?? '';
          return AudioPlayerScreen(url: url);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
});
