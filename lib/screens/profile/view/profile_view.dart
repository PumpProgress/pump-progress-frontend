import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';

const _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
const _fitnessLevelOptions = ['Beginner', 'Intermediate', 'Advanced'];
const _primaryGoalOptions = [
  'Build muscle',
  'Lose weight',
  'Gain strength',
  'Improve endurance',
  'General fitness',
];

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
    _availableDays = user.availableDaysPerWeek;
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
            availableDaysPerWeek: _availableDays,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserSessionBloc>().state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.person_rounded),
                title: Text(user.name),
                subtitle: Text(user.email),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed <= 0 || parsed > 120) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: _genderOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
                onChanged: (value) => setState(() => _gender = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _fitnessLevel,
                decoration: const InputDecoration(labelText: 'Fitness level'),
                items: _fitnessLevelOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
                onChanged: (value) => setState(() => _fitnessLevel = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _primaryGoal,
                decoration: const InputDecoration(labelText: 'Primary goal'),
                items: _primaryGoalOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
                onChanged: (value) => setState(() => _primaryGoal = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _availableDays,
                decoration: const InputDecoration(
                    labelText: 'Available days per week'),
                items: List.generate(7, (i) => i + 1)
                    .map((d) =>
                        DropdownMenuItem(value: d, child: Text('$d')))
                    .toList(),
                onChanged: (value) => setState(() => _availableDays = value),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
