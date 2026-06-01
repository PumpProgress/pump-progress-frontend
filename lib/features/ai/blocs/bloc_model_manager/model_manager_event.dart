// lib/features/ai/blocs/bloc_model_manager/model_manager_event.dart
part of 'model_manager_bloc.dart';

sealed class ModelManagerEvent extends Equatable {
  const ModelManagerEvent();

  @override
  List<Object> get props => [];
}

class LoadModels extends ModelManagerEvent {
  const LoadModels();
}

class DownloadModel extends ModelManagerEvent {
  const DownloadModel(this.model);
  final LocalModel model;

  @override
  List<Object> get props => [model];
}

class SelectModel extends ModelManagerEvent {
  const SelectModel(this.model);
  final LocalModel model;

  @override
  List<Object> get props => [model];
}

class DeleteModel extends ModelManagerEvent {
  const DeleteModel(this.model);
  final LocalModel model;

  @override
  List<Object> get props => [model];
}
