part of 'calendar_bloc.dart';

sealed class CalendarStatus {
  const CalendarStatus();
}

class CalendarStatusLoading extends CalendarStatus {
  const CalendarStatusLoading();
}

class CalendarStatusSuccess extends CalendarStatus {
  const CalendarStatusSuccess();
}

class CalendarStatusError extends ErrorStatus implements CalendarStatus {
  CalendarStatusError(super.errorMsg);
}

class CalendarState extends Equatable {
  const CalendarState({
    this.status = const CalendarStatusLoading(),
    this.userCalendar = CalendarSeries.empty,
    this.exerciseSummaries = const [],
  });

  final CalendarStatus status;
  final CalendarSeries userCalendar;
  final List<DayExerciseSummary> exerciseSummaries;

  CalendarState copyWith({
    CalendarStatus? status,
    CalendarSeries? userCalendar,
    List<DayExerciseSummary>? exerciseSummaries,
  }) {
    return CalendarState(
      status: status ?? this.status,
      userCalendar: userCalendar ?? this.userCalendar,
      exerciseSummaries: exerciseSummaries ?? this.exerciseSummaries,
    );
  }

  @override
  List<Object> get props => [status, userCalendar, exerciseSummaries];
}

final class CalendarInitial extends CalendarState {}
