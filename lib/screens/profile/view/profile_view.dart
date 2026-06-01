import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ageController;
  String? _gender;
  String? _fitnessLevel;
  String? _primaryGoal;
  int? _availableDays;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserSessionBloc>().state.user;
    _ageController = TextEditingController(text: user.age?.toString() ?? '');
    _gender = user.gender;
    _fitnessLevel = user.fitnessLevel;
    _primaryGoal = user.primaryGoal;
    _availableDays = user.trainingDaysPerWeek;
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final ageText = _ageController.text.trim();
    context.read<UserSessionBloc>().add(
          UserSessionUpdateProfileEvent(
            age: ageText.isEmpty ? null : int.parse(ageText),
            gender: _gender,
            fitnessLevel: _fitnessLevel,
            primaryGoal: _primaryGoal,
            trainingDaysPerWeek: _availableDays,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only name + email come from the bloc; the editable fields are local state
    // seeded once in initState, so a bloc emit won't reset an in-progress edit.
    final user = context.watch<UserSessionBloc>().state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileHeader(name: user.name, email: user.email),
              const SizedBox(height: 24),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: _fieldDecoration('Age', Icons.cake_rounded),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return null;
                        final parsed = int.tryParse(value.trim());
                        if (parsed == null || parsed <= 0 || parsed > 120) {
                          return 'Enter a valid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _dropdown<String>(
                      label: 'Gender',
                      icon: Icons.wc_rounded,
                      value: _gender,
                      options: genderOptions,
                      labelOf: (o) => o,
                      onChanged: (v) => setState(() => _gender = v),
                    ),
                    const SizedBox(height: 16),
                    _dropdown<String>(
                      label: 'Fitness level',
                      icon: Icons.fitness_center_rounded,
                      value: _fitnessLevel,
                      options: fitnessLevelOptions,
                      labelOf: (o) => o,
                      onChanged: (v) => setState(() => _fitnessLevel = v),
                    ),
                    const SizedBox(height: 16),
                    _dropdown<String>(
                      label: 'Primary goal',
                      icon: Icons.flag_rounded,
                      value: _primaryGoal,
                      options: primaryGoalOptions,
                      labelOf: (o) => o,
                      onChanged: (v) => setState(() => _primaryGoal = v),
                    ),
                    const SizedBox(height: 16),
                    _dropdown<int>(
                      label: 'Available days per week',
                      icon: Icons.calendar_today_rounded,
                      value: _availableDays,
                      options: List.generate(7, (i) => i + 1),
                      labelOf: (d) => '$d',
                      onChanged: (v) => setState(() => _availableDays = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save'),
                  style: FilledButton.styleFrom(
                    backgroundColor: PPColors.coral300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shared decoration so the age field and every dropdown look identical.
  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: PPColors.amethyst200),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PPColors.amethyst300, width: 1.5),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> options,
    required String Function(T) labelOf,
    required ValueChanged<T?> onChanged,
  }) {
    // Guard against a stored value that is no longer (or never was) one of the
    // options — e.g. free-text written by the AI profile flow. Passing an
    // unmatched value to DropdownButtonFormField throws at build time.
    final safeValue = options.contains(value) ? value : null;
    return DropdownButtonFormField<T>(
      initialValue: safeValue,
      isExpanded: true,
      dropdownColor: PPColors.neutral500,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.expand_more_rounded, color: PPColors.neutral300),
      decoration: _fieldDecoration(label, icon),
      items: options
          .map((o) => DropdownMenuItem<T>(value: o, child: Text(labelOf(o))))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Avatar monogram + name/email strip with an amethyst→coral gradient ring.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.email});

  final String name;
  final String email;

  String get _initials {
    final source = name.trim().isNotEmpty ? name.trim() : email.trim();
    if (source.isEmpty) return '?';
    final parts = source.split(RegExp(r'\s+'));
    final letters = parts.length >= 2
        ? '${parts.first[0]}${parts[1][0]}'
        : source.substring(0, source.length >= 2 ? 2 : 1);
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [PPColors.amethyst300, PPColors.coral300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            _initials,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.0,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isNotEmpty ? name : 'Your profile',
                style: textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style:
                    textTheme.bodyMedium?.copyWith(color: PPColors.neutral300),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Rounded translucent panel that groups the editable fields.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }
}
