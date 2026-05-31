// lib/features/ai/blocs/bloc_model_manager/model_manager_state.dart
part of 'model_manager_bloc.dart';

enum ModelDownloadState { notDownloaded, downloading, downloaded }

class ModelItem extends Equatable {
  const ModelItem({
    required this.model,
    required this.state,
    required this.progress,
    required this.isActive,
  });

  final LocalModel model;
  final ModelDownloadState state;
  final int progress; // 0..100 while downloading
  final bool isActive;

  ModelItem copyWith({
    ModelDownloadState? state,
    int? progress,
    bool? isActive,
  }) {
    return ModelItem(
      model: model,
      state: state ?? this.state,
      progress: progress ?? this.progress,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props => [model, state, progress, isActive];
}

class ModelManagerState extends Equatable {
  const ModelManagerState({
    this.items = const [],
    this.totalDiskBytes = 0,
    this.error,
  });

  final List<ModelItem> items;
  final int totalDiskBytes;
  final String? error;

  ModelManagerState copyWith({
    List<ModelItem>? items,
    int? totalDiskBytes,
    String? error,
  }) {
    return ModelManagerState(
      items: items ?? this.items,
      totalDiskBytes: totalDiskBytes ?? this.totalDiskBytes,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, totalDiskBytes, error];
}
