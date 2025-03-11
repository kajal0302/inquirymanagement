import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/style.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../common/size.dart';

class CourseListTile extends StatefulWidget {
  final String name;
  final bool status;
  final Function(bool) isChecked;
  final String? imageUrl;

  const CourseListTile({
    super.key,
    required this.name,
    required this.status,
    required this.isChecked,
    this.imageUrl,
  });

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
    });
    widget.isChecked(preCheckedValue);
  }


  @override
  void didUpdateWidget(CourseListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      setState(() {
        preCheckedValue = widget.status;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleCheckbox,
      child: Card(
        elevation: 3,
        color: bv_secondaryLightColor3,
        child: ListTile(
          title: Text(
            widget.name,
            style: primary_heading_3_bold,
          ),
          trailing: Checkbox(
            activeColor: primaryColor,
            side: BorderSide(
              color: primaryColor,
              width: 1.5,
            ),
            value: preCheckedValue,
            onChanged: (status) {
              _toggleCheckbox();
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
