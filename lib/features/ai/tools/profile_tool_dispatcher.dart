import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/ai/tools/tool_definition.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';

/// Dispatcher for the complete-profile chat. Lets the model discover which
/// profile field is still missing and persist collected fields through the
/// [UserSessionBloc].
///
/// The dispatcher keeps a local snapshot of the collected fields, seeded from
/// the saved profile on [init], so already-known fields are not re-asked. Saves
/// are routed through [UserSessionUpdateProfileEvent], which persists the
/// profile and refreshes the session state.
class ProfileToolDispatcher extends AiToolDispatcher {
  ProfileToolDispatcher({required this.userSessionBloc});

  final UserSessionBloc userSessionBloc;

  // Local snapshot of collected fields. `name` is owned by the backend and is
  // not carried by UserSessionUpdateProfileEvent, so it is tracked here only.
  String? _name;
  int? _age;
  String? _gender;
  String? _fitnessLevel;
  String? _primaryGoal;
  int? _trainingDaysPerWeek;

  @override
  Future<void> init() async {
    final user = userSessionBloc.state.user;
    _name = user.name.isEmpty ? null : user.name;
    _age = user.age;
    _gender = user.gender;
    _fitnessLevel = user.fitnessLevel;
    _primaryGoal = user.primaryGoal;
    _trainingDaysPerWeek = user.trainingDaysPerWeek;

    definitions = [
      ToolDefinition(
        tool: Tool(
          name: 'save_user_information',
          description: """
              Save one or more fields of the user's fitness profile. 
              The model should call with an object with the profile data 
              """,
          parameters: {
            'type': 'object',
            'properties': {
              'age': {
                'type': 'integer',
                'description': "The user's age.",
              },
              'gender': {
                'type': 'string',
                'description': "The user's gender.",
                'enum': genderOptions,
              },
              'fitness_level': {
                'type': 'string',
                'description': "The user's fitness level.",
                'enum': fitnessLevelOptions,
              },
              'primary_goal': {
                'type': 'string',
                'description': "The user's primary fitness goal.",
                'enum': primaryGoalOptions,
              },
              'training_days_per_week': {
                'type': 'integer',
                'description':
                    'The number of days per week the user can dedicate to fitness'
              },
            },
          },
        ),
        messageBuilder: (args) => 'Saving your profile...',
        handler: _saveUserInformation,
      ),
    ];
  }

  /// The next field the model should ask for, in onboarding order, or
  /// `"all_fields_collected"` when the profile is complete. The chat bloc reads
  /// this to seed its prompt, so the model never needs a no-arg lookup tool.
  String get nextMissingField => _missingField();

  /// Returns the name of the first required field still missing, in onboarding
  /// order, or `"all_fields_collected"` when the profile is complete.
  String _missingField() {
    if (_name == null || _name!.isEmpty) return 'name';
    if (_age == null) return 'age';
    if (_gender == null || _gender!.isEmpty) return 'gender';
    if (_fitnessLevel == null || _fitnessLevel!.isEmpty) return 'fitness_level';
    if (_primaryGoal == null || _primaryGoal!.isEmpty) return 'primary_goal';
    if (_trainingDaysPerWeek == null) return 'training_days_per_week';
    return 'all_fields_collected';
  }

  Future<Map<String, dynamic>> _saveUserInformation(
    Map<String, dynamic> args,
  ) async {
    if (args['name'] != null) _name = args['name'] as String;
    if (args['age'] != null) _age = (args['age'] as num).toInt();
    // Canonicalize the enum-backed fields so the stored value matches a profile
    // dropdown option even if the model returns a differently-cased string.
    if (args['gender'] != null) {
      _gender = canonicalizeOption(args['gender'] as String, genderOptions);
    }
    if (args['fitness_level'] != null) {
      _fitnessLevel = canonicalizeOption(
          args['fitness_level'] as String, fitnessLevelOptions);
    }
    if (args['primary_goal'] != null) {
      _primaryGoal = canonicalizeOption(
          args['primary_goal'] as String, primaryGoalOptions);
    }
    if (args['training_days_per_week'] != null) {
      _trainingDaysPerWeek = (args['training_days_per_week'] as num).toInt();
    }

    userSessionBloc.add(
      UserSessionUpdateProfileEvent(
        age: _age,
        gender: _gender,
        fitnessLevel: _fitnessLevel,
        primaryGoal: _primaryGoal,
        trainingDaysPerWeek: _trainingDaysPerWeek,
      ),
    );

    final missing = _missingField();
    return {
      'status': 'saved',
      'missing_field': missing,
      // When the profile is complete, hand the chat a ready-to-show summary so
      // it can skip a fragile model-generated closing turn (small models tend
      // to echo the tool-call format instead of writing prose). The bloc shows
      // any `display_message` verbatim. See [BaseChatBloc._onSendMessage].
      if (missing == 'all_fields_collected') 'display_message': _summary(),
    };
  }

  /// Human-readable recap of the collected profile, shown as the assistant's
  /// closing message once every field is set.
  String _summary() {
    String line(String label, Object? value) => '• $label: ${value ?? '—'}';
    return [
      "Here's your profile:",
      line('Name', _name),
      line('Age', _age),
      line('Gender', _gender),
      line('Fitness level', _fitnessLevel),
      line('Primary goal', _primaryGoal),
      line('Training days per week', _trainingDaysPerWeek),
      '',
      'Does everything look correct?',
    ].join('\n');
  }
}
