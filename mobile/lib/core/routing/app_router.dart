import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/invitations/screens/create_event_screen.dart';
import '../../features/invitations/screens/invitations_screen.dart';
import '../../features/invitations/screens/select_guests_screen.dart';
import '../../features/navigation/screens/main_screen.dart';
import '../../features/notices/screens/notices_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = ValueNotifier<bool>(true);
  
  ref.listen<AuthStateData>(authProvider, (previous, next) {
    if (previous?.status != next.status) {
      listenable.value = !listenable.value;
    }
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/otp';
      
      if (authState.status == AuthState.authenticated) {
        if (isLoggingIn || state.matchedLocation == '/onboarding') {
          return '/home';
        }
      } else if (authState.status == AuthState.needsOnboarding) {
        if (state.matchedLocation != '/onboarding') {
          return '/onboarding';
        }
      } else if (authState.status == AuthState.initial || authState.status == AuthState.error) {
        if (!isLoggingIn) {
          return '/login';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/create-event',
        builder: (context, state) => const CreateEventScreen(),
      ),
      GoRoute(
        path: '/select-guests',
        builder: (context, state) => const SelectGuestsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/invitations',
                builder: (context, state) => const InvitationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notices',
                builder: (context, state) => const NoticesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
