import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/inquiry_report/components/inquiryCard.dart';
import 'package:inquirymanagement/pages/notification/apicall/inquiryStatusListApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/notificationApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/updateUpcomingDate.dart';
import 'package:inquirymanagement/components/feedbackDialog.dart';
import 'package:inquirymanagement/pages/notification/components/notificationCardSkeleton.dart';
import 'package:inquirymanagement/components/notificationSettingsDialog.dart';
import 'package:inquirymanagement/components/statusDialog.dart';
import 'package:inquirymanagement/pages/notification/model/inquiryStatusListModel.dart';
import 'package:inquirymanagement/pages/notification/model/notificationModel.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';
import '../../../common/text.dart';
import '../../../components/appBar.dart';
import '../apicall/feedbackApi.dart';
import '../apicall/updateInquiryStatus.dart';
import '../../../components/upcomingDateDialog.dart';
import '../model/feedbackModel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  List<Inquiries> notifications = [];
  bool isLoading = true;
  FeedbackModel? feedbackData;
  InquiryStatusModel? inquiryList;
  TextEditingController feedbackController = TextEditingController();
  bool isLoadPagination = false;
  int limit = 20;
  int totalCount = 0;
  int page = 1;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    loadNotificationData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (totalCount > notifications.length) {
          isLoadPagination = true;
          page += 1;
          loadNotificationData();
          setState(() {});
        }
      }
    });
  }

  // Method to load notification data (Initial & Pagination)
  Future<void> loadNotificationData() async {
    NotificationModel? fetchedNotificationData =
        await fetchNotificationData(branchId, context, page, limit);

    if (mounted) {
      setState(() {
        if (fetchedNotificationData != null &&
            fetchedNotificationData.inquiries!.isNotEmpty) {
          if (fetchedNotificationData.status == success) {
            notifications.addAll(fetchedNotificationData.inquiries!);
            totalCount = fetchedNotificationData.count!;
          }
        }

        isLoading = false;
        isLoadPagination = false;
      });
    }
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

  // Method to update upcoming date
  Future<void> loadInquiryStatusListData() async {
    InquiryStatusModel? inquiryStatusList =
        await fetchInquiryStatusList(context);
    if (mounted) {
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }
  }

  // Add Inquiry Notification Dialog Box
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

  // Add Upcoming Date Dialog Box
  void showUpcomingDateDialog(
      BuildContext context, String inquiryDate, String inquiryId,
      Function(String inquiryId, String date, String branchId,
          String createdBy) callBack
      ) {

  }

  // Add Inquiry Status Dialog Box
  void showInquiryStatusDialog(
      BuildContext context,
      InquiryStatusModel? inquiryList,
      String? inquiryId,
      Function(String selectedId, String selectedStatusId, String selectedName)
          onStatusUpdate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InquiryStatusDialog(
          inquiryList: inquiryList,
          onPressed: (String selectedId, String selectedStatusId,
              String selectedName) async {
            await onStatusUpdate(selectedId, selectedStatusId, selectedName);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (Route<dynamic> route) => false, // Removes all previous routes
        );
      },
      child: Scaffold(
        backgroundColor: white,
        appBar:
        customPageAppBar(context, "Notifications", DashboardPage()),
        body: Column(
          children: [
            isLoading
                ? Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) =>
                          const NotificationCardSkeleton(),
                    ),
                  )
                : (notifications.isNotEmpty)
                    ? Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            // Extract course names
                            String courseNames = notification.courses!
                                .map((course) => course.name)
                                .join(", ");
                            return InquiryNotificationCard(
                              title:
                                  "${notification.fname ?? ""} ${notification.lname ?? ""}",
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
                              ],
                              onMenuSelected: (value) async {
                                if (value == "call") {
                                  makePhoneCall(notification.contact ?? "");
                                } else if (value == "settings") {
                                  showNotificationSettingsDialog(
                                      context,
                                      notification.id.toString(),
                                      notification.notificationDay ??
                                          "unknown");
                                } else if (value == "feedback") {
                                  showLoadingDialog(context);
                                  await loadFeedBackListData(
                                      notification.id.toString());
                                  hideLoadingDialog(context);
                                  showFeedbackDialog(context,
                                      notification.id.toString(), feedbackData);
                                } else if (value == "date") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpcomingDateDialog(
                                        inquiryDate: notification.inquiryDate ?? "unknown",
                                        inquiryId: notification.id.toString(),
                                        updateDate: (String inquiryId, String date, String branchId,
                                            String createdBy) async {
                                          var data = await UpdateUpcomingDate(inquiryId, date, branchId, createdBy, context);
                                          if(data != null && data.status == success){
                                            setState(() {
                                              notifications.removeAt(index);
                                            });
                                            callSnackBar(data.message.toString(), success);
                                          }else{
                                            callSnackBar("Unknown Error", danger);
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else if (value == "status") {
                                  showLoadingDialog(context);
                                  await loadInquiryStatusListData();
                                  hideLoadingDialog(context);
                                  showInquiryStatusDialog(
                                    context,
                                    inquiryList,
                                    notification.id.toString(),
                                    (String selectedId, String selectedStatusId,
                                        String selectedName) async {
                                      var data = await updateInquiryStatusData(
                                        notification.id.toString(),
                                        selectedId,
                                        selectedName,
                                        branchId,
                                        createdBy,
                                        context,
                                      );

                                      if ("Inquiry" == selectedName) {
                                        if (data != null &&
                                            data.status == success) {
                                          callSnackBar(
                                              updationMessage, success);
                                        }
                                        return;
                                      }

                                      if (data != null &&
                                          data.status == success) {
                                        setState(() {
                                          notifications.removeAt(index);
                                        });
                                        callSnackBar(updationMessage, success);
                                      } else {
                                        callSnackBar(
                                            "Error While Delete Message",
                                            danger);
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Center(
                            child: DataNotAvailableWidget(
                                message: dataNotAvailable)),
                      ),
            if (isLoadPagination)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  // Loading Indicator
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
