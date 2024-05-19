import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key,
  }) : super(key: key);

  final defaultTextStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
  final defaultDecoration = BoxDecoration(
      color: Colors.transparent,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10.0));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        locale: 'ko_KR',
        focusedDay: focusedDay,
        firstDay: DateTime(1900),
        lastDay: DateTime(3000),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle:
              TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          defaultTextStyle: defaultTextStyle,
          holidayTextStyle: defaultTextStyle,
          todayTextStyle: defaultTextStyle,
          todayDecoration: defaultDecoration,
          weekendDecoration: defaultDecoration,
          weekendTextStyle: const TextStyle(
            color: Color(0xFF60805F), // 주말 색상 변경
          ),
          defaultDecoration: defaultDecoration,
          outsideDecoration: defaultDecoration,
          selectedDecoration: BoxDecoration(
            color: const Color(0xFFA6CBA5),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(
            color: Color(0xFF60805F), // 주말 색상 변경
            fontSize: 13,
          ),
          weekdayStyle: TextStyle(
            fontSize: 13,
          ),
        ),
        onDaySelected: onDaySelected,
        selectedDayPredicate: (DateTime date) {
          if (selectedDay == null) return false;

          return date.year == selectedDay!.year &&
              date.month == selectedDay!.month &&
              date.day == selectedDay!.day;
        },
      ),
    );
  }
}
