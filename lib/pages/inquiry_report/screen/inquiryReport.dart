import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/inquiry/screen/AddInquiryPage.dart';
import 'package:inquirymanagement/pages/inquiry_report/apicall/inquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry_report/components/inquiryCardSkeleton.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/color.dart';
import '../../../common/text.dart';
import '../../../components/appBar.dart';
import '../../../components/customCalender.dart';
import '../../../components/customDialog.dart';
import '../../../components/dateRangeComponent.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/urlLauncherMethods.dart';
import '../../course/components/showDynamicCheckboxDialog.dart';
import '../../course/provider/CourseProvider.dart';
import '../../dashboard/screen/dashboard.dart';
import '../../notification/apicall/feedbackApi.dart';
import '../../notification/apicall/inquiryStatusListApi.dart';
import '../../notification/apicall/updateInquiryStatus.dart';
import '../../notification/components/customDialogBox.dart';
import '../../notification/components/feedbackDialog.dart';
import '../../notification/components/notificationSettingsDialog.dart';
import '../../notification/model/feedbackModel.dart';
import '../../notification/model/inquiryStatusListModel.dart';
import '../../students/screen/StudentForm.dart';
import '../apicall/inquiryApiPagination.dart';
import '../apicall/inquiryFilterApi.dart';
import '../apicall/inquirySearchFilter.dart';
import '../components/inquiryCard.dart';

class InquiryReportPage extends StatefulWidget {
  const InquiryReportPage({super.key});

  @override
  State<InquiryReportPage> createState() => _InquiryReportPageState();
}

class _InquiryReportPageState extends State<InquiryReportPage> {
  ScrollController scrollController = ScrollController();
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  bool isLoading = true;
  InquiryModel? inquiryData;
  List<Inquiries> inquiryListModel = [];
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
  bool isLoadPagination = false;
  int limit = 20;
  int totalCount = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (inquiryListModel.length < totalCount) {
          isLoadPagination = true;
          page += 1;
          loadInquiryData();
          setState(() {});
        }
      }
    });

    Future.microtask(() {
      Provider.of<CourseProvider>(context, listen: false).getCourse(context);
    });
    _selectedDay = _focusedDay;
    loadInquiryData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
  Future<InquiryModel?> loadInquiryData() async {
    InquiryModel? fetchedInquiryListData = await fetchInquiryDataPagination(
        branchId, inquiry, context, page, limit);
    if (mounted) {
      if (fetchedInquiryListData != null &&
          fetchedInquiryListData.status == success) {
        fetchedInquiryListData.inquiries?.forEach((e) {
          inquiryListModel.add(e);
        });
      }

      setState(() {
        isLoadPagination = false;
        // inquiryData = fetchedInquiryListData;
        totalCount = fetchedInquiryListData?.count ?? 0;
      });
    }
    isLoading = false;
  }

  // Method to load feedback data
  Future<FeedbackModel?> loadFeedBackListData(String inquiryId) async {
    FeedbackModel? fetchedFeedbackListData =
        await fetchFeedbackData(inquiryId, context);
    if (mounted) {
      setState(() {
        feedbackData = fetchedFeedbackListData;
      });
    }
    return fetchedFeedbackListData;
  }

  // Method to load Status Data
  Future<void> loadInquiryStatusListData() async {
    InquiryStatusModel? inquiryStatusList =
        await fetchInquiryStatusList(context);
    if (mounted) {
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }
  }

  // Add Inquiry Notification Setting Dialog Box
  void showNotificationSettingsDialog(
      BuildContext context, String inquiryId, String notificationDay) {
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
  void showFeedbackDialog(
      BuildContext context, String inquiryId, FeedbackModel? feedbackData) {
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
  void showInquiryStatusDialog(
      InquiryStatusModel? inquiryList, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                          bool isSelected =
                              selectedId == status.id; // Check if selected
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 15),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? preIconFillColor
                                          : grey_500,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      status.name!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? preIconFillColor
                                            : black,
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
                    // if (isLoad)
                    //   CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedId.isEmpty) {
                            callSnackBar("Please select a status", danger);
                            return;
                          }
                          setState(() {
                            inquiryListModel.clear();
                          });
                          InquiryModel? fetchedFilteredInquiryData =
                              await FilterInquiryData(null, null, null,
                                  branchId, selectedName, context);

                          if (fetchedFilteredInquiryData != null) {
                            fetchedFilteredInquiryData.inquiries?.forEach((e) {
                              inquiryListModel.add(e);
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                          // await updateInquiryStatusData(
                          //     selectedId,
                          //     selectedStatusId,
                          //     selectedName,
                          //     branchId,
                          //     createdBy,
                          //     context);

                          Navigator.pop(context);
                          callSnackBar(
                              fetchedFilteredInquiryData!.message ??
                                  "Error While fetch Data",
                              fetchedFilteredInquiryData.status ?? "info");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bv_primaryDarkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "FIND",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
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
  void handleMenuSelection(int value) async {
    // Show loading dialog
    showLoadingDialog(context);
    // load status list
    await loadInquiryStatusListData();

    // Hide loading dialog when done
    hideLoadingDialog(context);
    showInquiryStatusDialog(inquiryList, context);
  }

  // Updating Filtered Data
  void fetchFilteredInquiryData() async {
    setState(() {
      isLoading = true;
    });
    InquiryModel? fetchedFilteredInquiryData = await FilterInquiryData(
        null, startDateString, endDateString, branchId, null, context);
    setState(() {
      inquiryListModel.clear();
    });
    if (fetchedFilteredInquiryData != null) {
      fetchedFilteredInquiryData.inquiries?.forEach((e) {
        inquiryListModel.add(e);
      });
    }
    setState(() {
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
      appBar: widgetAppbarForInquiryReport(
        context,
        "Inquiry Report",
        DashboardPage(),
        (menuValue) {
          handleMenuSelection(menuValue);
        },
        (searchQuery) async {
          if (searchQuery != "") {
            InquiryModel? result =
                await inquirySearchFilter(null, searchQuery, context, branchId);
            if (result != null) {
              if (result.status == success) {
                inquiryListModel.clear();
                setState(() {
                  result.inquiries?.forEach((e) {
                    inquiryListModel.add(e);
                  });
                });
              }
            }
          }
        },
        () async {
          inquiryListModel.clear();
          page = 1;
          setState(() {});
          await loadInquiryData();
        },
        isSearching,
        searchController,
      ),
      body: Column(
        children: [
          isLoading
              ? Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        const InquiryCardSkeleton(),
                  ),
                )
              : (inquiryListModel.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: inquiryListModel.length,
                        itemBuilder: (context, index) {
                          final inquiry = inquiryListModel[index];
                          // Extract course names
                          String courseNames = inquiry.courses!
                              .map((course) => course.name)
                              .join(", ");
                          return GestureDetector(
                            child: InquiryCard(
                              title: "${inquiry.fname} ${inquiry.lname}",
                              subtitle: courseNames,
                              menuItems: [
                                PopupMenuItem<String>(
                                    value: 'call', child: Text(call)),
                                PopupMenuItem<String>(
                                    value: 'feedback',
                                    child: Text(feedbackHistory)),
                                PopupMenuItem<String>(
                                    value: 'settings',
                                    child: Text(notificationSettings)),
                                PopupMenuItem<String>(
                                    value: 'student',
                                    child: Text(convertStudent)),
                              ],
                              onMenuSelected: (value) async {
                                if (value == "call") {
                                  makePhoneCall(inquiry.contact!);
                                } else if (value == "feedback") {
                                  showLoadingDialog(context);
                                  await loadFeedBackListData(
                                      inquiry.id.toString());
                                  hideLoadingDialog(context);
                                  showFeedbackDialog(context,
                                      inquiry.id.toString(), feedbackData);
                                } else if (value == "settings") {
                                  showNotificationSettingsDialog(
                                      context,
                                      inquiry.id.toString(),
                                      inquiry.notificationDay!);
                                } else if (value == "student") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StudentForm(
                                                id: inquiry.id,
                                                fname: inquiry.fname,
                                                lname: inquiry.lname,
                                              )));
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddInquiryPage(
                                            isEdit: true,
                                            id: inquiry.id,
                                          )));
                            },
                          );
                        },
                      ),
                    )
                  : DataNotAvailableWidget(message: dataNotAvailable),
          if (isLoadPagination)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: grey_400,
                  strokeWidth: 2.0,
                ),
              ),
            )
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
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });
                    if (mounted) {
                      setState(() {
                        fetchFilteredInquiryData();
                      });
                    }
                  });
            },
          );
        },

        /// Course Filter
        onFilterTap: () {
          List<int?> selectedCourseIds = [];
          showDynamicCheckboxDialog(
            context,
            (selectedCourses) async {
              selectedCourseIds = selectedCourses.courses!
                  .where((c) => c.isChecked == true)
                  .map((c) => c.id)
                  .toList();
              String selectedCourseIdsString = selectedCourseIds.join(",");

              setState(() {
                inquiryListModel.clear();
              });

              InquiryModel? filteredData = await FilterInquiryData(
                  selectedCourseIdsString, null, null, branchId, null, context);

              if (filteredData != null) {
                filteredData.inquiries?.forEach((e) {
                  inquiryListModel.add(e);
                });
              }
              setState(() {
                inquiryData = filteredData;
              });
            },
            courseProvider.course,
            () {
              for (var course in courseProvider.course!.courses!) {
                course.isChecked = false;
              }
              setState(() {});
              loadInquiryData();
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
