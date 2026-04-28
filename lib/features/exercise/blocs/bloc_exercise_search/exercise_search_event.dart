part of 'exercise_search_bloc.dart';

sealed class ExerciseSearchEvent extends Equatable {
  const ExerciseSearchEvent();

  @override
  List<Object> get props => [];
}

class UpdateSearchTermEvent extends ExerciseSearchEvent {
  final String searchTerm;

  const UpdateSearchTermEvent(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}
