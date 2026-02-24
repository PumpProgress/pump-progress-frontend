part of 'calendar_bloc.dart';

sealed class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class FetchSeriesByMonthEvent extends CalendarEvent {
  FetchSeriesByMonthEvent({
    required this.userId,
    int? year,
    int? month,
  })  : year = year ?? DateTime.now().year,
        month = month ?? DateTime.now().month;

  final int year;
  final int month;
  final String userId;

  @override
  List<Object> get props => [year, month, userId];
}

class DaySelectedAtCalendar extends CalendarEvent {
  const DaySelectedAtCalendar({
    required this.day,
    required this.userId,
  });

  final DateTime day;
  final String userId;

  @override
  List<Object> get props => [day, userId];
}
