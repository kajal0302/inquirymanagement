import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/inquiry_report/components/inquiryCard.dart';
import 'package:inquirymanagement/pages/notification/apicall/inquiryStatusListApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/notificationApi.dart';
import 'package:inquirymanagement/pages/notification/components/feedbackDialog.dart';
import 'package:inquirymanagement/pages/notification/components/notificationCardSkeleton.dart';
import 'package:inquirymanagement/pages/notification/components/notificationSettingsDialog.dart';
import 'package:inquirymanagement/pages/notification/components/statusDialog.dart';
import 'package:inquirymanagement/pages/notification/model/inquiryStatusListModel.dart';
import 'package:inquirymanagement/pages/notification/model/notificationModel.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';
import '../../../common/text.dart';
import '../../../components/appBar.dart';
import '../apicall/feedbackApi.dart';
import '../components/upcomingDateDialog.dart';
import '../model/feedbackModel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  List<dynamic> notifications = [];
  bool isLoading = true;
  FeedbackModel? feedbackData;
  InquiryStatusModel? inquiryList;
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotificationData();
  }

  /// Method to load notification data
  Future<void> loadNotificationData() async {
    NotificationModel? fetchedNotificationData =
        await fetchNotificationData(branchId, context);
    if (mounted) {
      setState(() {
        if (fetchedNotificationData != null &&
            fetchedNotificationData.inquiries!.isNotEmpty) {
          notifications.addAll(fetchedNotificationData.inquiries!);
        }
        isLoading = false;
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

  /// Add Inquiry Notification Dialog Box
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
        );
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
          inquiryList: inquiryList,
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
            widgetAppbarForAboutPage(context, "Notifications", DashboardPage()),
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
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            /// Extract course names
                            String courseNames = notification.courses!
                                .map((course) => course.name)
                                .join(", ");
                            return InquiryCard(
                              hasNotificationPage: true,
                              title:
                                  "${notification.fname} ${notification.lname}",
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
                                  makePhoneCall(notification.contact);
                                } else if (value == "settings") {
                                  showNotificationSettingsDialog(
                                      context,
                                      notification.id.toString(),
                                      notification.notificationDay);
                                } else if (value == "feedback") {
                                  showLoadingDialog(context);
                                  await loadFeedBackListData(
                                      notification.id.toString());
                                  hideLoadingDialog(context);
                                  showFeedbackDialog(context,
                                      notification.id.toString(), feedbackData);
                                } else if (value == "date") {
                                  showUpcomingDateDialog(
                                      context,
                                      notification.inquiryDate,
                                      notification.id.toString());
                                } else if (value == "status") {
                                  showLoadingDialog(context);
                                  await loadInquiryStatusListData();
                                  hideLoadingDialog(context);
                                  showInquiryStatusDialog(context, inquiryList);
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
