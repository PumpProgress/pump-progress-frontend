// test/screens/ai/models/models_view_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_model_manager/model_manager_bloc.dart';
import 'package:pump_progress_frontend/features/ai/models/model_catalog.dart';
import 'package:pump_progress_frontend/screens/ai/models/view/models_view.dart';
import 'package:pump_progress_frontend/utils/helpers/format_bytes.dart';

class MockModelManagerBloc
    extends MockBloc<ModelManagerEvent, ModelManagerState>
    implements ModelManagerBloc {}

void main() {
  late MockModelManagerBloc bloc;
  final model = kModelCatalog.first;

  setUp(() {
    bloc = MockModelManagerBloc();
  });

  Widget wrap() => MaterialApp(
        home: BlocProvider<ModelManagerBloc>.value(
          value: bloc,
          child: const ModelsView(),
        ),
      );

  testWidgets('shows Download for a not-downloaded model', (tester) async {
    when(() => bloc.state).thenReturn(ModelManagerState(
      items: [
        ModelItem(
          model: model,
          state: ModelDownloadState.notDownloaded,
          progress: 0,
          isActive: false,
        ),
      ],
      totalDiskBytes: 0,
    ));
    await tester.pumpWidget(wrap());
    expect(find.text(model.displayName), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
    expect(find.textContaining(formatBytes(model.sizeBytes)), findsOneWidget);
  });

  testWidgets('shows Use + Delete and the live total footer',
      (tester) async {
    when(() => bloc.state).thenReturn(ModelManagerState(
      items: [
        ModelItem(
          model: model,
          state: ModelDownloadState.downloaded,
          progress: 100,
          isActive: false,
        ),
      ],
      totalDiskBytes: 2147483648, // 2.0 GB
    ));
    await tester.pumpWidget(wrap());
    expect(find.text('Use'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Total on disk: 2.0 GB'), findsOneWidget);
  });

  testWidgets('shows Active badge for active model', (tester) async {
    when(() => bloc.state).thenReturn(ModelManagerState(
      items: [
        ModelItem(
          model: model,
          state: ModelDownloadState.downloaded,
          progress: 100,
          isActive: true,
        ),
      ],
      totalDiskBytes: 100,
    ));
    await tester.pumpWidget(wrap());
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('Download button dispatches DownloadModel', (tester) async {
    when(() => bloc.state).thenReturn(ModelManagerState(
      items: [
        ModelItem(
          model: model,
          state: ModelDownloadState.notDownloaded,
          progress: 0,
          isActive: false,
        ),
      ],
      totalDiskBytes: 0,
    ));
    await tester.pumpWidget(wrap());
    await tester.tap(find.text('Download'));
    verify(() => bloc.add(DownloadModel(model))).called(1);
  });
}
