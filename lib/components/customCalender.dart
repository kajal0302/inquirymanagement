import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final CalendarFormat initialFormat;
  final DateTime initialFocusedDay;
  final DateTime? initialSelectedDay;
  final DateTime? initialRangeStart;
  final DateTime? initialRangeEnd;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime?, DateTime?, DateTime) onRangeSelected;

  const CustomCalendar({
    Key? key,
    required this.initialFormat,
    required this.initialFocusedDay,
    this.initialSelectedDay,
    this.initialRangeStart,
    this.initialRangeEnd,
    required this.onDaySelected,
    required this.onRangeSelected,
  }) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;


  @override
  void initState() {
    super.initState();
    _calendarFormat = widget.initialFormat;
    _focusedDay = widget.initialFocusedDay;
    _selectedDay = widget.initialSelectedDay ?? DateTime.now();
    _rangeStart = widget.initialRangeStart;
    _rangeEnd = widget.initialRangeEnd;
  }


  // Method for day selection
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
      });
      widget.onDaySelected(selectedDay, focusedDay);
    }
  }



  // Method for range selection
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      if (start != null && end != null) {
        _selectedDay = null;
      }
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
    widget.onRangeSelected(start, end, focusedDay);
  }


  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 3, 14),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: _onDaySelected,
      rangeStartDay: _rangeStart,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      onRangeSelected: _onRangeSelected,
      rangeEndDay: _rangeEnd,
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        selectedDecoration: BoxDecoration(
          color: preIconFillColor,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: preIconFillColor,
          shape: BoxShape.circle,
        ),
        rangeStartDecoration: BoxDecoration(
          color: bv_primaryDarkColor,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: bv_primaryDarkColor,
          shape: BoxShape.circle,
        ),
      ),
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },

      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
