part of 'start_calendar_bloc.dart';

enum StartCalendarStatus { loading, loaded }

class StartCalendarState extends Equatable {
  const StartCalendarState({
    this.status = StartCalendarStatus.loading,
    this.userCalendar = UserCalendar.empty,
    this.setsAtDay = const [],
  });

  final StartCalendarStatus status;
  final UserCalendar userCalendar;
  final List<UserSeries> setsAtDay;

  @override
  List<Object> get props => [status, userCalendar, setsAtDay];

  StartCalendarState copyWith({
    StartCalendarStatus? status,
    UserCalendar? userCalendar,
    List<UserSeries>? setsAtDay,
  }) {
    return StartCalendarState(
      status: status ?? this.status,
      userCalendar: userCalendar ?? this.userCalendar,
      setsAtDay: setsAtDay ?? this.setsAtDay,
    );
  }
}
