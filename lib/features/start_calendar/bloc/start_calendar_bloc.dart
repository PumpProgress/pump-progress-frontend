import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/repositories/models/user_calendar.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'start_calendar_event.dart';
part 'start_calendar_state.dart';

class StartCalendarBloc extends Bloc<StartCalendarEvent, StartCalendarState> {
  StartCalendarBloc({
    required this.pumpProgressRepository,
    required this.coreBloc,
  }) : super(const StartCalendarState()) {
    on<FetchSeriesByMonthEvent>(_onFetchSeriesByMonthEvent);
  }

  final PumpProgressRepository pumpProgressRepository;
  final CoreBloc coreBloc;

  Future<void> _onFetchSeriesByMonthEvent(event, emit) async {
    try {
      final me = coreBloc.state.user;
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
