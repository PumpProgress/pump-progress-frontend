part of 'start_calendar_bloc.dart';

enum StartCalendarStatus { loading, loaded }

class StartCalendarState extends Equatable {
  const StartCalendarState({
    this.status = StartCalendarStatus.loading,
    this.userCalendar = UserCalendar.empty,
  });

  final StartCalendarStatus status;
  final UserCalendar userCalendar;

  @override
  List<Object> get props => [status, userCalendar];

  StartCalendarState copyWith({
    StartCalendarStatus? status,
    UserCalendar? userCalendar,
  }) {
    return StartCalendarState(
      status: status ?? this.status,
      userCalendar: userCalendar ?? this.userCalendar,
    );
  }
}
