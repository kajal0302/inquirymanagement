import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/login/screen/login.dart';
import 'package:provider/provider.dart';
import '../../../common/size.dart';
import '../../../components/CustomCheckboxField.dart';
import '../../../components/DynamicStepper.dart';
import '../../../components/dropDown.dart';
import '../apicall/courseListApi.dart';
import '../models/courseListModel.dart';
import '../provider/categoryProvider.dart';
import '../screen/StudentForm.dart';


List<String> selectedBatchItems = []; //Stores selected batch Items
List<String> selectedBatchIds = []; // Stores selected batch ids
List<Map<String, dynamic>> courseItemsWithFee = []; // Stores fetched course list
List<Map<String, dynamic>> selectedCourses = []; // Stores selected courses with fees
List<String> courseIds = []; // To store selected course IDs
List<String> courseItems = []; //To store course name

class CourseDetails extends StatefulWidget {
  CourseDetails({super.key,
    required this.formKey,
    required this.batchController,
    required this.categoryController,
    required this.courseController,
    required this.categoryProvider,
    required this.onCourseSelected,
    required this.isSubmitted
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController batchController;
  final TextEditingController categoryController;
  final TextEditingController courseController;
  final CategoryProvider categoryProvider;
  final Function(bool) onCourseSelected;
  final bool isSubmitted;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCourses.clear();
    loadstudentCourseListData();
  }

  // Method for finding ids to there corresponding batch items
  void onBatchSelected(List<String> selectedItems) {
    selectedBatchItems = selectedItems;
    // Find corresponding IDs
    selectedBatchIds = selectedItems.map((name) {
      int index = batchItems.indexOf(name);
      return index != -1 ? batchIds[index] : '';
    }).where((id) => id.isNotEmpty).toList() as List<String>;

  }

  // Method for finding ids to there corresponding course items
  void onCourseSelected(List<String> selectedItems) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          selectedCourses = courseItemsWithFee
              .where((course) => selectedItems.contains(course["value"]))
              .toList();

          courseIds = selectedCourses
              .map((course) => course["id"].toString())
              .toList();

          print("================");
          print(courseIds);

          widget.courseController.text = selectedCourses
              .map((e) => e["value"])
              .join(", ");

          isCourseSelected = selectedCourses.isNotEmpty;
        });
      }
    });
  }


  void _onCategoryChanged(String? selectedCategoryId) {
    if (selectedCategoryId != null && selectedCategoryId != categoryId) {
      categoryId = selectedCategoryId;
      if (mounted) {
        setState(() {
          widget.categoryController.text = selectedCategoryId;
        });
      }
      widget.courseController.clear();
      selectedCourses.clear();
      // Load student course list
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
        courseItemsWithFee = fetchedCourseListData.courses!.map((item) => {
          "id": item.id.toString(),
          "value": item.name ?? '',
          "total_fee": int.tryParse(item.fees ?? '0') ?? 0,
        }).toList();
        courseItems =
            fetchedCourseListData.courses!.map((item) => item.name ?? '').toList();

      } else {
        courseIds = [];
        courseItemsWithFee = [];
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
      autovalidateMode: AutovalidateMode.onUserInteraction,  // This ensures validation happens after interaction
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
              onChanged: (selectedItems) {
                if (selectedItems is List) {
                  onBatchSelected(selectedItems.map((e) => e.toString()).toList());
                } else {
                  onBatchSelected([]);
                }
              },
              validator: (value) {
                if (widget.isSubmitted &&
                    (value == null || value.isEmpty)) {
                  return 'Please select a Batch';
                }
                return null;
              }),
          SizedBox(height: 10,),
          TextWidget(labelAlignment: Alignment.topLeft, label: "Select Category", labelClr: black, labelFontWeight: FontWeight.normal, labelFontSize: px15),
          DropDown(
            preSelectedValue: (categoryProvider.category != null &&
                categoryProvider.category!.categories != null &&
                categoryProvider.category!.categories!
                    .any((b) => b.id.toString() == widget.categoryController.text))
                ? widget.categoryController.text
                : (categoryProvider.category != null &&
                categoryProvider.category!.categories != null &&
                categoryProvider.category!.categories!.isNotEmpty
                ? categoryProvider.category!.categories!.first.id.toString()
                : ""),
            controller: widget.categoryController,
            mapItems: (categoryProvider.category != null &&
                categoryProvider.category!.categories != null)
                ? categoryProvider.category!.categories!
                .map((b) => {"id": b.id.toString(), "value": b.name.toString()})
                .toSet()
                .toList()
                : [],
            status: true,
            lbl: "Select Category",
            onChanged: _onCategoryChanged,
          ),
          CustomCheckBoxTextField(
          title: "Select Course",
          controller: widget.courseController,
          items: courseItems,
          titleText: "-- Select Course --",
          status: true,
          includeAllCheckbox: true,
          selectedItems: selectedCourses.map((e) => e["value"].toString()).toList(),
          onChanged: (selectedItems) {
            onCourseSelected(selectedItems);
          },
          validator: (value) {
            if (widget.isSubmitted && (value == null || value.isEmpty)) {
              return 'Please select a Course';
            }
            return null;
          },
    ),


    SizedBox(height: 20),

          // Display Selected Courses & Total Fee

        if (selectedCourses.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Course List",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Price",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1),

                // Course List
                Column(
                  children: selectedCourses.map((course) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              course["value"],
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "₹${course["total_fee"] ?? 0}",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Divider(thickness: 1),

                // Total Row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "₹${getTotalFee()}",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

    ],
      ),
    );
  }

}

