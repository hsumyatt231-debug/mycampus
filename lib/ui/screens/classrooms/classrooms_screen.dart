import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/classrooms/classrooms_cubit.dart';
import '../../../models/classroom.dart';
import '../../../models/enums.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/assignment_repository.dart';
import '../../../repositories/classroom_repository.dart';
import '../../widgets/common.dart';

class ClassroomsScreen extends StatelessWidget {
  const ClassroomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<AuthBloc>().state.profile;
    if (profile == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return BlocProvider(
      create: (_) => ClassroomsCubit(
        repository: context.read<ClassroomRepository>(),
        assignments: context.read<AssignmentRepository>(),
        accountId: profile.id,
      )..load(),
      child: const _ClassroomsView(),
    );
  }
}

class _ClassroomsView extends StatelessWidget {
  const _ClassroomsView();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthBloc>().state.profile;
    if (profile == null) return const SizedBox.shrink();

    final state = context.watch<ClassroomsCubit>().state;
    final cubit = context.read<ClassroomsCubit>();
    final isTeacher = profile.role == UserRole.teacher;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Classrooms'),
        actions: [
          IconButton(
            tooltip: 'Refresh from cloud',
            onPressed: state.busy ? null : cubit.refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: AppPage(
          maxWidth: 940,
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: cubit.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _Header(
                  isTeacher: isTeacher,
                  onCreate: isTeacher ? () => _create(context) : null,
                  onJoin: isTeacher ? null : () => _join(context),
                ),
                if (!state.configured) ...[
                  const ErrorBanner(
                    tone: BannerTone.info,
                    message:
                        'Classrooms need a connection for live updates. '
                        'Classrooms you have already opened remain available '
                        'below.',
                  ),
                  const SizedBox(height: 12),
                ],
                if (state.error != null) ...[
                  ErrorBanner(
                    message: state.error!,
                    onDismiss: cubit.dismissMessage,
                  ),
                  const SizedBox(height: 12),
                ],
                if (state.notice != null) ...[
                  ErrorBanner(
                    tone: BannerTone.info,
                    message: state.notice!,
                    onDismiss: cubit.dismissMessage,
                  ),
                  const SizedBox(height: 12),
                ],
                if (state.busy) ...[
                  const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: 12),
                ],
                if (state.loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.classrooms.isEmpty)
                  AppCard(
                    child: EmptyState(
                      icon: Icons.groups_outlined,
                      title: isTeacher
                          ? 'No classrooms yet'
                          : 'You have not joined a classroom',
                      message: isTeacher
                          ? 'Create a classroom to share assignments with '
                                'your students.'
                          : 'Ask your teacher for a join code to join a '
                                'classroom.',
                      action: isTeacher
                          ? FilledButton.icon(
                              onPressed: () => _create(context),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Create classroom'),
                            )
                          : FilledButton.icon(
                              onPressed: () => _join(context),
                              icon: const Icon(Icons.login_rounded),
                              label: const Text('Join with a code'),
                            ),
                    ),
                  )
                else
                  Column(
                    children: [
                      for (final classroom in state.classrooms) ...[
                        _ClassroomCard(
                          classroom: classroom,
                          profile: profile,
                          onTap: () =>
                              context.push('/app/classrooms/${classroom.id}'),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                const SizedBox(height: 8),
                const _ClassroomPrivacyNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<ClassroomsCubit>();
    final draft = await showDialog<_ClassroomDraft>(
      context: context,
      builder: (_) => const _CreateClassroomDialog(),
    );
    if (draft == null || !context.mounted) return;

    final ok = await cubit.create(
      name: draft.name,
      subjectName: draft.subjectName,
      description: draft.description,
    );
    if (!context.mounted) return;
    if (ok) {
      showAppSnack(context, 'Classroom created.');
    } else {
      showAppSnack(context, cubit.state.error ?? 'Unable to create classroom.');
    }
  }

  Future<void> _join(BuildContext context) async {
    final cubit = context.read<ClassroomsCubit>();
    final code = await showDialog<String>(
      context: context,
      builder: (_) => const _JoinClassroomDialog(),
    );
    if (code == null || !context.mounted) return;

    final ok = await cubit.join(code);
    if (!context.mounted) return;
    if (ok) {
      showAppSnack(context, cubit.state.notice ?? 'Classroom joined.');
    } else {
      showAppSnack(context, cubit.state.error ?? 'Unable to join classroom.');
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.isTeacher,
    required this.onCreate,
    required this.onJoin,
  });

  final bool isTeacher;
  final VoidCallback? onCreate;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTeacher ? 'Your classrooms' : 'My classrooms',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isTeacher
                      ? 'Create a class, share its join code and publish '
                            'assignments.'
                      : 'Join with a code and keep track of published '
                            'assignments.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onCreate != null)
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create'),
            ),
          if (onJoin != null)
            FilledButton.icon(
              onPressed: onJoin,
              icon: const Icon(Icons.login_rounded, size: 18),
              label: const Text('Join'),
            ),
        ],
      ),
    );
  }
}

class _ClassroomCard extends StatelessWidget {
  const _ClassroomCard({
    required this.classroom,
    required this.profile,
    required this.onTap,
  });

  final Classroom classroom;
  final UserProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOwner = classroom.teacherId == profile.id;
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.infoSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        classroom.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    if (classroom.archived)
                      const StatusChip(
                        label: 'Archived',
                        color: AppColors.textSecondary,
                        background: Color(0xFFF1F5F9),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  classroom.subjectName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (classroom.description != null &&
                    classroom.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    classroom.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 7),
                Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusChip(
                      label: isOwner ? 'You teach' : 'Student',
                      icon: isOwner
                          ? Icons.co_present_rounded
                          : Icons.school_rounded,
                    ),
                    if (classroom.teacherName != null && !isOwner)
                      Text(
                        classroom.teacherName!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (isOwner && classroom.joinCode != null)
                      StatusChip(
                        label: classroom.joinCode!,
                        icon: Icons.key_rounded,
                        color: AppColors.warning,
                        background: const Color(0xFFFFF4E0),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _ClassroomDraft {
  const _ClassroomDraft({
    required this.name,
    required this.subjectName,
    this.description,
  });

  final String name;
  final String subjectName;
  final String? description;
}

class _CreateClassroomDialog extends StatefulWidget {
  const _CreateClassroomDialog();

  @override
  State<_CreateClassroomDialog> createState() => _CreateClassroomDialogState();
}

class _CreateClassroomDialogState extends State<_CreateClassroomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _subject = TextEditingController();
  final _description = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final description = _description.text.trim();
    Navigator.of(context).pop(
      _ClassroomDraft(
        name: _name.text.trim(),
        subjectName: _subject.text.trim(),
        description: description.isEmpty ? null : description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      title: const Text(
        'Create classroom',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      content: SizedBox(
        width: appDialogBodyWidth(context, max: 440),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Classroom name',
                    hintText: 'e.g. CS201 Section A',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter a classroom name'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subject,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Subject name',
                    hintText: 'e.g. Data Structures',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter the subject name'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _description,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A join code is generated for you. Classrooms use your '
                  'academic timezone.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Create classroom')),
      ],
    );
  }
}

class _JoinClassroomDialog extends StatefulWidget {
  const _JoinClassroomDialog();

  @override
  State<_JoinClassroomDialog> createState() => _JoinClassroomDialogState();
}

class _JoinClassroomDialogState extends State<_JoinClassroomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      title: const Text(
        'Join classroom',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      content: SizedBox(
        width: appDialogBodyWidth(context, max: 400),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter the join code from your teacher. Joining also loads '
                  'published assignments and your progress.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _code,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Join code',
                    prefixIcon: Icon(Icons.key_rounded),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter a join code'
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_code.text.trim());
            }
          },
          child: const Text('Join'),
        ),
      ],
    );
  }
}

class _ClassroomPrivacyNote extends StatelessWidget {
  const _ClassroomPrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: AppColors.textMuted,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Classroom data is cached per account after an authorized '
              'response. Teachers never see student task, event or assignment '
              'completion data.',
              style: TextStyle(
                fontSize: 11,
                height: 1.45,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
