import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/config/constants/fonts.dart';
import 'package:pump_progress_frontend/features/start_calendar/bloc/start_calendar_bloc.dart';
import 'package:pump_progress_frontend/features/start_calendar/view/start_calendar_day_widget.dart';
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
  Widget build(BuildContext context) {
    final userId = context.read<CoreBloc>().state.user.id;

    return BlocConsumer<StartCalendarBloc, StartCalendarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.now().add(const Duration(days: 1)),
              focusedDay: _selectedDay ?? _focusedDay,
              headerVisible: true,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                context.read<StartCalendarBloc>().add(
                    DaySelectedAtCalendar(day: selectedDay, userId: userId));
              },
              onPageChanged: (focusedDay) {
                context.read<StartCalendarBloc>().add(FetchSeriesByMonthEvent(
                    year: focusedDay.year, month: focusedDay.month));
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
                // CalendarFormat.twoWeeks: '2 weeks',
                // CalendarFormat.week: 'Week'
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              headerStyle: HeaderStyle(
                  titleTextStyle:
                      PPFontStyles.h6.copyWith(color: PPColors.neutral100),
                  titleCentered: true),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  final text = DateFormat.E().format(day);
                  return Center(
                    child: Text(
                      text,
                      style: PPFontStyles.small
                          .copyWith(color: PPColors.neutral100),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return StartCalendarDayWidget(
                    day: day,
                    bgColor: PPColors.amethyst400,
                    textColor: PPColors.white,
                  );
                },
                markerBuilder: (context, day, focusedDay) {
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
                  } else {
                    return null;
                  }
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
            Expanded(
              child: ListView.builder(
                  itemCount: state.setsAtDay.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.setsAtDay[index].name),
                      // subtitle: Text(e.exerciseId),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}

// function to check if there is an event at an specific day
bool hasEvent(Map<String, List<String>> map, DateTime day) {
  final key = DateFormat('yyyy-MM-dd').format(day);
  return map.containsKey(key);
}
