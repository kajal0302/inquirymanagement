import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/course/components/CourseListTile.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';
import 'package:inquirymanagement/utils/common.dart';
import '../../../common/size.dart';

Future<void> showDynamicCheckboxDialog(
  BuildContext context,
  Function(CourseModel) onOkPressed,
  CourseModel? courses,
  VoidCallback? onCancelPressed,
) async {
  if (courses == null || courses.courses == null || courses.courses!.isEmpty) {
    return;
  }

  TextEditingController _searchController = TextEditingController();
  List<Courses> filteredCourses = List.from(courses.courses!);
  ValueNotifier<bool> isSearching = ValueNotifier(false);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: EdgeInsets.zero,
            title: ValueListenableBuilder<bool>(
              valueListenable: isSearching,
              builder: (context, searching, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: preIconFillColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      searching
                          ? Expanded(
                              child: TextField(
                                controller: _searchController,
                                textInputAction: TextInputAction.search,
                                style: TextStyle(color: white),
                                decoration: InputDecoration(
                                  hintText: 'Type here to Search',
                                  hintStyle: TextStyle(color: white70),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Ensure UI updates
                                    filteredCourses = courses.courses!
                                        .where((course) => course.name!
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  '-- Select Courses --',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                      IconButton(
                        icon: Icon(searching ? Icons.close : Icons.search,
                            color: white),
                        onPressed: () {
                          setState(() {
                            if (searching) {
                              _searchController.clear();
                              filteredCourses = List.from(courses.courses!);
                            }
                            isSearching.value = !searching;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                child: Column(
                  children: filteredCourses.asMap().entries.map((entry) {
                    int index = entry.key;
                    var course = entry.value;
                    var name = course.name!.length > 8
                        ? '${course.name!.substring(0, 8)}...'
                        : course.name;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CourseListTile(
                        name: name!,
                        status: course.isChecked ?? false,
                        isChecked: (status) {
                          setState(() {
                            courses.courses![index].isChecked = status;
                          });
                        },
                        imageUrl: course.image,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              SizedBox(
                width: 108,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    bool isAnySelected =
                        courses.courses!.any((c) => c.isChecked == true);

                    if (!isAnySelected) {
                      callSnackBar(
                          "Please select at least one course", "danger");
                      return;
                    }
                    onOkPressed(courses);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bv_primaryDarkColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(px15)),
                  ),
                  child: const Text("APPLY",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: px15)),
                ),
              ),
              SizedBox(
                width: 108,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    if (onCancelPressed != null) {
                      onCancelPressed(); // Call the custom cancel function
                    }
                    Navigator.pop(context, false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(px15),
                      side: BorderSide(color: grey_500, width: 2),
                    ),
                  ),
                  child: const Text("CANCEL",
                      style: TextStyle(
                          color: grey_500,
                          fontWeight: FontWeight.bold,
                          fontSize: px15)),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
