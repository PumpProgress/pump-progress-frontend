// lib/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/tools/profile_tool_dispatcher.dart';

class ProfileChatBloc extends BaseChatBloc {
  ProfileChatBloc({
    required super.modelService,
    required ProfileToolDispatcher toolDispatcher,
  }) : _toolDispatcher = toolDispatcher;

  final ProfileToolDispatcher _toolDispatcher;

  /// Human-readable label for a field key, for the prompt's "ask for X" line.
  static const _fieldLabels = {
    'name': 'name',
    'age': 'age',
    'gender': 'gender',
    'fitness_level': 'fitness level',
    'primary_goal': 'primary fitness goal',
    'training_days_per_week': 'number of training days per week',
  };

  // Short prompt: no tool names, no scripted loop. The SDK injects the
  // save_user_information declaration for gemma4, so naming tools here only
  // tempts a small model to narrate the call as text instead of emitting it.
  // We seed the first field to ask from the dispatcher's local snapshot.
  @override
  String get systemPrompt {
    final missing = _toolDispatcher.nextMissingField;
    final next = missing == 'all_fields_collected'
        ? 'All fields are already set. Give a one-line summary of the profile '
            'and ask the user to confirm it is correct.'
        : 'Begin by asking the user for their ${_fieldLabels[missing] ?? missing}.';

    return '''
You are a fitness assistant collecting the user's profile.

- Ask for ONE missing field at a time in a short, friendly question.
- When the user answers, save it. Never invent values; if an answer is
  unclear, ask again for the same field.
- Only collect the profile. Do not give workout or fitness advice yet — if
  asked, say you will help once the profile is complete, then continue.
- Keep every reply under 60 words.

$next''';
  }

  @override
  List<Tool> get tools => _toolDispatcher.tools;

  @override
  ProfileToolDispatcher get toolDispatcher => _toolDispatcher;
}
