import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/size.dart';

class CustomSpeedDial extends StatelessWidget {
  final VoidCallback onCalendarTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onReferenceTap;
  final Color backgroundColor;
  final Color overlayColor;
  final double overlayOpacity;
  final Color iconColor;
  final double iconSize;
  final bool isWhatsapp;

  const CustomSpeedDial({
    Key? key,
    required this.onCalendarTap,
    this.onFilterTap,
    this.onReferenceTap,
    this.backgroundColor = Colors.blue,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.5,
    this.iconColor = Colors.black,
    this.iconSize = 25.0,
    this.isWhatsapp=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      icon: Icons.add,
      foregroundColor: iconColor,
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
          label:"Date Filter",
          labelStyle:
          TextStyle(fontWeight: FontWeight.w500, color: black),
          labelBackgroundColor: white,
          backgroundColor: backgroundColor,
          child: Icon(Icons.calendar_month,color: iconColor,),
          onTap: onCalendarTap,
        ),
        if(!isWhatsapp)
          SpeedDialChild(
            label:"Course Filter",
            labelStyle:
            TextStyle(fontWeight: FontWeight.w500, color: black),
            labelBackgroundColor: white,
            backgroundColor: backgroundColor,
            child: Icon(Icons.filter_list,color: iconColor,),
            onTap: onFilterTap,
          ),
        SpeedDialChild(
          label:"Reference Filter",
          labelStyle:
          TextStyle(fontWeight: FontWeight.w500, color: black),
          labelBackgroundColor: white,
          backgroundColor: backgroundColor,
          child: Icon(FontAwesomeIcons.users,color: iconColor,),
          onTap: onReferenceTap,
        ),
      ],
    );
  }
}
