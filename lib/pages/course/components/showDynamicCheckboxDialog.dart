import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/course/components/CourseListTile.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';

Future<void> showDynamicCheckboxDialog(
    BuildContext context, CourseModel? courses) async {
  if (courses == null || courses.courses == null || courses.courses!.isEmpty) {
    return;
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('--- Courses ---'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    children: courses.courses!.map((course) {
                  var name = course.name.toString().length > 8
                      ? course.name.toString().substring(0, 8)
                      : course.name.toString();
                  return CourseListTile(
                    name: "${name}..." ?? "",
                    status: course.isChecked ?? false,
                  );
                }).toList()),
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              // onOkPressed();
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}
