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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 3, 14),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        rowHeight: 40,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        rangeSelectionMode: RangeSelectionMode.toggledOn,
        onDaySelected: _onDaySelected,
        onRangeSelected: _onRangeSelected,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },

        ///  Header Style
        headerStyle: const
        HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          headerMargin: EdgeInsets.only(bottom: 16.0),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          formatButtonDecoration: BoxDecoration(
            color: bv_primaryDarkColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black54,size: 30,),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black54,size: 30,),
        ),

        ///  Calendar Style
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          selectedDecoration: BoxDecoration(
            color: preIconFillColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            ),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          selectedTextStyle: TextStyle(color: Colors.white),
          rangeStartDecoration: BoxDecoration(
            color: bv_primaryDarkColor,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: bv_primaryDarkColor,
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: BoxDecoration(
            color: Color(0xFFB3E5FC),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(color: Colors.black87),
        ),

        ///  Days of Week Styling
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.black87),
          weekdayStyle: TextStyle(color: Colors.black87),
        ),
      ),
    );

  }
}
