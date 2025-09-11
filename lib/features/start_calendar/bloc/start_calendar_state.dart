part of 'start_calendar_bloc.dart';

enum StartCalendarStatus { loading, loaded, error }

class StartCalendarState extends Equatable {
  const StartCalendarState({
    this.status = StartCalendarStatus.loading,
    this.userCalendar = UserCalendar.empty,
    this.setsAtDay = const [],
    this.lastError,
    this.errorMessage,
  });

  final StartCalendarStatus status;
  final UserCalendar userCalendar;
  final List<UserSeries> setsAtDay;
  final DateTime? lastError;
  final String? errorMessage;

  @override
  List<Object> get props => [status, userCalendar, setsAtDay];

  StartCalendarState copyWith({
    StartCalendarStatus? status,
    UserCalendar? userCalendar,
    List<UserSeries>? setsAtDay,
    DateTime? lastError,
    String? errorMessage,
  }) {
    return StartCalendarState(
      status: status ?? this.status,
      userCalendar: userCalendar ?? this.userCalendar,
      setsAtDay: setsAtDay ?? this.setsAtDay,
      lastError: lastError ?? this.lastError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
