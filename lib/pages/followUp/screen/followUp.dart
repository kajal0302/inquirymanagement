import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/followUp/apiCall/upcomingInquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/urlLauncherMethods.dart';
import '../../inquiry_report/components/inquiryCard.dart';
import '../../notification/apicall/feedbackApi.dart';
import '../../notification/apicall/inquiryStatusListApi.dart';
import '../../notification/components/feedbackDialog.dart';
import '../../notification/components/notificationCardSkeleton.dart';
import '../../notification/components/notificationSettingsDialog.dart';
import '../../notification/components/statusDialog.dart';
import '../../notification/components/upcomingDateDialog.dart';
import '../../notification/model/feedbackModel.dart';
import '../../notification/model/inquiryStatusListModel.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key});

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  String branchId = userBox.get(branchIdStr).toString();
  InquiryModel? todayInquiryData;
  InquiryModel? tomorrowInquiryData;
  InquiryModel? daysInquiryData;
  InquiryStatusModel? inquiryList;
  FeedbackModel? feedbackData;
  String today = "1";
  String tomorrow = "1";
  String sevenDays = "1";
  bool isLoading = true;



  @override
  void initState() {
    super.initState();
    fetchUpcomingInquiryForToday();
    fetchUpcomingInquiryForTomorrow();
    fetchUpcomingInquiryForDays();
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


  // Method to update upcoming date
  Future <void> loadInquiryStatusListData() async{
    InquiryStatusModel? inquiryStatusList = await fetchInquiryStatusList(context);
    if(mounted){
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }
  }

  // Method to fetch today inquiry Data
  Future <void> fetchUpcomingInquiryForToday() async {
    InquiryModel? fetchedTodayInquiryData = await fetchUpcomingInquiryData(today, null, null, branchId, context);
    if (mounted) {
      setState(() {
        todayInquiryData = fetchedTodayInquiryData;
        isLoading=false;
      });
    }
  }

  // Method to fetch tomorrow inquiry Data
  Future <void> fetchUpcomingInquiryForTomorrow() async {
    InquiryModel? fetchedTomorrowInquiryData = await fetchUpcomingInquiryData(null, tomorrow, null, branchId, context);
    if (mounted) {
      setState(() {
        tomorrowInquiryData = fetchedTomorrowInquiryData;
        isLoading=false;
      });
    }
  }

  // Method to fetch 7Days inquiry Data
  Future <void> fetchUpcomingInquiryForDays() async {
    InquiryModel? fetchedDaysInquiryData = await fetchUpcomingInquiryData(null, null, sevenDays, branchId, context);
    if (mounted) {
      setState(() {
        daysInquiryData = fetchedDaysInquiryData;
        isLoading=false;
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


  // Add Upcoming Date Dialog Box
  void showUpcomingDateDialog(BuildContext context, String inquiryDate, String inquiryId) {
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

  // Add Inquiry Status Dialog Box
  void showInquiryStatusDialog(BuildContext context, InquiryStatusModel? inquiryList) {
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: bv_primaryColor,
          iconTheme: IconThemeData(color: white),
          title: Text(
            "Follow Up",
            style: TextStyle(color: white, fontWeight: FontWeight.normal, fontSize: px20),
          ),
          bottom: const TabBar(
            labelColor: white,
            unselectedLabelColor: grey_400, // Inactive tab color
            indicatorColor: white, // Underline indicator
            indicatorWeight: 0.1,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: px12,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(child: Text( "Today"),),
              Tab(child: Text( "Tomorrow"),),
              Tab(child: Text( "Within 7 Days"),),
              Tab(child: Icon(Icons.calendar_month))
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            // Today TabBar
            Column(
              children: [
                isLoading
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                    const NotificationCardSkeleton(),
                  ),
                )
                    : (todayInquiryData?.inquiries?.isNotEmpty ?? false)
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: todayInquiryData?.inquiries?.length ?? 0,
                    itemBuilder: (context, index) {
                      final todayInquiry = todayInquiryData?.inquiries?[index];

                      // Ensure todayInquiry is not null before accessing properties
                      if (todayInquiry == null) return SizedBox();

                      String courseNames =
                          todayInquiry.courses?.map((course) => course.name).join(", ") ?? "No courses available";

                      return
                        InquiryCard(
                        title: "${todayInquiry.fname ?? ''} ${todayInquiry.lname ?? ''}",
                        subtitle: courseNames,
                        menuItems: [
                          PopupMenuItem<String>(
                              value: 'call', child: Text(call)),
                          PopupMenuItem<String>(
                              value: 'settings', child: Text(notificationSettings)),
                          PopupMenuItem<String>(
                              value: 'feedback', child: Text(feedbackHistory)),
                          PopupMenuItem<String>(
                              value: 'date', child: Text(upcomingDate)),
                          PopupMenuItem<String>(
                              value: 'status', child: Text(status)),
                        ],
                        onMenuSelected: (value) async {
                          if (value == "call") {
                            if (todayInquiry.contact != null) {
                              makePhoneCall(todayInquiry.contact!);
                            }
                          } else if (value == "settings") {
                            showNotificationSettingsDialog(context, todayInquiry.id.toString(),  todayInquiry.notificationDay!);
                          } else if (value == "feedback") {
                            showLoadingDialog(context);
                            await loadFeedBackListData(todayInquiry.id.toString());
                            hideLoadingDialog(context);
                            showFeedbackDialog(context,  todayInquiry.id.toString(), feedbackData);
                          } else if (value == "date") {
                            showUpcomingDateDialog(context, todayInquiry.inquiryDate!, todayInquiry.id.toString());
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
                      child: DataNotAvailableWidget(message: dataNotAvailable)),
                ),
              ],
            ),
            // Tomorrow TabBar
            Column(
              children: [
                isLoading
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const NotificationCardSkeleton(),
                  ),
                ) : (tomorrowInquiryData?.inquiries?.isNotEmpty ?? false)
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: tomorrowInquiryData?.inquiries?.length ?? 0,
                    itemBuilder: (context, index) {
                      final tomorrowInquiry = tomorrowInquiryData?.inquiries?[index];

                      // Ensure tomorrowInquiry is not null before accessing properties
                      if (tomorrowInquiry == null) return SizedBox();
                      String courseNames =
                          tomorrowInquiry.courses?.map((course) => course.name).join(", ") ?? "No courses available";
                      return InquiryCard(
                        title:  "${tomorrowInquiry.fname} ${tomorrowInquiry.lname}",
                        subtitle: courseNames,
                        menuItems: [
                          PopupMenuItem<String>(value: 'call', child: Text(call)),
                          PopupMenuItem<String>(value: 'settings', child: Text(notificationSettings)),
                          PopupMenuItem<String>(value: 'feedback', child: Text(feedbackHistory)),
                          PopupMenuItem<String>(value: 'date', child: Text(upcomingDate)),
                          PopupMenuItem<String>(value: 'status', child: Text(status)),
                        ],
                        onMenuSelected: (value) async {
                          if (value == "call") {
                            if (tomorrowInquiry.contact != null) {
                              makePhoneCall(tomorrowInquiry.contact!);
                            }
                          }else if (value == "settings") {
                            showNotificationSettingsDialog(context, tomorrowInquiry.id.toString(),  tomorrowInquiry.notificationDay!);
                          } else if (value == "feedback") {
                            showLoadingDialog(context);
                            await loadFeedBackListData(tomorrowInquiry.id.toString());
                            hideLoadingDialog(context);
                            showFeedbackDialog(context,  tomorrowInquiry.id.toString(), feedbackData);
                          } else if (value == "date") {
                            showUpcomingDateDialog(context, tomorrowInquiry.inquiryDate!, tomorrowInquiry.id.toString());
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
                ): Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                      child: DataNotAvailableWidget(message: dataNotAvailable)
                  ),
                ),

              ],
            ),
            // Within 7Days TabBar
            Column(
              children: [
                isLoading
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                    const NotificationCardSkeleton(),
                  ),
                )
                    : (daysInquiryData?.inquiries?.isNotEmpty ?? false)
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: daysInquiryData?.inquiries?.length ?? 0,
                    itemBuilder: (context, index) {
                      final daysInquiry = daysInquiryData?.inquiries?[index];

                      if (daysInquiry == null) return SizedBox();

                      String courseNames = daysInquiry.courses
                          ?.map((course) => course.name)
                          .join(", ") ??
                          "No courses available";

                      return InquiryCard(
                        title:
                        "${daysInquiry.fname ?? ''} ${daysInquiry.lname ?? ''}",
                        subtitle: courseNames,
                        menuItems: [
                          PopupMenuItem<String>(
                              value: 'call', child: Text(call)),
                          PopupMenuItem<String>(
                              value: 'settings', child: Text(notificationSettings)),
                          PopupMenuItem<String>(
                              value: 'feedback', child: Text(feedbackHistory)),
                          PopupMenuItem<String>(
                              value: 'date', child: Text(upcomingDate)),
                          PopupMenuItem<String>(
                              value: 'status', child: Text(status)),
                        ],
                        onMenuSelected: (value) async {
                          if (value == "call") {
                            if (daysInquiry.contact != null) {
                              makePhoneCall(daysInquiry.contact!);
                            }
                          } else if (value == "settings") {
                            showNotificationSettingsDialog(context, daysInquiry.id.toString(),  daysInquiry.notificationDay!);
                          } else if (value == "feedback") {
                            showLoadingDialog(context);
                            await loadFeedBackListData(daysInquiry.id.toString());
                            hideLoadingDialog(context);
                            showFeedbackDialog(context,  daysInquiry.id.toString(), feedbackData);
                          } else if (value == "date") {
                            showUpcomingDateDialog(context, daysInquiry.inquiryDate!, daysInquiry.id.toString());
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
                      child: DataNotAvailableWidget(message: dataNotAvailable)),
                ),
              ],
            ),
            Center(child: Text(" Follow-Ups")),
          ],
        ),
      ),
    );
  }
}



