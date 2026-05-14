import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';

class AiToolDispatcher {
  AiToolDispatcher({required this.repositoryExercises});

  final RepositoryExercises repositoryExercises;

  static const List<Tool> tools = [
    Tool(
      name: 'get_exercises_by_muscle',
      description:
          'Returns a list of exercises that target a specific muscle group.',
      parameters: {
        'type': 'object',
        'properties': {
          'muscle': {
            'type': 'string',
            'description': 'The muscle group to filter by.',
            'enum': ['chest'], // TODO: fill in all muscle names from the DB
          },
          'limit': {
            'type': 'integer',
            'description':
                'Maximum number of exercises to return. Defaults to 10.',
          },
        },
        'required': ['muscle'],
      },
    ),
  ];

  Future<Map<String, dynamic>> dispatch(FunctionCallResponse call) =>
      switch (call.name) {
        'get_exercises_by_muscle' => _getExercisesByMuscle(call.args),
        _ => Future.value({'error': 'Unknown tool: ${call.name}'}),
      };

  Future<Map<String, dynamic>> _getExercisesByMuscle(
    Map<String, dynamic> args,
  ) async {
    final muscle = args['muscle'] as String? ?? '';
    final limit = (args['limit'] as num?)?.toInt() ?? 10;
    final exercises = await repositoryExercises.getExercisesByMuscle(
      muscle,
      limit: limit,
    );
    return {
      'exercises':
          exercises.map((e) => {'id': e.id, 'name': e.name}).toList(),
    };
  }
}
