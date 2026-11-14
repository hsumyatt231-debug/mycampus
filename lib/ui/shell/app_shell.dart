import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';

/// A navigation destination for one of the five shell branches.
class _ShellDestination {
  const _ShellDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.branch,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Branch index inside the stateful shell.
  final int branch;
}

/// Bottom navigation shared by the Student and Teacher dashboards.
///
/// Home, Subjects, Tasks, Calendar and Profile map to the five existing shell
/// branches, so every item opens a real screen and no placeholder route is
/// invented. Progress is not part of the bottom navigation.
const List<_ShellDestination> _destinations = [
  _ShellDestination(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    label: 'Home',
    branch: 0,
  ),
  _ShellDestination(
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book_rounded,
    label: 'Subjects',
    branch: 1,
  ),
  _ShellDestination(
    icon: Icons.task_alt_outlined,
    selectedIcon: Icons.task_alt_rounded,
    label: 'Tasks',
    branch: 2,
  ),
  _ShellDestination(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today_rounded,
    label: 'Calendar',
    branch: 3,
  ),
  _ShellDestination(
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
    label: 'Profile',
    branch: 4,
  ),
];

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(List<_ShellDestination> destinations, int index) {
    final destination = destinations[index];
    navigationShell.goBranch(
      destination.branch,
      // Re-tapping the active tab returns to its first location.
      initialLocation: destination.branch == navigationShell.currentIndex,
    );
  }

  int _selectedSlot(List<_ShellDestination> destinations) {
    final slot = destinations.indexWhere(
      (destination) => destination.branch == navigationShell.currentIndex,
    );
    // Every shell branch now has a visible destination; keep the fallback so
    // a pushed detail route still highlights Home.
    return slot < 0 ? 0 : slot;
  }

  @override
  Widget build(BuildContext context) {
    const destinations = _destinations;

    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;

        if (desktop) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: NavigationRail(
                      selectedIndex: _selectedSlot(destinations),
                      onDestinationSelected: (index) =>
                          _onDestinationSelected(destinations, index),
                      labelType: NavigationRailLabelType.all,
                      minWidth: 84,
                      indicatorColor: AppColors.skySoft,
                      selectedIconTheme: const IconThemeData(
                        color: AppColors.primaryBlue,
                      ),
                      unselectedIconTheme: const IconThemeData(
                        color: AppColors.navInactive,
                      ),
                      selectedLabelTextStyle: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      unselectedLabelTextStyle: const TextStyle(
                        color: AppColors.navInactive,
                        fontSize: 12,
                      ),
                      leading: const Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 18),
                        child: _RailLogo(),
                      ),
                      destinations: [
                        for (final destination in destinations)
                          NavigationRailDestination(
                            icon: Icon(destination.icon),
                            selectedIcon: Icon(destination.selectedIcon),
                            label: Text(destination.label),
                          ),
                      ],
                    ),
                  ),
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(bottom: false, child: navigationShell),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: AppColors.skySoft,
                iconTheme: WidgetStateProperty.resolveWith(
                  (states) => IconThemeData(
                    color: states.contains(WidgetState.selected)
                        ? AppColors.primaryBlue
                        : AppColors.navInactive,
                  ),
                ),
                labelTextStyle: WidgetStateProperty.resolveWith(
                  (states) => TextStyle(
                    fontSize: 11.5,
                    fontWeight: states.contains(WidgetState.selected)
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: states.contains(WidgetState.selected)
                        ? AppColors.primaryBlue
                        : AppColors.navInactive,
                  ),
                ),
              ),
              child: NavigationBar(
                height: 66,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                selectedIndex: _selectedSlot(destinations),
                onDestinationSelected: (index) =>
                    _onDestinationSelected(destinations, index),
                destinations: [
                  for (final destination in destinations)
                    NavigationDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                      label: destination.label,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RailLogo extends StatelessWidget {
  const _RailLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.skySoft,
        borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
      ),
      child: const Icon(
        Icons.school_rounded,
        color: AppColors.primaryBlue,
        size: 26,
      ),
    );
  }
}
