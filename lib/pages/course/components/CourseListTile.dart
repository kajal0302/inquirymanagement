import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/style.dart';
import '../../../common/size.dart';

class CourseListTile extends StatefulWidget {
  final String name;
  final bool status;
  final Function(bool) isChecked;

  const CourseListTile(
      {super.key,
      required this.name,
      required this.status,
      required this.isChecked,
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
      widget.isChecked(preCheckedValue);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleCheckbox,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          height: px70,
          decoration: BoxDecoration(
            color: bv_secondaryLightColor3,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [ // Adding shadow manually if needed
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.2),
                child: ClipOval(
                  child: Center(
                    child: Text(
                      widget.name[0].toUpperCase(),
                      style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: px20),
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.name,
                style: primary_heading_4_bold,
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
        ),
      ),
    );
  }

}
