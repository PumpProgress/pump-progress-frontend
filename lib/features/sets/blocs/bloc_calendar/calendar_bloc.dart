import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({required this.repositorySets}) : super(CalendarState()) {
    on<FetchSeriesByMonthEvent>(_onFetchSeriesByMonthEvent);
    on<DaySelectedAtCalendar>(_onDaySelectedAtCalendar);
  }
  final RepositorySets repositorySets;

  Future<void> _onFetchSeriesByMonthEvent(
      FetchSeriesByMonthEvent event, Emitter<CalendarState> emit) async {
    await runSafeEvent(emit, () => state, CalendarStatusError.new, () async {
      final userCalendar = await repositorySets.getCalendarInfoByUserId(
        userId: event.userId,
        month: event.month,
        year: event.year,
      );
      emit(state.copyWith(userCalendar: userCalendar, exerciseSummaries: []));
    });
  }

  Future<void> _onDaySelectedAtCalendar(
      DaySelectedAtCalendar event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(
      status: const CalendarStatusLoading(),
      exerciseSummaries: [],
    ));
    await runSafeEvent(emit, () => state, CalendarStatusError.new, () async {
      final summaries = await repositorySets.getExerciseSummariesByDate(
        userId: event.userId,
        date: event.day,
      );
      emit(state.copyWith(exerciseSummaries: summaries));
    });
  }
}
