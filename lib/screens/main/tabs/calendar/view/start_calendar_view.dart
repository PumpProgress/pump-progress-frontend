import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/day_stats_summary_widget.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/exercise_card_widget.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/muscle_sets_chips_widget.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/start_calendar_day_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class StartCalendarView extends StatefulWidget {
  const StartCalendarView({super.key});

  @override
  State<StartCalendarView> createState() => _StartCalendarViewState();
}

class _StartCalendarViewState extends State<StartCalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final userId = context.read<UserSessionBloc>().state.user.id;
    context.read<CalendarBloc>().add(FetchSeriesByMonthEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserSessionBloc>().state.user.id;

    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.now().add(const Duration(days: 1)),
              focusedDay: _selectedDay ?? _focusedDay,
              headerVisible: true,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                context.read<CalendarBloc>().add(
                    DaySelectedAtCalendar(day: selectedDay, userId: userId));
              },
              onPageChanged: (focusedDay) {
                context.read<CalendarBloc>().add(FetchSeriesByMonthEvent(
                      year: focusedDay.year,
                      month: focusedDay.month,
                      userId: userId,
                    ));
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = null;
                });
              },
              eventLoader: (day) {
                return state.userCalendar
                        .dates[DateFormat('yyyy-MM-dd').format(day)] ??
                    [];
              },
              calendarFormat: _calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              },
              headerStyle: const HeaderStyle(titleCentered: true),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(child: Text(DateFormat.E().format(day)));
                },
                selectedBuilder: (context, day, focusedDay) =>
                    StartCalendarDayWidget(
                  day: day,
                  bgColor: PPColors.amethyst400,
                  textColor: PPColors.white,
                ),
                markerBuilder: (context, day, events) {
                  if (hasEvent(state.userCalendar.dates, day)) {
                    return StartCalendarDayWidget(
                      day: day,
                      textColor: isSameDay(_selectedDay, day)
                          ? PPColors.white
                          : PPColors.coral300,
                      bgColor: isSameDay(_selectedDay, day)
                          ? PPColors.coral300
                          : null,
                    );
                  }
                  return null;
                },
                todayBuilder: (context, day, focusedDay) =>
                    StartCalendarDayWidget(
                  day: day,
                  textColor: PPColors.amethyst300,
                ),
                defaultBuilder: (context, day, focusedDay) =>
                    StartCalendarDayWidget(
                  day: day,
                  textColor: PPColors.amethyst100,
                ),
              ),
            ),
            if (state.exerciseSummaries.isNotEmpty) ...[
              DayStatsSummaryWidget(summaries: state.exerciseSummaries),
              MuscleSetsChipsWidget(summaries: state.exerciseSummaries),
              ...state.exerciseSummaries
                  .map((s) => ExerciseCardWidget(summary: s)),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    _selectedDay == null
                        ? 'Select a day to see your workout'
                        : 'No workout logged for this day.',
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

bool hasEvent(Map<String, dynamic> map, DateTime day) {
  final key = DateFormat('yyyy-MM-dd').format(day);
  return map.containsKey(key);
}
