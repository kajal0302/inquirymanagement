import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/CustomCheckboxField.dart';
import '../../../components/dropDown.dart';
import '../apicall/courseListApi.dart';
import '../models/courseListModel.dart';
import '../provider/categoryProvider.dart';
import '../screen/StudentForm.dart';

class CourseDetails extends StatefulWidget {
  CourseDetails({super.key,
    required this.formKey,
    required this.batchController,
    required this.categoryController,
    required this.courseController,
    required this.categoryProvider,
    required this.isEdit});

  final GlobalKey<FormState> formKey;
  bool isEdit;
  final TextEditingController batchController;
  final TextEditingController categoryController;
  final TextEditingController courseController;
  final CategoryProvider categoryProvider;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  List<Map<String, dynamic>> selectedCourses = []; // Stores selected courses with fees
  final bool isSubmitted = false;
  List<Map<String, dynamic>> courseItems = []; // Stores fetched course list


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadstudentCourseListData();

  }

  void _onCategoryChanged(String? selectedCategoryId) {
    if (selectedCategoryId != null) {
      setState(() {
        widget.categoryController.text = selectedCategoryId;
      });
      categoryId = selectedCategoryId;
      loadstudentCourseListData();
    }
  }

  // Load Course List Data
  Future<void> loadstudentCourseListData() async {
    StudentCourseListModel? fetchedCourseListData =
    await fetchStudentCourseListData(context,categoryId.toString());
    setState(() {
      if (fetchedCourseListData != null &&
          fetchedCourseListData.courses != null &&
          fetchedCourseListData.courses!.isNotEmpty) {
        courseItems = fetchedCourseListData.courses!.map((item) => {
          "id": item.id.toString(),
          "value": item.name ?? '',
          "total_fee": item.fees ?? 0,
        }).toList();
      } else {
        courseItems = [];
      }
    });
  }

  // Calculate total fee of selected courses
  double getTotalFee() {
    return selectedCourses.fold(0, (sum, course) {
      double fee = double.tryParse(course["total_fee"].toString()) ?? 0.0;
      return sum + fee;
    });
  }



  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomCheckBoxTextField(
              title: "Select Batch",
              controller: widget.batchController,
              items: batchItems,
              titleText: "-- Select Batch --",
              status: true,
              includeAllCheckbox: false,
              selectedItems: selectedBatchItems,
              validator: (value) {
                if (isSubmitted &&
                    (value == null || value.isEmpty)) {
                  return 'Please select a Batch';
                }
                return null;
              }),
          SizedBox(height: 10,),
          DropDown(
            preSelectedValue: categoryProvider.category!.categories != null &&
                categoryProvider.category!.categories!
                    .any((b) => b.id.toString() == widget.categoryController.text)
                ? widget.categoryController.text
                : (categoryProvider.category != null &&
                categoryProvider.category!.categories!.isNotEmpty
                ? categoryProvider.category!.categories!.first.id.toString()
                : null),
            controller: widget.categoryController,
            mapItems: categoryProvider.category!.categories!
                .map((b) => {"id": b.id.toString(), "value": b.name.toString()})
                .toSet()
                .toList(),
            status: true,
            lbl: "Select Category",
            onChanged: _onCategoryChanged,
          ),
          CustomCheckBoxTextField(
            title: "Select Course",
            controller: widget.courseController,
            items: courseItems.map((e) => e["value"]).toList(),
            titleText: "-- Select Course --",
            status: true,
            includeAllCheckbox: true,
            selectedItems: selectedCourses.map((e) => e["value"].toString()).toList(),
            onChanged: (newSelectedItems) {
              setState(() {
                // Find the full course details for each selected course
                selectedCourses = courseItems
                    .where((course) => newSelectedItems.contains(course["value"]))
                    .toList();
              });

              print("===============");
              print(selectedCourses);

            },
            validator: (value) {
              if (isSubmitted && (value == null || value.isEmpty)) {
                return 'Please select a Course';
              }
              return null;
            },
          ),

          SizedBox(height: 20),

          /// Display Selected Courses & Total Fee

          if (selectedCourses.isNotEmpty)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text("Course List", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: selectedCourses.map((course) {
                    return Row(
                      children: [
                        Expanded(child: Text(course["value"])), // Course name
                        Expanded(child: Text("₹${course["total_fee"] ?? 0}")), // Course fee
                      ],
                    );
                  }).toList(),
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                        child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("₹${getTotalFee()}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),

        ],
      ),
    );
  }

}

