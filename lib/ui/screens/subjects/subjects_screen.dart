import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/subjects/subjects_cubit.dart';
import '../../../models/subject.dart';
import '../../../repositories/subject_repository.dart';
import '../../widgets/common.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountId = context.read<AuthBloc>().state.profile?.id;

    return BlocProvider(
      create: (_) => SubjectsCubit(
        repository: context.read<SubjectRepository>(),
        accountId: accountId ?? '',
      )..load(),
      child: const _SubjectsView(),
    );
  }
}

class _SubjectsView extends StatefulWidget {
  const _SubjectsView();

  @override
  State<_SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<_SubjectsView> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openForm(Subject? existing) async {
    final cubit = context.read<SubjectsCubit>();

    final draft = await showDialog<_SubjectDraft>(
      context: context,
      builder: (_) => _SubjectFormDialog(existing: existing),
    );

    if (draft == null || !mounted) return;

    final bool ok;

    if (existing == null) {
      ok = await cubit.create(
        name: draft.name,
        code: draft.code,
        colorValue: draft.colorValue,
        teacherName: draft.teacherName,
        room: draft.room,
      );
    } else {
      ok = await cubit.update(
        Subject(
          id: existing.id,
          accountId: existing.accountId,
          name: draft.name,
          code: draft.code,
          colorValue: draft.colorValue,
          teacherName: draft.teacherName,
          room: draft.room,
          revision: existing.revision,
          syncStatus: existing.syncStatus,
          deletedAt: existing.deletedAt,
          updatedAt: existing.updatedAt,
        ),
      );
    }

    if (!ok && mounted) {
      showAppSnack(context, cubit.state.error ?? 'Unable to save subject.');
    }
  }

  Future<void> _confirmDelete(Subject subject) async {
    final cubit = context.read<SubjectsCubit>();
    final impact = await cubit.impact(subject.id);

    final details = StringBuffer(
      'Deleting "${subject.name}" cannot be undone.',
    );

    if (impact != null) {
      if (impact.tasksToDetach > 0) {
        details.write(
          '\n\n${impact.tasksToDetach} task'
          '${impact.tasksToDetach == 1 ? '' : 's'} will move to General '
          'Tasks.',
        );
      }

      if (impact.timetableEntriesToRemove > 0) {
        details.write(
          '\n\n${impact.timetableEntriesToRemove} timetable entr'
          '${impact.timetableEntriesToRemove == 1 ? 'y' : 'ies'} will be '
          'removed.',
        );
      }
    }

    if (!mounted) return;

    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete subject?',
      message: details.toString(),
      confirmLabel: 'Delete subject',
      destructive: true,
    );

    if (!confirmed || !mounted) return;

    final ok = await cubit.delete(subject.id);

    if (!ok && mounted) {
      showAppSnack(context, cubit.state.error ?? 'Unable to delete subject.');
    } else if (mounted) {
      showAppSnack(context, '${subject.name} deleted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SubjectsCubit>().state;
    final query = _search.text.trim().toLowerCase();

    final subjects = query.isEmpty
        ? state.subjects
        : state.subjects
              .where(
                (subject) =>
                    subject.name.toLowerCase().contains(query) ||
                    subject.code.toLowerCase().contains(query) ||
                    (subject.teacherName ?? '').toLowerCase().contains(query),
              )
              .toList();

    const blue = Color(0xFF0868F7);

    return AppPage(
      maxWidth: 1080,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subjects',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF081C69),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      state.subjects.isEmpty
                          ? 'Build your semester one subject at a time'
                          : '${state.subjects.length} subject${state.subjects.length == 1 ? '' : 's'} this semester',
                      style: const TextStyle(
                        color: Color(0xFF64718E),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              if (state.error != null) ...[
                ErrorBanner(
                  message: state.error!,
                  onDismiss: () => context.read<SubjectsCubit>().load(),
                ),
                const SizedBox(height: 12),
              ],

              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search subjects...',
                  hintStyle: const TextStyle(color: Color(0xFF72809B)),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF53627F),
                  ),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _search.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: const Color(0xFFEAF1FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: blue, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (state.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (subjects.isEmpty)
                AppCard(
                  child: EmptyState(
                    icon: Icons.menu_book_outlined,
                    title: state.subjects.isEmpty
                        ? 'No subjects yet'
                        : 'No matching subjects',
                    message: state.subjects.isEmpty
                        ? 'Add your courses to connect tasks, classes and deadlines.'
                        : 'Try a different keyword or clear the search.',
                    action: state.subjects.isEmpty
                        ? FilledButton.icon(
                            onPressed: () => _openForm(null),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add your first subject'),
                          )
                        : null,
                  ),
                )
              else
                Column(
                  children: [
                    for (final subject in subjects) ...[
                      _SubjectCard(
                        subject: subject,
                        onEdit: () => _openForm(subject),
                        onDelete: () => _confirmDelete(subject),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),

              const SizedBox(height: 16),
              const _PrivacyNote(),
            ],
          ),

          Positioned(
            right: 12,
            bottom: 18,
            child: FloatingActionButton(
              heroTag: 'subjects_add',
              onPressed: () => _openForm(null),
              backgroundColor: blue,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add_rounded, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.subject,
    required this.onEdit,
    required this.onDelete,
  });

  final Subject subject;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = Color(subject.colorValue);
    final pastel = Color.lerp(color, Colors.white, 0.91)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 6, 16),
      decoration: BoxDecoration(
        color: pastel,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF091A59),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subject.code,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF263A68),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 12,
                  runSpacing: 5,
                  children: [
                    if (subject.teacherName != null &&
                        subject.teacherName!.isNotEmpty)
                      _Meta(
                        icon: Icons.person_outline_rounded,
                        label: subject.teacherName!,
                      ),

                    if (subject.room != null && subject.room!.isNotEmpty)
                      _Meta(
                        icon: Icons.meeting_room_outlined,
                        label: subject.room!,
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                SyncBadge(status: subject.syncStatus),
              ],
            ),
          ),

          PopupMenuButton<String>(
            tooltip: 'Subject actions',
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF25345C)),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.edit_outlined, size: 18),
                  title: Text('Edit subject'),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: AppColors.danger,
                  ),
                  title: Text(
                    'Delete subject',
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

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
              'Subjects are private to your account. Removing a subject '
              'moves its tasks to General Tasks and clears its timetable '
              'slots.',
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

class _SubjectDraft {
  const _SubjectDraft({
    required this.name,
    required this.code,
    required this.colorValue,
    this.teacherName,
    this.room,
  });
  final String name;
  final String code;
  final int colorValue;
  final String? teacherName;
  final String? room;
}

class _SubjectFormDialog extends StatefulWidget {
  const _SubjectFormDialog({this.existing});

  final Subject? existing;

  @override
  State<_SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<_SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _code;
  late final TextEditingController _teacher;
  late final TextEditingController _room;

  late int _color;

  @override
  void initState() {
    super.initState();

    final existing = widget.existing;

    _name = TextEditingController(text: existing?.name ?? '');
    _code = TextEditingController(text: existing?.code ?? '');
    _teacher = TextEditingController(text: existing?.teacherName ?? '');
    _room = TextEditingController(text: existing?.room ?? '');

    _color = existing?.colorValue ?? AppColors.subjectPalette.first.toARGB32();
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _teacher.dispose();
    _room.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      _SubjectDraft(
        name: _name.text.trim(),
        code: _code.text.trim(),
        colorValue: _color,
        teacherName: _emptyToNull(_teacher.text),
        room: _emptyToNull(_room.text),
      ),
    );
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0868F7);

    InputDecoration fieldDecoration(String hint, IconData icon) =>
        InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF77849C), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF415276)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFDCE5F5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFDCE5F5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: blue, width: 1.6),
          ),
        );

    Widget fieldLabel(String value) => Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF091A59),
        ),
      ),
    );

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 740),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.existing == null ? 'Add Subject' : 'Edit Subject',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF081C69),
                  ),
                ),

                const SizedBox(height: 26),

                fieldLabel('Subject Name *'),

                TextFormField(
                  controller: _name,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: fieldDecoration(
                    'Enter subject name',
                    Icons.menu_book_outlined,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a subject name'
                      : null,
                ),

                const SizedBox(height: 20),

                fieldLabel('Subject Code *'),

                TextFormField(
                  controller: _code,
                  textCapitalization: TextCapitalization.characters,
                  decoration: fieldDecoration(
                    'Enter subject code',
                    Icons.sell_outlined,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a subject code'
                      : null,
                ),

                const SizedBox(height: 20),

                fieldLabel('Teacher'),

                TextFormField(
                  controller: _teacher,
                  textCapitalization: TextCapitalization.words,
                  decoration: fieldDecoration(
                    'Enter teacher name (optional)',
                    Icons.person_outline_rounded,
                  ),
                ),

                const SizedBox(height: 20),

                fieldLabel('Room'),

                TextFormField(
                  controller: _room,
                  decoration: fieldDecoration(
                    'Enter room (optional)',
                    Icons.meeting_room_outlined,
                  ),
                ),

                const SizedBox(height: 24),

                fieldLabel('Subject Color'),

                const SizedBox(height: 4),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final color in AppColors.subjectPalette)
                      InkWell(
                        onTap: () => setState(() => _color = color.toARGB32()),
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _color == color.toARGB32()
                                  ? const Color(0xFF25345C)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: _color == color.toARGB32()
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 30),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      widget.existing == null ? 'Save' : 'Save Changes',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 48,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF1FC),
                      foregroundColor: const Color(0xFF091A59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
