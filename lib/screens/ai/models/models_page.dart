// lib/screens/ai/models/models_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_model_manager/model_manager_bloc.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/screens/ai/models/view/models_view.dart';

class ModelsPage extends StatelessWidget {
  const ModelsPage({super.key});

  static const routeName = '/ai/models';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ModelManagerBloc(
        service: context.read<GemmaModelService>(),
      )..add(const LoadModels()),
      child: const ModelsView(),
    );
  }
}
