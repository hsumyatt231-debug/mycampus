import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../logic/auth/auth_bloc.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/classrooms/classroom_detail_screen.dart';
import '../screens/classrooms/classrooms_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/reminders/reminders_screen.dart';
import '../screens/subjects/subjects_screen.dart';
import '../screens/sync/sync_screen.dart';
import '../screens/tasks/tasks_screen.dart';
import '../shell/app_shell.dart';

/// Bridges a Bloc stream to [GoRouter]'s refresh listenable.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter buildAppRouter({required AuthBloc authBloc}) {
  final refresh = GoRouterRefreshStream(authBloc.stream);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = authBloc.state.status;
      final location = state.matchedLocation;
      final onSplash = location == '/';
      final onAuth =
          location == '/welcome' ||
          location == '/login' ||
          location == '/roles' ||
          location.startsWith('/register');

      if (status == AuthStatus.unknown) {
        return onSplash ? null : '/';
      }

      if (status == AuthStatus.unauthenticated) {
        return onAuth ? null : '/welcome';
      }

      // Authenticated.
      if (onSplash || onAuth) return '/app/home';
      if (!location.startsWith('/app')) return '/app/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/roles',
        name: 'roles',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/register/:role',
        name: 'register',
        builder: (context, state) =>
            RegisterScreen(roleCode: state.pathParameters['role'] ?? 'student'),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/subjects',
                name: 'subjects',
                builder: (context, state) => const SubjectsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/tasks',
                name: 'tasks',
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/calendar',
                name: 'calendar',
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/app/reminders',
        name: 'reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: '/app/sync',
        name: 'sync',
        builder: (context, state) => const SyncScreen(),
      ),
      GoRoute(
        path: '/app/classrooms',
        name: 'classrooms',
        builder: (context, state) => const ClassroomsScreen(),
      ),
      GoRoute(
        path: '/app/classrooms/:classroomId',
        name: 'classroom',
        builder: (context, state) => ClassroomDetailScreen(
          classroomId: state.pathParameters['classroomId']!,
        ),
      ),
    ],
  );

  // Keep the refresh notifier alive for the app's lifetime; GoRouter does not
  // own it. The router is created once per session.
  _retainedRefresh[router] = refresh;
  return router;
}

final Map<GoRouter, GoRouterRefreshStream> _retainedRefresh = {};

/// Releases the refresh notifier that [buildAppRouter] attached to [router].
/// Call this before disposing the router so its stream subscription is
/// cancelled instead of leaking for the process lifetime.
void disposeAppRouter(GoRouter router) {
  _retainedRefresh.remove(router)?.dispose();
}
