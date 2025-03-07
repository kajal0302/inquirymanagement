import 'package:flutter/material.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/components/dateRangeComponent.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/pages/sms/apicall/smsApi.dart';
import 'package:inquirymanagement/pages/sms/component/studentListSkeleton.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/button.dart';
import '../../../components/customCalender.dart';
import '../../../components/customDialog.dart';
import '../../../main.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/common.dart';
import '../../course/components/showDynamicCheckboxDialog.dart';
import '../../course/provider/CourseProvider.dart';
import '../../inquiry_report/apicall/inquiryFilterApi.dart';
import '../../inquiry_report/components/referenceDialog.dart';
import '../../notification/apicall/inquiryStatusListApi.dart';
import '../../notification/components/customDialogBox.dart';
import '../../notification/components/statusDialog.dart';
import '../../notification/model/inquiryStatusListModel.dart';

class SmsPage extends StatefulWidget {
  const SmsPage({super.key});

  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay, _rangeStart, _rangeEnd;
  String? startDateString, endDateString;
  InquiryStatusModel? inquiryList;
  InquiryModel? studentFilteredBYCourse;
  Map<String, bool> selectedInquiries = {}; // To track checked items
  List<String> selectedStudentContactNumber = [];
  bool isLoading = true;
  bool isStatusLoading = false;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CourseProvider>(context, listen: false).getCourse(context);
    });
  }

  /// Method to load Status Data
  Future<void> loadInquiryStatusListData() async {
    InquiryStatusModel? inquiryStatusList =
        await fetchInquiryStatusList(context);
    if (mounted) {
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }
  }

  /// Method for date Filter
  void filterInquiriesByDate() async {
    setState(() {
      isLoading = true;
    });

    InquiryModel? fetchedFilteredInquiryData = await FilterInquiryData(
        null, startDateString, endDateString, branchId, null,null, context);

    setState(() {
      studentFilteredBYCourse = fetchedFilteredInquiryData;
      isLoading = false;
    });
  }

  /// Method for Status Filter
  void filterInquiriesByStatus(String selectedName) {
    setState(() {
      isStatusLoading = true;
    });
    List<Inquiries> filteredData = studentFilteredBYCourse!.inquiries!
        .where((student) => student.status == selectedName)
        .toList();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        studentFilteredBYCourse = InquiryModel(inquiries: filteredData);
        isStatusLoading = false;
      });

      Navigator.pop(context);
    });
  }


  /// Method for Reference Filter
  void filterInquiriesByReference(String selectedName) async {
    setState(() {
      isLoading = true;
    });
    InquiryModel? fetchedFilteredInquiryData = await FilterInquiryData(
        null, null, null, branchId, null,selectedName, context);

    setState(() {
      studentFilteredBYCourse = fetchedFilteredInquiryData;
      isLoading = false;
    });
  }

  /// Method for Day Selection
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  /// Method for range selection
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _focusedDay = focusedDay;

      startDateString = _rangeStart != null ? formatDate(_rangeStart!) : "";
      endDateString = _rangeEnd != null ? formatDate(_rangeEnd!) : "";
    });
  }



  /// Add Inquiry Status Dialog Box
  void showInquiryStatusDialog(BuildContext context, InquiryStatusModel? inquiryList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InquiryStatusDialog(
            isInquiryReport: true,
            inquiryList: inquiryList,
            onPressed: (String selectedId, String selectedStatusId, String selectedName) async {
              if (studentFilteredBYCourse == null ||
                  studentFilteredBYCourse!.inquiries!.isEmpty) {
                Navigator.pop(context);
                callSnackBar(noStudent, "danger");
              } else if (selectedId.isEmpty) {
                callSnackBar(noStatus, "danger");
              } else {
                filterInquiriesByStatus(selectedName);
                callSnackBar("Inquiry fetched successfully!", "success");
              }

            });
      },
    );
  }


  /// Add Inquiry Reference Dialog Box
  void showInquiryReferenceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InquiryReferenceDialog(
          onPressed: (String selectedName) async {
            if (studentFilteredBYCourse == null ||
                studentFilteredBYCourse!.inquiries!.isEmpty) {
              Navigator.pop(context);
              callSnackBar(noStudent, "danger");
            } else if (selectedName.isEmpty) {
              callSnackBar(noReference, "danger");
            } else {
              filterInquiriesByReference(selectedName);
              messageController.clear();
              callSnackBar("Inquiry fetched successfully!", "success");
            }

          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForAboutPage(context, "SMS", DashboardPage()),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              controller: messageController,
              maxLines: 5,
              maxLength: 119,
              decoration: InputDecoration(
                filled: true,
                fillColor: grey_100,
                hintText:
                    "Type your message here... (Maximum 119 characters allowed)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                btnWidget(
                  btnBgColor: primaryColor,
                  btnBrdRadius: BorderRadius.circular(px35),
                  btnLabel: "SELECT STUDENT",
                  btnLabelColor: white,
                  btnLabelFontSize: px16,
                  btnLabelFontWeight: FontWeight.bold,
                  onClick: () {
                    List<int?> selectedCourseIds = [];
                    showDynamicCheckboxDialog(
                      context,
                      (selectedCourses) async {
                        selectedCourseIds = selectedCourses.courses!
                            .where((c) => c.isChecked == true)
                            .map((c) => c.id)
                            .toList();
                        String selectedCourseIdsString =
                            selectedCourseIds.join(",");
                        InquiryModel? filteredData = await FilterInquiryData(selectedCourseIdsString, null, null, null, null, null, context);
                        setState(() {
                          studentFilteredBYCourse = filteredData;
                        });
                      },
                      courseProvider.course,
                      () {
                        /// Reset all checkboxes on cancel
                        for (var course in courseProvider.course!.courses!) {
                          course.isChecked = false;
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    String message = messageController.text;
                    String contactNumbers =
                        selectedStudentContactNumber.join(",");
                    if (message.isEmpty) {
                      callSnackBar("Message can't be empty! Please enter value",
                          "danger");
                      return;
                    }
                    if (selectedInquiries.isEmpty) {
                      callSnackBar(
                          "Can't send message without Filtering! Please select Students.",
                          "danger");
                    } else {
                      var data = await SendSms(contactNumbers, message);
                      if (data == null || data.status != success) {
                        callSnackBar("Error in Adding Data", "danger");
                        return;
                      } else {
                        callSnackBar(data.message.toString(), "success");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15),
                    backgroundColor: primaryColor,
                  ),
                  child: Icon(
                    Icons.send,
                    color: white,
                    size: px28,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (studentFilteredBYCourse != null) ...[
            studentFilteredBYCourse!.inquiries!.isNotEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Student List",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "All",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Checkbox(
                                      activeColor: primaryColor,
                                      value: selectedInquiries.length ==
                                              studentFilteredBYCourse!
                                                  .inquiries!.length &&
                                          studentFilteredBYCourse!
                                              .inquiries!.isNotEmpty,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedInquiries.clear();
                                            selectedStudentContactNumber
                                                .clear();

                                            for (var inquiry
                                                in studentFilteredBYCourse!
                                                    .inquiries!) {
                                              selectedInquiries[
                                                  inquiry.id.toString()] = true;
                                              selectedStudentContactNumber
                                                  .add(inquiry.contact ?? "");
                                            }
                                          } else {
                                            selectedInquiries.clear();
                                            selectedStudentContactNumber
                                                .clear();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          isStatusLoading
                              ? StudentListSkeleton()
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: studentFilteredBYCourse!
                                        .inquiries!.length,
                                    itemBuilder: (context, index) {
                                      var inquiry = studentFilteredBYCourse!
                                          .inquiries![index];
                                      String name =
                                          "${inquiry.fname} ${inquiry.lname ?? ''}"
                                              .trim();
                                      String courseName =
                                          inquiry.courses!.isNotEmpty
                                              ? inquiry.courses!.first.name!
                                              : "";
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 2.0),
                                        child: Card(
                                          color: bv_secondaryLightColor3,
                                          elevation: 3,
                                          child: ListTile(
                                            leading: Image.asset(userImg,
                                                height: 40, width: 40),
                                            title: Text(name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: Text(courseName),
                                            trailing: Checkbox(
                                              activeColor: primaryColor,
                                              value: selectedInquiries[
                                                      inquiry.id.toString()] ??
                                                  false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  if (value == true) {
                                                    selectedInquiries[inquiry.id
                                                        .toString()] = true;
                                                    if (!selectedStudentContactNumber
                                                        .contains(
                                                            inquiry.contact)) {
                                                      selectedStudentContactNumber
                                                          .add(
                                                              inquiry.contact ??
                                                                  "");
                                                    }
                                                  } else {
                                                    selectedInquiries.remove(
                                                        inquiry.id.toString());
                                                    selectedStudentContactNumber
                                                        .remove(
                                                            inquiry.contact ??
                                                                "");
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                : DataNotAvailableWidget(message: dataNotAvailable)
          ]
        ],
      ),
      floatingActionButton: CustomSpeedDial(
        /// Date Filter
        onCalendarTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DateRangeDialog(
                  widget: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 600,
                      height: 400,
                      child: CustomCalendar(
                        initialFormat: _calendarFormat,
                        initialFocusedDay: _focusedDay,
                        initialSelectedDay: _selectedDay,
                        initialRangeStart: _rangeStart,
                        initialRangeEnd: _rangeEnd,
                        onDaySelected: _onDaySelected,
                        onRangeSelected: _onRangeSelected,
                      ),
                    ),
                  ),
                  filterInquiriesByDate: () {
                    if (studentFilteredBYCourse == null) {
                      Navigator.pop(context);
                      callSnackBar(noStudent, "danger");
                    } else if (_rangeStart == null) {
                      Navigator.pop(context);
                      callSnackBar("Please select dateRange.", "danger");
                    } else {
                      Navigator.pop(context);
                      filterInquiriesByDate();
                      setState(() {});
                    }
                  });
            },
          );
        },
        /// Status Filter
        onFilterTap: () async {
          /// Show loading dialog
          showLoadingDialog(context);

          /// load status list
          await loadInquiryStatusListData();

          /// Hide loading dialog when done
          hideLoadingDialog(context);

          /// Status Dialog
          showInquiryStatusDialog(context, inquiryList);
        },

        /// Reference Filter
        onReferenceTap: () async{
          /// Show loading dialog
          showLoadingDialog(context);

          /// load status list
          await loadInquiryStatusListData();

          /// Hide loading dialog when done
          hideLoadingDialog(context);

          /// Reference Dialog
          showInquiryReferenceDialog(context);
        },
        backgroundColor: preIconFillColor,
        iconColor: black,
        iconSize: 25.0,
      ),
    );
  }
}
