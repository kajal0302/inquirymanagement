import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/inquiry/screen/AddInquiryPage.dart';
import 'package:inquirymanagement/pages/inquiry_report/apicall/inquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry_report/components/inquiryCardSkeleton.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/appBar.dart';
import '../../../components/customCalender.dart';
import '../../../components/customDialog.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/urlLauncherMethods.dart';
import '../../branch/model/addBranchModel.dart';
import '../../course/components/showDynamicCheckboxDialog.dart';
import '../../course/provider/CourseProvider.dart';
import '../../dashboard/screen/dashboard.dart';
import '../../notification/apicall/feedbackApi.dart';
import '../../notification/apicall/inquiryStatusListApi.dart';
import '../../notification/apicall/postFeedbackApi.dart';
import '../../notification/apicall/updateInquiryStatus.dart';
import '../../notification/components/customDialogBox.dart';
import '../../notification/components/feedbackDialog.dart';
import '../../notification/components/notificationSettingsDialog.dart';
import '../../notification/model/feedbackModel.dart';
import '../../notification/model/inquiryStatusListModel.dart';
import '../../students/screen/StudentForm.dart';
import '../apicall/inquiryFilterApi.dart';
import '../apicall/inquirySearchFilter.dart';
import '../components/inquiryCard.dart';

class InquiryReportPage extends StatefulWidget {
  const InquiryReportPage({super.key});

  @override
  State<InquiryReportPage> createState() => _InquiryReportPageState();
}

class _InquiryReportPageState extends State<InquiryReportPage> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  bool isLoading = true;
  InquiryModel? inquiryData;
  FeedbackModel? feedbackData;
  InquiryStatusModel? inquiryList;
  InquiryModel? filteredInquiryData;
  InquiryModel? inquirySearchedData;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? startDateString;
  String? endDateString;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CourseProvider>(context, listen: false).getCourse(context);

    });
    _selectedDay = _focusedDay;
    loadinquiryData();
  }

// Method for Day Selection
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  // Method for range selection
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _focusedDay = focusedDay;

      startDateString = _rangeStart != null ? formatDate(_rangeStart!) : "";
      endDateString = _rangeEnd != null ? formatDate(_rangeEnd!) : "";
    });

  }


  // Method to load inquiry data
  Future <InquiryModel?> loadinquiryData( ) async{
    InquiryModel? fetchedInquiryListData = await fetchInquiryData(branchId, inquiry, context);
    if(mounted){
      setState(() {
        inquiryData = fetchedInquiryListData;
      });
    }
    isLoading=false;
  }


  // Method to load feedback data
  Future <FeedbackModel?> loadFeedBackListData(String inquiryId ) async{
    FeedbackModel? fetchedFeedbackListData = await fetchFeedbackData(inquiryId ,context);
    if(mounted){
      setState(() {
        feedbackData = fetchedFeedbackListData;
      });
    }
    return fetchedFeedbackListData;
  }



  // Method to load Status Data
  Future <void> loadInquiryStatusListData() async{
    InquiryStatusModel? inquiryStatusList = await fetchInquiryStatusList(context);
    if(mounted){
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }
  }



  // Add Inquiry Notification Setting Dialog Box
  void showNotificationSettingsDialog(BuildContext context, String inquiryId, String notificationDay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InquiryNotificationDialog(
          inquiryId: inquiryId,
          notificationDay: notificationDay,
        );
      },
    );

  }


  // Add Inquiry Feedback Dialog Box
  void showFeedbackDialog(BuildContext context, String inquiryId, FeedbackModel? feedbackData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InquiryFeedbackDialog(
          inquiryId: inquiryId,
          feedbackData: feedbackData,
        );
      },
    );
  }

  // Add Status Dialog Box
  void showInquiryStatusDialog(InquiryStatusModel? inquiryList, BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      String selectedId = '';
      String selectedName = '';
      String selectedStatusId = '';

      return StatefulBuilder(
        builder: (context, setState) {
          return CustomDialog(
            title: "Status",
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: inquiryList!.inquiryStatusList!.length,
                      itemBuilder: (context, index) {
                        var status = inquiryList.inquiryStatusList![index];
                        bool isSelected = selectedId == status.id; // Check if selected

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedId = status.id!;
                                selectedName = status.name!;
                                selectedStatusId = status.status!;
                              });
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: isSelected ? preIconFillColor : grey_500,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    status.name!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? preIconFillColor : black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedId.isEmpty) {
                          callSnackBar("Please select a status", "danger");
                          return;
                        }
                        await updateInquiryStatusData(
                            selectedId, selectedStatusId, selectedName, branchId, createdBy, context);

                        Navigator.pop(context);
                        callSnackBar(updationMessage, "success");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bv_primaryDarkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "FIND",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
    );
  }


// Handle Menu Selection
  void handleMenuSelection(int value) async{
    // Show loading dialog
    showLoadingDialog(context);
    // load status list
    await loadInquiryStatusListData();

    // Hide loading dialog when done
    hideLoadingDialog(context);
    showInquiryStatusDialog(inquiryList,context);

  }


  // Updating Filtered Data
  void fetchFilteredInquiryData() async {
    setState(() {
      isLoading = true;
    });

    InquiryModel? fetchedFilteredInquiryData = await FilterInquiryData(
        null, startDateString, endDateString, branchId, null, context
    );


    setState(() {
      inquiryData = fetchedFilteredInquiryData;
      isLoading = false;
    });
  }

  ValueNotifier<bool> isSearching = ValueNotifier(false);
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    return Scaffold(
      backgroundColor: white,
      appBar:
      widgetAppbarForInquiryReport(
        context,
        "Inquiry Report",
        DashboardPage(),
            (menuValue) {
          handleMenuSelection(menuValue);
        },(searchQuery) async {
          InquiryModel? result = await inquirySearchFilter(null, searchQuery, context);
          if (result != null) {
            setState(() {
              inquiryData = result;
            });
          }
        },
            () async{
          await loadinquiryData();
        },
        isSearching, // Pass ValueNotifier
        searchController, // Pass Controller
      ),
      body: Column(
        children: [
          isLoading
              ? Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const InquiryCardSkeleton(),
            ),
          )
              : (inquiryData!.inquiries!.isNotEmpty && inquiryData != null)
              ? Expanded(
            child: ListView.builder(
              itemCount: inquiryData!.inquiries!.length,
              itemBuilder: (context, index) {
                final inquiry = inquiryData!.inquiries![index];
                // Extract course names
                String courseNames = inquiry.courses!.map((course) => course.name).join(", ");
                return GestureDetector(
                  child:
                  InquiryCard(
                    title:  "${inquiry.fname} ${inquiry.lname}",
                    subtitle: courseNames,
                    menuItems: [
                      PopupMenuItem<String>(value: 'call', child: Text(call)),
                      PopupMenuItem<String>(value: 'feedback', child: Text(feedbackHistory)),
                      PopupMenuItem<String>(value: 'settings', child: Text(notificationSettings)),
                      PopupMenuItem<String>(value: 'student', child: Text(convertStudent)),
                    ],
                    onMenuSelected: (value) async {
                      if (value == "call") {
                        makePhoneCall(inquiry.contact!);
                      }
                      else if (value == "feedback") {
                        showLoadingDialog(context);
                        await loadFeedBackListData(inquiry.id.toString());
                        hideLoadingDialog(context);
                        showFeedbackDialog(context,  inquiry.id.toString(), feedbackData);
                      } else if (value == "settings") {
                        showNotificationSettingsDialog(context, inquiry.id.toString(), inquiry.notificationDay!);

                      }
                      else if(value == "student"){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentForm(
                          id: inquiry.id,
                          fname: inquiry.fname,
                          lname: inquiry.lname,
                        )));
                      }
                    },
                  ),
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddInquiryPage(
                      isEdit: true,
                      id: inquiry.id,
                    )));
                  },
                );
              },
            ),
          )
              : DataNotAvailableWidget(message: dataNotAvailable)
        ],
      ),
      floatingActionButton: CustomSpeedDial(
        onCalendarTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: preIconFillColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Select Date Range',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
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
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          isLoading = true;
                        });
                        if (mounted) {
                          setState(() {
                            fetchFilteredInquiryData();
                          });
                        }
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        onFilterTap: () {
          List<int?> selectedCourseIds = [];
          showDynamicCheckboxDialog(
            context,
                (selectedCourses) async{
               selectedCourseIds = selectedCourses.courses!
                  .where((c) => c.isChecked == true)
                  .map((c) => c.id)
                  .toList();
              String selectedCourseIdsString = selectedCourseIds.join(",");
              InquiryModel? filteredData = await FilterInquiryData(selectedCourseIdsString, null, null, null, null, context);
              setState(() {
                inquiryData = filteredData;
              });

            },
            courseProvider.course,
            () {
              // Reset all checkboxes on cancel
              for (var course in courseProvider.course!.courses!) {
                course.isChecked = false;
              }
              setState(() {});
              loadinquiryData();
            },
          );
        },

        backgroundColor: preIconFillColor,
        iconColor: Colors.black,
        iconSize: 25.0,
      ),
    );
  }
}
