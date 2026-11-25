import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/home/home_cubit.dart';
import '../../../logic/sync/sync_cubit.dart';
import '../../../models/dashboard_data.dart';
import '../../../models/enums.dart';
import '../../../models/reminder_item.dart';
import '../../../models/subject.dart';
import '../../../models/task.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/assignment_repository.dart';
import '../../../repositories/classroom_repository.dart';
import '../../../repositories/event_repository.dart';
import '../../../repositories/subject_repository.dart';
import '../../../repositories/task_repository.dart';
import '../../../repositories/timetable_repository.dart';
import '../../../services/academic_clock.dart';
import '../../../services/app_dependencies.dart';
import '../../widgets/common.dart';
import '../../widgets/pickers.dart';

/// Student/Teacher dashboard home (dashboard redesign).
///
/// The screen reads the authenticated profile for the role-aware layout and
/// renders every card from the existing [HomeCubit] state. Refresh, loading
/// and error behaviour are unchanged.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        subjects: context.read<SubjectRepository>(),
        tasks: context.read<TaskRepository>(),
        timetable: context.read<TimetableRepository>(),
        events: context.read<EventRepository>(),
        classrooms: context.read<ClassroomRepository>(),
        assignments: context.read<AssignmentRepository>(),
        changes: context.read<AppDependencies>().dataChanges,
      )..load(context.read<AuthBloc>().state.profile!),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthBloc>().state.profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final now = AcademicClock.nowIn(profile.academicTimezone);
        final greeting = _greeting(now.hour);

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, AppColors.background, Color(0xFFEFF7FF)],
              stops: [0, 0.35, 1],
            ),
          ),
          child: RefreshIndicator(
            color: AppColors.primaryBlue,
            onRefresh: () => context.read<HomeCubit>().load(profile),
            child: AppPage(
              maxWidth: 1080,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _GreetingHeader(
                    profile: profile,
                    greeting: greeting,
                    now: now,
                    state: state,
                  ),
                  const _LocalModeStrip(),
                  if (state.error != null) ...[
                    const SizedBox(height: 12),
                    const ErrorBanner(
                      message:
                          'The dashboard could not be refreshed. Pull down '
                          'to try again.',
                    ),
                  ],
                  if (state.loading) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: const LinearProgressIndicator(
                        minHeight: 3,
                        color: AppColors.primaryBlue,
                        backgroundColor: AppColors.skySoft,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const _ShortcutRow(),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final schedule = _TodayScheduleCard(
                        state: state,
                        profile: profile,
                      );
                      final deadlines = _DeadlinesCard(state: state);
                      final tasks = _MyTasksCard(
                        state: state,
                        profile: profile,
                      );

                      if (constraints.maxWidth < 760) {
                        return Column(
                          children: [
                            schedule,
                            const SizedBox(height: 16),
                            deadlines,
                            const SizedBox(height: 16),
                            tasks,
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 6, child: schedule),
                              const SizedBox(width: 16),
                              Expanded(flex: 5, child: deadlines),
                            ],
                          ),
                          const SizedBox(height: 16),
                          tasks,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  const _DashboardWaves(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _greeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

/// Light dashboard header: white-to-pale-blue surface, brand mark, reminder
/// bell, generic profile avatar, the role illustration once on the left and
/// the campus photo blended into the right edge.
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({
    required this.profile,
    required this.greeting,
    required this.now,
    required this.state,
  });

  final UserProfile profile;
  final String greeting;
  final DateTime now;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final attentionCount = state.reminders
        .where(
          (item) => !item.completed && item.bucket != ReminderBucket.upcoming,
        )
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 360;
        final large = width >= 640;
        final illustrationSize = large
            ? 104.0
            : compact
            ? 68.0
            : 84.0;
        final campusWidth = (width * 0.46).clamp(120.0, 300.0);
        final radius = large ? 24.0 : 20.0;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.border),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF1F8FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: campusWidth,
                  child: _HeaderCampus(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 14 : 18,
                    12,
                    compact ? 14 : 18,
                    compact ? 14 : 18,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _BrandMark(compact: compact),
                          const Spacer(),
                          _HeaderBellButton(
                            badgeCount: attentionCount,
                            compact: compact,
                          ),
                          SizedBox(width: compact ? 8 : 10),
                          _HeaderAvatar(size: compact ? 36 : 40),
                        ],
                      ),
                      SizedBox(height: compact ? 12 : 16),
                      Row(
                        children: [
                          _RoleIllustration(
                            image: AppImages.forRole(profile.role),
                            size: illustrationSize,
                          ),
                          SizedBox(width: compact ? 10 : 14),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$greeting,',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: large
                                        ? 26
                                        : compact
                                        ? 19
                                        : 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    height: 1.12,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: large ? 17 : 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    _RoleChip(label: profile.role.label),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        DateFormat('EEEE, MMMM d').format(now),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: compact ? 10.5 : 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Campus photo blended into the right side of the light header. The shader
/// fades the photo out towards the greeting text so nothing overlaps.
class _HeaderCampus extends StatelessWidget {
  const _HeaderCampus();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0x00FFFFFF), Color(0xB3FFFFFF), Color(0xFFFFFFFF)],
          stops: [0, 0.4, 1],
        ).createShader(bounds),
        child: Opacity(
          opacity: 0.55,
          child: Image.asset(
            AppImages.campus,
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 32 : 36,
          height: compact ? 32 : 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.skySoft, Colors.white],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.school_rounded,
            size: compact ? 18 : 20,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'MyCampus',
          maxLines: 1,
          style: TextStyle(
            fontSize: compact ? 15 : 16.5,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _HeaderBellButton extends StatelessWidget {
  const _HeaderBellButton({required this.badgeCount, required this.compact});

  final int badgeCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 40.0;

    return Tooltip(
      message: 'Reminder Center',
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => context.push('/app/reminders'),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: compact ? 18 : 20,
                color: AppColors.primaryBlue,
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.deadlineRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic profile avatar. The Student/Teacher illustration is intentionally
/// not used here so the role photo appears only once, in the greeting.
class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Profile',
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => context.go('/app/profile'),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.skySoft, Colors.white],
            ),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Icon(
            Icons.person_rounded,
            size: size * 0.55,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

/// Student/teacher photo beside the greeting (UI 05).
class _RoleIllustration extends StatelessWidget {
  const _RoleIllustration({required this.image, required this.size});

  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.30;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.skySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}

class _LocalModeStrip extends StatelessWidget {
  const _LocalModeStrip();

  @override
  Widget build(BuildContext context) {
    final configured = context.watch<SyncCubit>().state.configured;
    if (configured) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 17,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Available offline · saved on this device',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SyncBadge(status: SyncStatus.pending),
          ],
        ),
      ),
    );
  }
}

/// Home quick actions: Schedule, Subjects, Tasks and Classroom.
///
/// The four cards share a single row on standard phone widths and fall back
/// to a two-column grid only on exceptionally narrow layouts.
class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow();

  List<Widget> _cards(BuildContext context, double cardWidth) {
    return [
      _ShortcutCard(
        width: cardWidth,
        icon: Icons.calendar_today_outlined,
        label: 'Schedule',
        onTap: () => context.go('/app/calendar'),
      ),
      _ShortcutCard(
        width: cardWidth,
        icon: Icons.menu_book_outlined,
        label: 'Subjects',
        onTap: () => context.go('/app/subjects'),
      ),
      _ShortcutCard(
        width: cardWidth,
        icon: Icons.task_alt_outlined,
        label: 'Tasks',
        onTap: () => context.go('/app/tasks'),
      ),
      _ShortcutCard(
        width: cardWidth,
        icon: Icons.groups_outlined,
        label: 'Classroom',
        onTap: () => context.push('/app/classrooms'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const spacing = 8.0;
        // Four cards share one row on every standard phone width. The
        // two-column fallback only kicks in for very narrow split-screen
        // panes where 4-up would squeeze the labels.
        final singleRow = width >= 240;

        // The card is handed its width instead of measuring itself, because the
        // row below is wrapped in [IntrinsicHeight] and a nested
        // [LayoutBuilder] cannot answer intrinsic queries.
        final cardWidth = singleRow
            ? (width - spacing * 3) / 4
            : (width - spacing) / 2;
        final cards = _cards(context, cardWidth);

        if (singleRow) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < cards.length; index++) ...[
                  if (index > 0) const SizedBox(width: spacing),
                  Expanded(child: cards[index]),
                ],
              ],
            ),
          );
        }

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in cards) SizedBox(width: cardWidth, child: card),
          ],
        );
      },
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// Width the parent row allocates to this card, used to scale the icon and
  /// label so four cards fit side by side without overflowing.
  final double width;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tight = width < 76;
    final iconBox = tight ? 34.0 : 38.0;
    final fontSize = tight ? 10.5 : 11.5;

    return AppCard(
      radius: 18,
      shadow: true,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: iconBox,
            height: iconBox,
            decoration: BoxDecoration(
              color: AppColors.skySoft,
              borderRadius: BorderRadius.circular(iconBox * 0.34),
            ),
            child: Icon(
              icon,
              size: iconBox * 0.53,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 26,
            child: Center(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small icon + heading + "View All" row shared by the dashboard sections.
class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onAction,
    this.green = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onAction;
  final bool green;

  @override
  Widget build(BuildContext context) {
    final accent = green ? AppColors.greenAccent : AppColors.primaryBlue;
    final background = green ? AppColors.greenSoft : AppColors.skySoft;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: accent),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
            visualDensity: VisualDensity.compact,
            foregroundColor: AppColors.primaryBlue,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: onAction,
          child: const Text('View All'),
        ),
      ],
    );
  }
}

/// Today's Schedule (student) / Today's Classes (teacher) with class times,
/// subject names and classroom locations from the timetable.
class _TodayScheduleCard extends StatelessWidget {
  const _TodayScheduleCard({required this.state, required this.profile});

  final HomeState state;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final isTeacher = profile.role == UserRole.teacher;
    final items = state.data.todaySchedule;
    final now = AcademicClock.nowIn(profile.academicTimezone);
    final nowMinutes = now.hour * 60 + now.minute;

    return AppCard(
      radius: 20,
      shadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.calendar_month_outlined,
            title: isTeacher ? "Today's Classes" : "Today's Schedule",
            subtitle: isTeacher
                ? 'Your teaching timetable for today'
                : 'Timetable classes for today',
            onAction: () => context.go('/app/calendar'),
          ),
          const SizedBox(height: 6),
          if (items.isEmpty)
            const EmptyState(
              compact: true,
              icon: Icons.free_breakfast_outlined,
              title: 'No classes today',
              message:
                  'Add timetable entries in Calendar to see your day here.',
            )
          else
            for (final item in items) ...[
              _ClassTile(
                item: item,
                profile: profile,
                ongoing:
                    item.entry.startMinutes <= nowMinutes &&
                    nowMinutes < item.entry.endMinutes,
              ),
              if (item != items.last)
                const Divider(height: 20, color: AppColors.border),
            ],
        ],
      ),
    );
  }
}

class _ClassTile extends StatelessWidget {
  const _ClassTile({
    required this.item,
    required this.profile,
    required this.ongoing,
  });

  final TodayScheduleItem item;
  final UserProfile profile;
  final bool ongoing;

  @override
  Widget build(BuildContext context) {
    final entry = item.entry;
    final subject = item.subject;
    final room = entry.room ?? subject?.room;
    final timeText = AcademicClock.formatMinutes(
      entry.startMinutes,
      profile.timeFormat,
    );
    final timePieces = timeText.split(' ');
    final clock = timePieces.first;
    final meridiem = timePieces.length > 1 ? timePieces.last : null;
    final range = AcademicClock.formatMinutesRange(
      entry.startMinutes,
      entry.endMinutes,
      profile.timeFormat,
    );
    final chipColor = ongoing ? AppColors.greenAccent : AppColors.primaryBlue;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.go('/app/calendar'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              width: 54,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: ongoing ? AppColors.greenSoft : AppColors.skySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      clock,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: chipColor,
                      ),
                    ),
                  ),
                  if (meridiem != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      meridiem,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: chipColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (subject != null) ...[
                        SubjectDot(colorValue: subject.colorValue),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          subject?.name ?? 'Class',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      if (ongoing)
                        const StatusChip(
                          label: 'Now',
                          color: AppColors.greenAccent,
                          background: AppColors.greenSoft,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          room == null
                              ? 'Room not set · $range'
                              : '$room · $range',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// My Tasks with real checkboxes and deadline indicators.
class _MyTasksCard extends StatelessWidget {
  const _MyTasksCard({required this.state, required this.profile});

  final HomeState state;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final openTasks = state.data.pendingTasks;
    final visibleTasks = openTasks.take(5).toList();
    final subjectsById = {
      for (final subject in state.data.subjects) subject.id: subject,
    };

    return AppCard(
      radius: 20,
      shadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.checklist_rounded,
            title: 'My Tasks',
            subtitle: openTasks.isEmpty
                ? 'Your open planner tasks'
                : '${openTasks.length} open '
                      'task${openTasks.length == 1 ? '' : 's'}',
            green: true,
            onAction: () => context.go('/app/tasks'),
          ),
          const SizedBox(height: 6),
          if (visibleTasks.isEmpty)
            const EmptyState(
              compact: true,
              icon: Icons.task_alt_outlined,
              title: 'No open tasks',
              message: 'Tasks you capture in the Tasks tab appear here.',
            )
          else
            for (final task in visibleTasks) ...[
              _TaskTile(
                task: task,
                subject: subjectsById[task.subjectId],
                profile: profile,
                onToggle: () => context.read<HomeCubit>().toggleTask(task),
              ),
              if (task != visibleTasks.last)
                const Divider(height: 18, color: AppColors.border),
            ],
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.subject,
    required this.profile,
    required this.onToggle,
  });

  final Task task;
  final Subject? subject;
  final UserProfile profile;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.go('/app/tasks'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                value: false,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.greenAccent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                side: const BorderSide(
                  color: AppColors.borderStrong,
                  width: 1.6,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subject?.name ?? task.priority.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _TaskDeadlineBadge(task: task, profile: profile),
          ],
        ),
      ),
    );
  }
}

/// Deadline indicator: light red for urgent/overdue, light blue for upcoming.
class _TaskDeadlineBadge extends StatelessWidget {
  const _TaskDeadlineBadge({required this.task, required this.profile});

  final Task task;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final date = task.dueDate;
    if (date == null || date.isEmpty) {
      return _badge('No date', AppColors.textSecondary, AppColors.background);
    }

    final instant = AcademicClock.dueInstant(
      date: date,
      time: task.hasExplicitTime ? task.dueTime : null,
      timezoneName: profile.academicTimezone,
    );
    if (instant == null) {
      return _badge('No date', AppColors.textSecondary, AppColors.background);
    }

    final urgent = instant.isBefore(
      DateTime.now().add(const Duration(hours: 24)),
    );
    return _badge(
      dueLabel(instant),
      urgent ? AppColors.deadlineRed : AppColors.primaryBlue,
      urgent ? AppColors.deadlineSoft : AppColors.skySoft,
    );
  }

  Widget _badge(String label, Color color, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// Upcoming deadlines list (tasks, events and assignments).
class _DeadlinesCard extends StatelessWidget {
  const _DeadlinesCard({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final items = state.data.deadlines;

    return AppCard(
      radius: 20,
      shadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.event_busy_outlined,
            title: 'Upcoming Deadlines',
            subtitle: 'Tasks, events and assignments',
            onAction: () => context.push('/app/reminders'),
          ),
          const SizedBox(height: 6),
          if (items.isEmpty)
            const EmptyState(
              compact: true,
              icon: Icons.done_all_rounded,
              title: 'Nothing due soon',
              message: 'New deadlines will appear here.',
            )
          else
            for (final item in items) ...[
              _DeadlineTile(item: item),
              if (item != items.last)
                const Divider(height: 16, color: AppColors.border),
            ],
        ],
      ),
    );
  }
}

class _DeadlineTile extends StatelessWidget {
  const _DeadlineTile({required this.item});

  final ReminderItem item;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (item.source) {
      'task' => (Icons.task_alt_rounded, AppColors.primaryBlue),
      'event' => (Icons.event_rounded, AppColors.accent),
      'assignment' => (Icons.assignment_outlined, AppColors.warning),
      _ => (Icons.circle_outlined, AppColors.textSecondary),
    };

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (item.source == 'task') {
          context.go('/app/tasks');
        } else {
          context.go('/app/calendar');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              dueLabel(item.dueAt),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: item.isOverdue
                    ? AppColors.deadlineRed
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subtle pale-blue waves closing the dashboard, matching the reference.
class _DashboardWaves extends StatelessWidget {
  const _DashboardWaves();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 64,
      width: double.infinity,
      child: IgnorePointer(
        child: CustomPaint(painter: _DashboardWavesPainter()),
      ),
    );
  }
}

class _DashboardWavesPainter extends CustomPainter {
  const _DashboardWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final width = size.width;
    final height = size.height;

    void fill(Path path, Color color) {
      canvas.drawPath(path, Paint()..color = color);
    }

    final back = Path()
      ..moveTo(0, height * 0.45)
      ..cubicTo(
        width * 0.22,
        height * 0.18,
        width * 0.48,
        height * 0.72,
        width,
        height * 0.38,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    fill(back, const Color(0x1F9BD0FA));

    final middle = Path()
      ..moveTo(0, height * 0.68)
      ..cubicTo(
        width * 0.26,
        height * 0.46,
        width * 0.58,
        height * 0.92,
        width,
        height * 0.58,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    fill(middle, const Color(0x2E8FC8F8));

    final front = Path()
      ..moveTo(0, height * 0.86)
      ..cubicTo(
        width * 0.30,
        height * 0.70,
        width * 0.66,
        height,
        width,
        height * 0.80,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    fill(front, const Color(0x3DC4E3FC));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
