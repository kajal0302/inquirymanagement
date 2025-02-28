import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomSpeedDial extends StatelessWidget {
  final VoidCallback onCalendarTap;
  final VoidCallback onFilterTap;
  final Color backgroundColor;
  final Color overlayColor;
  final double overlayOpacity;
  final Color iconColor;
  final double iconSize;

  const CustomSpeedDial({
    Key? key,
    required this.onCalendarTap,
    required this.onFilterTap,
    this.backgroundColor = Colors.blue,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.5,
    this.iconColor = Colors.black,
    this.iconSize = 25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      icon: Icons.add,
      activeIcon: Icons.close,
      spaceBetweenChildren: 0.1,
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(
        color: iconColor,
        size: iconSize,
      ),
      children: [
        SpeedDialChild(
          backgroundColor: backgroundColor,
          child: Icon(Icons.calendar_month),
          onTap: onCalendarTap,
        ),
        SpeedDialChild(
          backgroundColor: backgroundColor,
          child: Icon(Icons.filter_list),
          onTap: onFilterTap,
        ),
      ],
    );
  }
}
