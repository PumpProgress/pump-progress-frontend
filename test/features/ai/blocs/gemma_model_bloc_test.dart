import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_gemma_model/gemma_model_bloc.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';

class MockGemmaModelService extends Mock implements GemmaModelService {}

void main() {
  late MockGemmaModelService mockService;

  setUp(() {
    mockService = MockGemmaModelService();
  });

  group('GemmaModelBloc', () {
    blocTest<GemmaModelBloc, GemmaModelState>(
      'emits [Installing, Ready] when initialization succeeds',
      build: () {
        when(
          () => mockService.initialize(
            onProgress: any(named: 'onProgress'),
          ),
        ).thenAnswer((_) async {});
        return GemmaModelBloc(modelService: mockService);
      },
      act: (bloc) => bloc.add(const GemmaModelInitEvent()),
      expect: () => [
        const GemmaModelState(status: GemmaModelStatusInstalling()),
        const GemmaModelState(
          status: GemmaModelStatusReady(),
          downloadProgress: 100,
        ),
      ],
    );

    blocTest<GemmaModelBloc, GemmaModelState>(
      'emits [Installing, Error] when initialization throws',
      build: () {
        when(
          () => mockService.initialize(
            onProgress: any(named: 'onProgress'),
          ),
        ).thenThrow(Exception('network failure'));
        return GemmaModelBloc(modelService: mockService);
      },
      act: (bloc) => bloc.add(const GemmaModelInitEvent()),
      expect: () => [
        const GemmaModelState(status: GemmaModelStatusInstalling()),
        isA<GemmaModelState>().having(
          (s) => s.status,
          'status',
          isA<GemmaModelStatusError>(),
        ),
      ],
    );
  });
}
