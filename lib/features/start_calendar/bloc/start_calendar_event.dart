part of 'start_calendar_bloc.dart';

sealed class StartCalendarEvent extends Equatable {
  const StartCalendarEvent();

  @override
  List<Object> get props => [];
}

class FetchSeriesByMonthEvent extends StartCalendarEvent {
  FetchSeriesByMonthEvent({
    int? year,
    int? month,
  })  : year = year ?? DateTime.now().year,
        month = month ?? DateTime.now().month;

  final int year;
  final int month;

  @override
  List<Object> get props => [year, month];
}

class DaySelectedAtCalendar extends StartCalendarEvent {
  const DaySelectedAtCalendar({
    required this.day,
    required this.userId,
  });

  final DateTime day;
  final String userId;

  @override
  List<Object> get props => [day, userId];
}
