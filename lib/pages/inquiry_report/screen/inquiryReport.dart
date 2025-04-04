import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/inquiry/screen/AddInquiryPage.dart';
import 'package:inquirymanagement/pages/inquiry/screen/AddInquiryPage3.dart';
import 'package:inquirymanagement/pages/inquiry_report/components/inquiryCardSkeleton.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/utils/lists.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/color.dart';
import '../../../common/text.dart';
import '../../../components/customCalender.dart';
import '../../../components/customDialog.dart';
import '../../../components/dateRangeComponent.dart';
import '../../../components/feedbackDialog.dart';
import '../../../components/notificationSettingsDialog.dart';
import '../../../components/referenceDialog.dart';
import '../../../components/statusDialog.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/urlLauncherMethods.dart';
import '../../course/components/showDynamicCheckboxDialog.dart';
import '../../course/provider/CourseProvider.dart';
import '../../dashboard/screen/dashboard.dart';
import '../../notification/apicall/feedbackApi.dart';
import '../../notification/apicall/inquiryStatusListApi.dart';
import '../../notification/model/feedbackModel.dart';
import '../../notification/model/inquiryStatusListModel.dart';
import '../../students/screen/StudentForm.dart';
import '../apicall/inquiryApiPagination.dart';
import '../apicall/inquiryFilterApi.dart';
import '../apicall/inquirySearchFilter.dart';
import '../components/appBar.dart';
import '../components/inquiryCard.dart';

class InquiryReportPage extends StatefulWidget {
  const InquiryReportPage({super.key});

  @override
  State<InquiryReportPage> createState() => _InquiryReportPageState();
}

class _InquiryReportPageState extends State<InquiryReportPage> {
  String selectedReference = '';
  String selectedStatus = '';
  String? selectedStatusName = null;
  String? courseStringIds = null;
  ScrollController scrollController = ScrollController();
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  bool isLoading = true;
  InquiryModel? inquiryData;
  List<Inquiries> inquiryListModel = [];
  FeedbackModel? feedbackData;
  InquiryStatusModel? inquiryList;
  InquiryModel? filteredInquiryData,
      inquirySearchedData,
      fetchedFilteredInquiryData;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay, _rangeStart, _rangeEnd;
  String? startDateString, endDateString, date;
  bool isLoadPagination = false;
  int limit = 20;
  int totalCount = 0;
  int page = 1;
  bool forPagination = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (inquiryListModel.length < totalCount) {
          isLoadPagination = true;
          page += 1;
          forPagination = true;
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
      date = _selectedDay != null ? formatDate(_selectedDay!) : "";
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
  Future<void> loadInquiryData() async {
    if(!forPagination){
      inquiryListModel.clear();
    }
    forPagination = false;

    InquiryModel? fetchedInquiryListData = await fetchInquiryDataPagination(
        branchId, null, notInStatus, context, page, limit);
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
            inquiryId: inquiryId, feedbackData: feedbackData);
      },
    );
  }

  /// Add Inquiry Status Dialog Box
  void showInquiryStatusDialog(
      BuildContext context, InquiryStatusModel? inquiryList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InquiryStatusDialog(
            selectedStatus: selectedStatus,
            isInquiryReport: true,
            inquiryList: inquiryList,
            onPressed: (String selectedId, String selectedStatusId,
                String selectedName) async {
              setState(() {
                selectedStatusName = selectedName;
                selectedStatus = selectedId;
                inquiryListModel.clear();
                isLoading = true;
              });

              InquiryModel? fetchedFilteredInquiryData =
                  await FilterInquiryData(null, null, null, branchId,
                      selectedName, null, null, context);

              if (fetchedFilteredInquiryData != null) {
                fetchedFilteredInquiryData.inquiries?.forEach((e) {
                  inquiryListModel.add(e);
                });
              }
              callSnackBar("Inquiry fetched successfully!", "success");

              setState(() {
                isLoading = false;
              });
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
          selectedReference: selectedReference,
          onPressed: (String selectedName) async {
            InquiryModel? filteredDataForReference = await FilterInquiryData(
                null,
                null,
                null,
                branchId,
                selectedStatusName,
                selectedName,
                null,
                context);

            setState(() {
              inquiryListModel.clear();
              selectedReference = selectedName;
            });

            if (filteredDataForReference != null) {
              filteredDataForReference.inquiries?.forEach((e) {
                inquiryListModel.add(e);
              });
              callSnackBar("Inquiry fetched successfully!", "success");
            }
          },
        );
      },
    );
  }

// Handle Menu Selection
  void handleMenuSelection(int value, CourseProvider courseProvider) async {
    // Show loading dialog
    switch (value) {
      case 1:
        showLoadingDialog(context);
        await loadInquiryStatusListData();
        hideLoadingDialog(context);
        showInquiryStatusDialog(context, inquiryList);
      case 4:
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
              },
              onCancel: () {
                _rangeStart = null;
                _rangeEnd = null;
                loadInquiryData();
              },
            );
          },
        );
      case 3:
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
              courseStringIds = selectedCourseIdsString;
              inquiryListModel.clear();
            });

            InquiryModel? filteredData = await FilterInquiryData(
                selectedCourseIdsString,
                null,
                null,
                branchId,
                selectedStatusName,
                selectedReference,
                null,
                context);

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
            loadInquiryData();
          },
        );
      case 2:
        showInquiryReferenceDialog(context);
    }
  }

  // Updating Filtered Data
  void fetchFilteredInquiryData() async {
    setState(() {
      isLoading = true;
    });
    InquiryModel? fetchedFilteredInquiryData;
    if (endDateString!.isEmpty) {
      fetchedFilteredInquiryData = await FilterInquiryData(
          courseStringIds,
          null,
          null,
          branchId,
          selectedStatusName,
          selectedReference,
          startDateString,
          context);
    } else {
      fetchedFilteredInquiryData = await FilterInquiryData(
          courseStringIds,
          startDateString,
          endDateString,
          branchId,
          selectedStatusName,
          selectedReference,
          null,
          context);
    }
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

  Future<void> callApiCommon() async {
    InquiryModel? fetchedFilteredInquiryData;
    if (endDateString != null && endDateString!.isEmpty) {
      fetchedFilteredInquiryData = await FilterInquiryData(
          courseStringIds,
          null,
          null,
          branchId,
          selectedStatusName,
          selectedReference,
          startDateString,
          context);
    } else {
      fetchedFilteredInquiryData = await FilterInquiryData(
          courseStringIds,
          startDateString,
          endDateString,
          branchId,
          selectedStatusName,
          selectedReference,
          null,
          context);
    }

    setState(() {
      inquiryListModel.clear();
    });

    if (fetchedFilteredInquiryData != null) {
      fetchedFilteredInquiryData.inquiries?.forEach((e) {
        inquiryListModel.add(e);
      });
    }

    setState(() {});
  }

  ValueNotifier<bool> isSearching = ValueNotifier(false);
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForInquiryReport(
          context, "Inquiry Report", DashboardPage(), (menuValue) {
        handleMenuSelection(menuValue, courseProvider);
      }, (searchQuery) async {
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
      }, () async {
        inquiryListModel.clear();
        page = 1;
        setState(() {});
        await loadInquiryData();
      }, isSearching, searchController),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            child: Row(
              children: [
                if (selectedStatus != "" && selectedStatusName != null)
                  FilterChipWidget(
                    filterText: selectedStatusName ?? "Status",
                    onRemove: () async {
                      setState(() {
                        selectedStatusName = null;
                        selectedStatus = "";
                      });
                      callApiCommon();
                    },
                  ),
                if (selectedReference != "")
                  FilterChipWidget(
                    filterText: selectedReference,
                    onRemove: () {
                      setState(() {
                        selectedReference = "";
                      });
                      callApiCommon();
                    },
                  ),
                if (courseStringIds != null)
                  FilterChipWidget(
                    filterText: "Course Filter Apply",
                    onRemove: () {
                      setState(() {
                        courseStringIds = null;
                      });
                      callApiCommon();
                    },
                  ),
                if (endDateString != null || startDateString != null)
                  FilterChipWidget(
                    filterText: endDateString == null || endDateString == ""
                        ? "Date - $startDateString"
                        : "Date - $startDateString - $endDateString",
                    onRemove: () {
                      setState(() {
                        endDateString = null;
                        startDateString = null;
                      });
                      callApiCommon();
                    },
                  ),
              ],
            ),
          ),
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

                          /// Extract course names
                          String courseNames = inquiry.courses!
                              .map((course) => course.name)
                              .join(", ");
                          return GestureDetector(
                            child: InquiryCard(
                              status: inquiry.status!,
                              title:
                                  "${inquiry.fname ?? ''} ${inquiry.lname ?? ''}",
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
                                                inquiry: inquiry,
                                              )));
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddInquiryPage(
                                            inquiry: inquiry,
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
      // floatingActionButton: CustomSpeedDial(
      //   /// Date Filter
      //   onCalendarTap: () {
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return DateRangeDialog(
      //           widget: Align(
      //             alignment: Alignment.center,
      //             child: SizedBox(
      //               width: 600,
      //               height: 400,
      //               child: CustomCalendar(
      //                 initialFormat: _calendarFormat,
      //                 initialFocusedDay: _focusedDay,
      //                 initialSelectedDay: _selectedDay,
      //                 initialRangeStart: _rangeStart,
      //                 initialRangeEnd: _rangeEnd,
      //                 onDaySelected: _onDaySelected,
      //                 onRangeSelected: _onRangeSelected,
      //               ),
      //             ),
      //           ),
      //           filterInquiriesByDate: () {
      //             Navigator.pop(context);
      //             setState(() {
      //               isLoading = true;
      //             });
      //             if (mounted) {
      //               setState(() {
      //                 fetchFilteredInquiryData();
      //               });
      //             }
      //           },
      //           onCancel: () {
      //             _rangeStart = null;
      //             _rangeEnd = null;
      //             loadInquiryData();
      //           },
      //         );
      //       },
      //     );
      //   },
      //
      //   /// Course Filter
      //   onFilterTap: () {
      //     List<int?> selectedCourseIds = [];
      //     showDynamicCheckboxDialog(
      //       context,
      //       (selectedCourses) async {
      //         selectedCourseIds = selectedCourses.courses!
      //             .where((c) => c.isChecked == true)
      //             .map((c) => int.parse(c.id ?? "0"))
      //             .toList();
      //         String selectedCourseIdsString = selectedCourseIds.join(",");
      //         setState(() {
      //           inquiryListModel.clear();
      //         });
      //
      //         InquiryModel? filteredData = await FilterInquiryData(
      //             selectedCourseIdsString,
      //             null,
      //             null,
      //             branchId,
      //             null,
      //             null,
      //             null,
      //             context);
      //
      //         if (filteredData != null) {
      //           filteredData.inquiries?.forEach((e) {
      //             inquiryListModel.add(e);
      //           });
      //         }
      //         setState(() {
      //           inquiryData = filteredData;
      //         });
      //       },
      //       courseProvider.course,
      //       () {
      //         loadInquiryData();
      //       },
      //     );
      //   },
      //
      //   /// Reference Filter
      //   onReferenceTap: () {
      //     showInquiryReferenceDialog(context);
      //   },
      //   backgroundColor: preIconFillColor,
      //   iconColor: Colors.white,
      //   iconSize: 25.0,
      // ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String filterText;
  final VoidCallback onRemove;

  const FilterChipWidget({
    Key? key,
    required this.filterText,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filterText,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.cancel,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
