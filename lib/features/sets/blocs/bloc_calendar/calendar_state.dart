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
    this.setsAtDay = const [],
  });

  final CalendarStatus status;
  final CalendarSeries userCalendar;
  final List<Exercise> setsAtDay;

  CalendarState copyWith({
    CalendarStatus? status,
    CalendarSeries? userCalendar,
    List<Exercise>? setsAtDay,
  }) {
    return CalendarState(
      status: status ?? this.status,
      userCalendar: userCalendar ?? this.userCalendar,
      setsAtDay: setsAtDay ?? this.setsAtDay,
    );
  }

  @override
  List<Object> get props => [status, userCalendar, setsAtDay];
}

final class CalendarInitial extends CalendarState {}
