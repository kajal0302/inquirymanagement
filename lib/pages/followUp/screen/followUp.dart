import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/followUp/apiCall/upcomingInquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/pages/notification/apicall/updateUpcomingDate.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/customCalender.dart';
import '../../../components/dateRangeComponent.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/urlLauncherMethods.dart';
import '../../course/components/showDynamicCheckboxDialog.dart';
import '../../course/provider/CourseProvider.dart';
import '../../dashboard/screen/dashboard.dart';
import '../../inquiry_report/apicall/inquiryFilterApi.dart';
import '../../inquiry_report/components/inquiryCard.dart';
import '../../notification/apicall/feedbackApi.dart';
import '../../notification/apicall/inquiryStatusListApi.dart';
import '../../notification/apicall/notificationApi.dart';
import '../../notification/apicall/updateInquiryStatus.dart';
import '../../../components/feedbackDialog.dart';
import '../../notification/components/notificationCardSkeleton.dart';
import '../../../components/notificationSettingsDialog.dart';
import '../../../components/statusDialog.dart';
import '../../../components/upcomingDateDialog.dart';
import '../../notification/model/feedbackModel.dart';
import '../../notification/model/inquiryStatusListModel.dart';
import '../../notification/model/notificationModel.dart';
import '../../students/screen/StudentForm.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key});

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? selectedCourseIdsStringCommon = null;
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  InquiryModel? inquiryData;
  InquiryStatusModel? inquiryList;
  FeedbackModel? feedbackData;
  bool isLoading = true;
  int index = 0;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay, _rangeEnd, _rangeStart;
  String? startDateString, endDateString;
  NotificationModel? notification;
  bool? isFollowUp = true;
  String count = userBox.get(countHiv) ?? "0";

  @override
  void initState() {
    super.initState();
    loadNotificationData();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    fetchUpcomingInquiryByTab(index);
    Future.microtask(() {
      Provider.of<CourseProvider>(context, listen: false).getCourse(context);
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      fetchUpcomingInquiryByTab(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  // Method to load notification data
  Future<void> loadNotificationData() async {
    NotificationModel? fetchedNotificationData =
        await fetchNotificationCount(branchId, "fallup");

    if (fetchedNotificationData != null) {
      count = fetchedNotificationData.count.toString();
    }

    if (mounted) {
      setState(() {
        userBox.put(countHiv, count);
      });
    }
  }

  /// Method to load feedback data
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

  /// Method to update upcoming date
  Future<void> loadInquiryStatusListData() async {
    InquiryStatusModel? inquiryStatusList =
        await fetchInquiryStatusList(context);
    if (mounted) {
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }
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

  /// Updating Filtered Data
  void fetchFilteredInquiryData() async {
    setState(() {
      isLoading = true;
    });
    InquiryModel? fetchedFilteredInquiryData;
    if (endDateString != null && endDateString!.isEmpty) {
      fetchedFilteredInquiryData = await FilterInquiryData(
          selectedCourseIdsStringCommon, null, null, branchId, null, null, startDateString, context);
    } else {
      fetchedFilteredInquiryData = await FilterInquiryData(selectedCourseIdsStringCommon,
          startDateString, endDateString, branchId, null, null, null, context);
    }

    setState(() {
      inquiryData = fetchedFilteredInquiryData;
      isLoading = false;
    });
  }

  /// Method to fetch  inquiry Data a/c to tabType
  Future<void> fetchUpcomingInquiry(String tabType) async {
    String? selectedToday;
    String? selectedTomorrow;
    String? selectedSevenDays;

    setState(() {
      inquiryData = null;
    });

    if (tabType == 'today') {
      selectedToday = "1";
    } else if (tabType == 'tomorrow') {
      selectedTomorrow = "1";
    } else  if (tabType == 'sevenDays'){
      selectedSevenDays = "1";
    }else{
      fetchFilteredInquiryData();
      return;
    }


    InquiryModel? fetchedInquiryData = await fetchUpcomingInquiryData(
      "",
      selectedToday,
      selectedTomorrow,
      selectedSevenDays,
      branchId,
      context,
    );

    if (mounted) {
      setState(() {
        inquiryData = fetchedInquiryData;
        isLoading = false;
      });
    }
  }

  void fetchUpcomingInquiryByTab(index) async {
    if (index == 0) {
      fetchUpcomingInquiry('today');
    } else if (index == 1) {
      fetchUpcomingInquiry('tomorrow');
    } else if (index == 2) {
      fetchUpcomingInquiry('sevenDays');
    } else {
      setState(() {
        inquiryData = null;
      });
      InquiryModel? filteredData = await FilterInquiryData(
          null, null, null, branchId, null, null, null, context);
      setState(() {
        inquiryData = filteredData;
      });
    }
  }

  /// Add Inquiry Notification Setting Dialog Box
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

  /// Add Inquiry Feedback Dialog Box
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

  /// Add Upcoming Date Dialog Box
  void showUpcomingDateDialog(
      BuildContext context, String inquiryDate, String inquiryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpcomingDateDialog(
          inquiryDate: inquiryDate,
          inquiryId: inquiryId,
          updateDate: (String inquiryId, String date, String branchId,
              String createdBy) async {
            var data = await UpdateUpcomingDate(
                inquiryId, date, branchId, createdBy, context);
            if (data != null && data.status == success) {
              callSnackBar(data.message.toString(), success);
            } else {
              callSnackBar("Unknown Error", danger);
            }
          },
        );
      },
    );
  }

  /// Add Inquiry Status Dialog Box
  void showInquiryStatusDialog(
      BuildContext context, InquiryStatusModel? inquiryList, String inquiryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InquiryStatusDialog(
          inquiryList: inquiryList,
          onPressed: (String selectedId, String selectedStatusId,
              String selectedName) async {
            await updateInquiryStatusData(
              inquiryId,
              selectedId,
              selectedName,
              branchId,
              createdBy,
              context,
            );
            callSnackBar(updationMessage, "success");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    return DefaultTabController(
      length: 4,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
                (Route<dynamic> route) =>
            false, /// This removes all the previous routes
          );
        },
        child: Scaffold(
          backgroundColor: white,
          appBar: widgetAppBar(
            context,
            "Follow Up",
            count,
            false,
            bottom: TabBar(
              controller: _tabController,
              labelColor: white,
              unselectedLabelColor: grey_400,
              // Inactive tab color
              indicatorColor: white,
              // Underline indicator
              indicatorWeight: 0.1,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: px12,
                fontWeight: FontWeight.normal,
              ),
              onTap: (index) {
                fetchUpcomingInquiryByTab(index);
              },
              tabs: [
                Tab(
                  child: Text("Today"),
                ),
                Tab(
                  child: Text("Tomorrow"),
                ),
                Tab(
                  child: Text("Within 7 Days"),
                ),
                Tab(child: Icon(Icons.calendar_month))
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              buildInquiryList(),
              buildInquiryList(),
              buildInquiryList(),
              buildInquiryList(),
            ],
          ),
          floatingActionButton: Builder(
            builder: (context) {
              int selectedIndex = _tabController.index ?? 0;
              return selectedIndex == 3
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          backgroundColor: preIconFillColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DateRangeDialog(
                                  widget: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 650,
                                      height: 340,
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
                                  },
                                  onCancel: () {
                                    // _rangeStart = null;
                                    // _rangeEnd = null;
                                    // fetchUpcomingInquiryByTab(selectedIndex);
                                  },
                                );
                              },
                            );
                          },
                          child: Icon(Icons.calendar_today_outlined,
                              color: white, size: 28),
                        ),
                        SizedBox(height: 16),
                        FloatingActionButton(
                          backgroundColor: preIconFillColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () {
                            List<int?> selectedCourseIds = [];
                            showDynamicCheckboxDialog(
                              context,
                              (selectedCourses) async {
                                selectedCourseIds = selectedCourses.courses!
                                    .where((c) => c.isChecked == true)
                                    .map((c) => int.parse(c.id ?? "0"))
                                    .toList();
                                String selectedCourseIdsString = selectedCourseIds.join(",");

                                setState(() {
                                  selectedCourseIdsStringCommon = selectedCourseIdsString;
                                });

                                String? today,tomorrow,sevenDays;
                                if(_tabController.index == 0){
                                  today="1";
                                }else if(_tabController.index == 1){
                                  tomorrow="1";
                                }else if(_tabController.index == 2){
                                  sevenDays="1";
                                }else{
                                  fetchFilteredInquiryData();
                                  return;
                                }
                                InquiryModel? fetchedInquiryData = await fetchUpcomingInquiryData(
                                  selectedCourseIdsString,
                                  today,
                                  tomorrow,
                                  sevenDays,
                                  branchId,
                                  context);

                                // InquiryModel? filteredData =
                                //     await FilterInquiryData(
                                //         selectedCourseIdsString,
                                //         null,
                                //         null,
                                //         branchId,
                                //         null,
                                //         null,
                                //         null,
                                //         context);
                                //here
                                setState(() {
                                  inquiryData = fetchedInquiryData;
                                });
                              },
                              courseProvider.course,
                              () {
                                fetchUpcomingInquiryByTab(selectedIndex);
                              },
                            );
                          },
                          child: Icon(Icons.filter_list, color: white, size: 28),
                        ),
                      ],
                    )
                  : FloatingActionButton(
                      backgroundColor: preIconFillColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        List<int?> selectedCourseIds = [];
                        showDynamicCheckboxDialog(
                          context,
                          (selectedCourses) async {
                            selectedCourseIds = selectedCourses.courses!
                                .where((c) => c.isChecked == true)
                                .map((c) => int.parse(c.id ?? "0"))
                                .toList();

                            String selectedCourseIdsString =
                                selectedCourseIds.join(",");

                            String? today,tomorrow,sevenDays;
                            if(_tabController.index == 0){
                              today="1";
                            }else if(_tabController.index == 1){
                              tomorrow="1";
                            }else if(_tabController.index == 2){
                              sevenDays="1";
                            }else{
                              fetchFilteredInquiryData();
                              return;
                            }
                            InquiryModel? fetchedInquiryData = await fetchUpcomingInquiryData(
                                selectedCourseIdsString,
                                today,
                                tomorrow,
                                sevenDays,
                                branchId,
                                context);

                            // InquiryModel? filteredData = await FilterInquiryData(
                            //     selectedCourseIdsString,
                            //     null,
                            //     null,
                            //     branchId,
                            //     null,
                            //     null,
                            //     null,
                            //     context);
                            setState(() {
                              inquiryData = fetchedInquiryData;
                            });
                          },
                          courseProvider.course,
                          () {
                            fetchUpcomingInquiryByTab(selectedIndex);
                          },
                        );
                      },
                      child: Icon(Icons.filter_list, color: white, size: 30),
                    );
            },
          ),
        ),
      ),
    );
  }

  // tabView Widget
  Widget buildInquiryList() {
    return Column(
      children: [
        isLoading
            ? Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) =>
                      const NotificationCardSkeleton(),
                ),
              )
            : (inquiryData?.inquiries?.isNotEmpty ?? false)
                ? Expanded(
                    child: ListView.builder(
                      itemCount: inquiryData?.inquiries?.length ?? 0,
                      itemBuilder: (context, index) {
                        final inquiry = inquiryData?.inquiries?[index];

                        if (inquiry == null) return SizedBox();

                        String courseNames = inquiry.courses
                                ?.map((course) => course.name)
                                .join(", ") ??
                            "No courses available";

                        return InquiryCard(
                          status: inquiry.status!,
                          title:
                              "${inquiry.fname ?? ''} ${inquiry.lname ?? ''}",
                          subtitle: courseNames,
                          menuItems: [
                            PopupMenuItem<String>(
                                value: 'call', child: Text(call)),
                            PopupMenuItem<String>(
                                value: 'settings',
                                child: Text(notificationSettings)),
                            PopupMenuItem<String>(
                                value: 'feedback',
                                child: Text(feedbackHistory)),
                            PopupMenuItem<String>(
                                value: 'date', child: Text(upcomingDate)),
                            PopupMenuItem<String>(
                                value: 'status', child: Text(status)),
                            PopupMenuItem<String>(
                                value: 'student', child: Text(convertStudent)),
                          ],
                          onMenuSelected: (value) async {
                            if (value == "call" && inquiry.contact != null) {
                              makePhoneCall(inquiry.contact!);
                            } else if (value == "settings") {
                              showNotificationSettingsDialog(
                                  context,
                                  inquiry.id.toString(),
                                  inquiry.notificationDay!);
                            } else if (value == "feedback") {
                              showLoadingDialog(context);
                              await loadFeedBackListData(inquiry.id.toString());
                              hideLoadingDialog(context);
                              showFeedbackDialog(
                                  context, inquiry.id.toString(), feedbackData);
                            } else if (value == "date") {
                              showUpcomingDateDialog(context,
                                  inquiry.upcomingConfirmDate!, inquiry.id.toString());
                            } else if (value == "status") {
                              showLoadingDialog(context);
                              await loadInquiryStatusListData();
                              hideLoadingDialog(context);
                              showInquiryStatusDialog(
                                  context, inquiryList, inquiry.id.toString());
                            } else if (value == "student") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentForm(
                                            inquiry: inquiry,
                                            isFollowUp: isFollowUp,
                                          )));
                            }
                          },
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Center(
                        child:
                            DataNotAvailableWidget(message: dataNotAvailable)),
                  ),
      ],
    );
  }
}
