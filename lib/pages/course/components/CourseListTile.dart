import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/style.dart';

class CourseListTile extends StatefulWidget {
  final String name;
  final bool status;
  final Function(bool) isChecked;

  const CourseListTile(
      {super.key,
      required this.name,
      required this.status,
      required this.isChecked});

  @override
  State<CourseListTile> createState() => _CourseListTileState();
}

class _CourseListTileState extends State<CourseListTile> {
  late bool preCheckedValue;

  @override
  void initState() {
    super.initState();
    preCheckedValue = widget.status;
  }

  void _toggleCheckbox() {
    setState(() {
      preCheckedValue = !preCheckedValue;
      widget.isChecked(preCheckedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleCheckbox,
      child: Card(
        elevation: 3,
        color: bv_secondaryLightColor3,
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              widget.name[0],
              style: TextStyle(color: white),
            ),
          ),
          title: Text(
            widget.name,
            style: primary_heading_3_bold,
          ),
          trailing: Checkbox(
            side: BorderSide(
              color: primaryColor,
              width: 1.5,
            ),
            value: preCheckedValue,
            onChanged: (status) {
              setState(() {
                preCheckedValue = status ?? false;
              });
            },
          ),
        ),
      ),
    );
  }
}
