import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/models.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'start_calendar_event.dart';
part 'start_calendar_state.dart';

class StartCalendarBloc extends Bloc<StartCalendarEvent, StartCalendarState> {
  StartCalendarBloc({
    required this.pumpProgressRepository,
    required this.me,
  }) : super(const StartCalendarState()) {
    on<FetchSeriesByMonthEvent>(_onFetchSeriesByMonthEvent);
  }

  final PumpProgressRepository pumpProgressRepository;
  final User me;

  Future<void> _onFetchSeriesByMonthEvent(event, emit) async {
    try {
      final userCalendar = await pumpProgressRepository.getCalendarInfoByUserId(
        userId: me.id,
        month: event.month,
        year: event.year,
      );
      emit(state.copyWith(userCalendar: userCalendar));
    } catch (e) {
      print(e);
    }
  }
}
