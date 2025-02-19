import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/course/components/CourseListTile.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';

Future<void> showDynamicCheckboxDialog(
    BuildContext context, Function(CourseModel) onOkPressed, CourseModel? courses) async {
  if (courses == null || courses.courses == null || courses.courses!.isEmpty) {
    return;
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            '--- Courses ---',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: courses.courses!.asMap().entries.map((entry) {
                    int index = entry.key;
                    var course = entry.value;
                    var name = course.name.toString().length > 8
                        ? course.name.toString().substring(0, 8)
                        : course.name.toString();

                    return CourseListTile(
                      name: "${name}...",
                      status: course.isChecked ?? false,
                      isChecked: (status) {
                        setState(() {
                          print(status.toString());
                          courses.courses![index].isChecked = status;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: grey_500)),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              onOkPressed(courses);
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}
