import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../logic/app_lock/app_lock_cubit.dart';
import '../logic/auth/auth_bloc.dart';
import '../services/app_dependencies.dart';
import 'router/app_router.dart';
import 'screens/lock/lock_screen.dart';
import 'theme/app_theme.dart';

class MyCampusApp extends StatefulWidget {
  const MyCampusApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<MyCampusApp> createState() => _MyCampusAppState();
}

class _MyCampusAppState extends State<MyCampusApp> with WidgetsBindingObserver {
  late final GoRouter _router;
  late final AppLockCubit _appLock;
  StreamSubscription<AuthState>? _authSubscription;

  AuthStatus _lastStatus = AuthStatus.unknown;
  bool _coldStartHandled = false;
  String? _lastAccountId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final deps = widget.dependencies;
    _appLock = deps.appLock;
    _router = buildAppRouter(authBloc: deps.authBloc);

    _authSubscription = deps.authBloc.stream.listen(_onAuthState);
    deps.authBloc.add(const AuthStarted());
  }

  void _onAuthState(AuthState state) {
    final wasUnknown = _lastStatus == AuthStatus.unknown;
    _lastStatus = state.status;

    if (state.status == AuthStatus.authenticated && state.profile != null) {
      final profile = state.profile!;

      if (_lastAccountId != profile.id) {
        _lastAccountId = profile.id;
        unawaited(widget.dependencies.syncCubit.bind(profile.id));
      }

      if (wasUnknown && !_coldStartHandled) {
        _coldStartHandled = true;
        if (widget.dependencies.resumedSession) {
          _appLock.onSessionRestored(profile);
        }
      }
    } else if (state.status == AuthStatus.unauthenticated) {
      _coldStartHandled = true;
      if (_lastAccountId != null) {
        _lastAccountId = null;
        unawaited(widget.dependencies.syncCubit.unbind());
      }
      _appLock.onSessionCleared();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _appLock.foreground();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _appLock.shield();
      case AppLifecycleState.paused:
        _appLock.background();
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = widget.dependencies;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDependencies>.value(value: deps),
        RepositoryProvider.value(value: deps.settings),
        RepositoryProvider.value(value: deps.subjects),
        RepositoryProvider.value(value: deps.tasks),
        RepositoryProvider.value(value: deps.timetable),
        RepositoryProvider.value(value: deps.events),
        RepositoryProvider.value(value: deps.assignments),
        RepositoryProvider.value(value: deps.classrooms),
        RepositoryProvider.value(value: deps.accounts),
        RepositoryProvider.value(value: deps.syncRepository),
        RepositoryProvider.value(value: deps.notifications),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: deps.authBloc),
          BlocProvider.value(value: deps.appLock),
          BlocProvider.value(value: deps.syncCubit),
        ],
        child: BlocBuilder<AppLockCubit, AppLockState>(
          builder: (context, _) {
            return MaterialApp.router(
              title: 'MyCampus',
              debugShowCheckedModeBanner: false,
              theme: buildAppTheme(),
              routerConfig: _router,
              builder: (context, child) {
                // Keep the outer Overlay (the lock UI contains tooltips that
                // need an Overlay ancestor) but subscribe to the lock cubit
                // *inside* the entry. `initialEntries` is only read once, so a
                // captured `lockState` would stay stale and never show the
                // lock screen.
                return Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder: (overlayContext) {
                        return BlocBuilder<AppLockCubit, AppLockState>(
                          builder: (context, lockState) {
                            return Stack(
                              children: [
                                if (child != null)
                                  Positioned.fill(child: child),

                                if (lockState.status == AppLockStatus.shielded)
                                  const Positioned.fill(
                                    child: _ShieldOverlay(),
                                  ),

                                if (lockState.status == AppLockStatus.locked)
                                  const Positioned.fill(child: LockScreen()),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ShieldOverlay extends StatelessWidget {
  const _ShieldOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.infoSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_rounded,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'MyCampus',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
