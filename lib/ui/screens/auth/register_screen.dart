import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../models/enums.dart';
import '../../widgets/common.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.roleCode});

  final String roleCode;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _submitted = false;

  UserRole get _role =>
      widget.roleCode == 'teacher' ? UserRole.teacher : UserRole.student;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        fullName: _name.text,
        email: _email.text,
        password: _password.text,
        role: _role,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = _role == UserRole.teacher;

    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.error != current.error ||
            previous.notice != current.notice,
        listener: (context, state) {
          if (state.error != null) {
            showAppSnack(context, state.error!);
            context.read<AuthBloc>().add(const AuthErrorDismissed());
          } else if (state.notice != null) {
            showAppSnack(context, state.notice!);
            context.read<AuthBloc>().add(const AuthNoticeDismissed());
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: 'Back',
                        ),
                        const Spacer(),
                        StatusChip(
                          label: '${_role.label} account',
                          icon: isTeacher
                              ? Icons.co_present_outlined
                              : Icons.school_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isTeacher
                          ? 'Create Teacher Account'
                          : 'Create Student Account',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isTeacher
                          ? 'Teachers manage classrooms and publish '
                                'assignments. Student progress stays private.'
                          : 'Fill in your details to get started.',
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(27),
                          child: Image.asset(
                            isTeacher ? AppImages.teacher : AppImages.student,
                            width: 104,
                            height: 104,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _submitted
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Full name',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().length < 2)
                                  ? 'Enter your full name'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) return 'Enter your email';
                                final pattern = RegExp(
                                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                );
                                if (!pattern.hasMatch(email)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _password,
                              obscureText: _hidePassword,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                helperText: 'At least 8 characters',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _hidePassword = !_hidePassword,
                                  ),
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.length < 8)
                                  ? 'Use at least 8 characters'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _confirm,
                              obscureText: _hideConfirm,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Confirm password',
                                prefixIcon: const Icon(
                                  Icons.lock_reset_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _hideConfirm = !_hideConfirm,
                                  ),
                                  icon: Icon(
                                    _hideConfirm
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) => value != _password.text
                                  ? 'Passwords do not match'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<AuthBloc, AuthState>(
                              buildWhen: (previous, current) =>
                                  previous.busy != current.busy,
                              builder: (context, state) {
                                return FilledButton(
                                  onPressed: state.busy ? null : _submit,
                                  child: state.busy
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Create account'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const ErrorBanner(
                      tone: BannerTone.info,
                      message:
                          'Local-only mode: no verification email is sent and '
                          'no cloud account is created. Your password hash and '
                          'planner data stay on this device.',
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already registered?',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/login'),
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
