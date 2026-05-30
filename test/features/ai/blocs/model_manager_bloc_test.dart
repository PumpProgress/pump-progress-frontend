// test/features/ai/blocs/model_manager_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_model_manager/model_manager_bloc.dart';
import 'package:pump_progress_frontend/features/ai/models/entities/local_model.dart';
import 'package:pump_progress_frontend/features/ai/models/model_catalog.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';

class MockGemmaModelService extends Mock implements GemmaModelService {}

void main() {
  late MockGemmaModelService service;
  final LocalModel model = kModelCatalog.first;

  setUpAll(() {
    registerFallbackValue(kModelCatalog.first);
  });

  setUp(() {
    service = MockGemmaModelService();
    when(() => service.totalDiskBytes()).thenAnswer((_) async => 0);
    when(() => service.activeId).thenReturn(null);
  });

  blocTest<ModelManagerBloc, ModelManagerState>(
    'LoadModels marks installed + active and sets total',
    build: () {
      when(() => service.installedIds())
          .thenAnswer((_) async => {model.id});
      when(() => service.activeId).thenReturn(model.id);
      when(() => service.totalDiskBytes())
          .thenAnswer((_) async => 3221225472);
      return ModelManagerBloc(service: service);
    },
    act: (bloc) => bloc.add(const LoadModels()),
    verify: (bloc) {
      final item =
          bloc.state.items.firstWhere((i) => i.model.id == model.id);
      expect(item.state, ModelDownloadState.downloaded);
      expect(item.isActive, isTrue);
      expect(bloc.state.totalDiskBytes, 3221225472);
    },
  );

  blocTest<ModelManagerBloc, ModelManagerState>(
    'DownloadModel transitions downloading -> downloaded + active',
    build: () {
      when(() => service.installedIds()).thenAnswer((_) async => <String>{});
      when(() => service.activate(any(),
          onProgress: any(named: 'onProgress'))).thenAnswer((inv) async {
        final cb = inv.namedArguments[#onProgress]
            as void Function(int)?;
        cb?.call(50);
      });
      when(() => service.totalDiskBytes())
          .thenAnswer((_) async => 100);
      return ModelManagerBloc(service: service);
    },
    seed: () => ModelManagerState(
      items: [
        ModelItem(
          model: model,
          state: ModelDownloadState.notDownloaded,
          progress: 0,
          isActive: false,
        ),
      ],
      totalDiskBytes: 0,
    ),
    act: (bloc) => bloc.add(DownloadModel(model)),
    verify: (bloc) {
      final item =
          bloc.state.items.firstWhere((i) => i.model.id == model.id);
      expect(item.state, ModelDownloadState.downloaded);
      expect(item.isActive, isTrue);
      expect(bloc.state.totalDiskBytes, 100);
    },
  );

  blocTest<ModelManagerBloc, ModelManagerState>(
    'SelectModel flips active without re-download state change',
    build: () {
      when(() => service.activate(any())).thenAnswer((_) async {});
      return ModelManagerBloc(service: service);
    },
    seed: () => ModelManagerState(
      items: [
        ModelItem(
          model: model,
          state: ModelDownloadState.downloaded,
          progress: 100,
          isActive: false,
        ),
      ],
      totalDiskBytes: 100,
    ),
    act: (bloc) => bloc.add(SelectModel(model)),
    verify: (bloc) {
      final item =
          bloc.state.items.firstWhere((i) => i.model.id == model.id);
      expect(item.isActive, isTrue);
      expect(item.state, ModelDownloadState.downloaded);
    },
  );

  blocTest<ModelManagerBloc, ModelManagerState>(
    'DeleteModel resets to notDownloaded and refreshes total',
    build: () {
      when(() => service.delete(any())).thenAnswer((_) async {});
      when(() => service.totalDiskBytes()).thenAnswer((_) async => 0);
      return ModelManagerBloc(service: service);
    },
    seed: () => ModelManagerState(
      items: [
        ModelItem(
          model: model,
          state: ModelDownloadState.downloaded,
          progress: 100,
          isActive: true,
        ),
      ],
      totalDiskBytes: 100,
    ),
    act: (bloc) => bloc.add(DeleteModel(model)),
    verify: (bloc) {
      final item =
          bloc.state.items.firstWhere((i) => i.model.id == model.id);
      expect(item.state, ModelDownloadState.notDownloaded);
      expect(item.isActive, isFalse);
      expect(bloc.state.totalDiskBytes, 0);
    },
  );
}
