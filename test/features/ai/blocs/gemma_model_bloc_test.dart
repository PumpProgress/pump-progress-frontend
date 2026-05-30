// test/features/ai/blocs/gemma_model_bloc_test.dart
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_gemma_model/gemma_model_bloc.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';

class MockGemmaModelService extends Mock implements GemmaModelService {}

class MockInferenceModel extends Mock implements InferenceModel {}

void main() {
  late MockGemmaModelService service;
  late StreamController<InferenceModel> modelCtrl;
  late StreamController<void> clearedCtrl;

  setUp(() {
    service = MockGemmaModelService();
    modelCtrl = StreamController<InferenceModel>.broadcast();
    clearedCtrl = StreamController<void>.broadcast();
    when(() => service.modelStream).thenAnswer((_) => modelCtrl.stream);
    when(() => service.clearedStream).thenAnswer((_) => clearedCtrl.stream);
  });

  tearDown(() {
    modelCtrl.close();
    clearedCtrl.close();
  });

  group('GemmaModelBloc init', () {
    blocTest<GemmaModelBloc, GemmaModelState>(
      'emits [Loading, Ready] when a model is restored',
      build: () {
        when(() => service.restoreActive()).thenAnswer((_) async {});
        when(() => service.hasActiveModel).thenReturn(true);
        return GemmaModelBloc(modelService: service);
      },
      act: (bloc) => bloc.add(const GemmaModelInitEvent()),
      expect: () => [
        const GemmaModelState(status: GemmaModelStatusLoading()),
        const GemmaModelState(status: GemmaModelStatusReady()),
      ],
    );

    blocTest<GemmaModelBloc, GemmaModelState>(
      'emits [Loading, NoModel] when nothing is restored',
      build: () {
        when(() => service.restoreActive()).thenAnswer((_) async {});
        when(() => service.hasActiveModel).thenReturn(false);
        return GemmaModelBloc(modelService: service);
      },
      act: (bloc) => bloc.add(const GemmaModelInitEvent()),
      expect: () => [
        const GemmaModelState(status: GemmaModelStatusLoading()),
        const GemmaModelState(status: GemmaModelStatusNoModel()),
      ],
    );

    blocTest<GemmaModelBloc, GemmaModelState>(
      'emits [Loading, Error] when restore throws',
      build: () {
        when(() => service.restoreActive()).thenThrow(Exception('boom'));
        return GemmaModelBloc(modelService: service);
      },
      act: (bloc) => bloc.add(const GemmaModelInitEvent()),
      expect: () => [
        const GemmaModelState(status: GemmaModelStatusLoading()),
        isA<GemmaModelState>().having(
          (s) => s.status,
          'status',
          isA<GemmaModelStatusError>(),
        ),
      ],
    );
  });

  group('GemmaModelBloc stream reactions', () {
    blocTest<GemmaModelBloc, GemmaModelState>(
      'goes Ready when service emits a model',
      build: () {
        when(() => service.hasActiveModel).thenReturn(true);
        return GemmaModelBloc(modelService: service);
      },
      act: (bloc) => modelCtrl.add(MockInferenceModel()),
      expect: () =>
          [const GemmaModelState(status: GemmaModelStatusReady())],
    );

    blocTest<GemmaModelBloc, GemmaModelState>(
      'goes NoModel when service emits cleared',
      build: () => GemmaModelBloc(modelService: service),
      act: (bloc) => clearedCtrl.add(null),
      expect: () =>
          [const GemmaModelState(status: GemmaModelStatusNoModel())],
    );
  });
}
