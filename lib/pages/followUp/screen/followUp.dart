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
import '../../notification/components/notificationCardSkeleton.dart';

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
            indicatorWeight: 1.0,
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
              Tab(child: Text("Date Filter"),)
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
                    itemBuilder: (context, index) => const NotificationCardSkeleton(),
                  ),
                ) : (todayInquiryData!=null && todayInquiryData!.inquiries!.isNotEmpty)
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: todayInquiryData!.inquiries!.length,
                    itemBuilder: (context, index) {
                      final todayInquiry = todayInquiryData!.inquiries![index];
                      String courseNames = todayInquiry.courses!.map((course) => course.name).join(", ");
                      return InquiryCard(
                        title:  "${todayInquiry.fname} ${todayInquiry.lname}",
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
                            makePhoneCall(todayInquiry.contact!);
                          } else if (value == "settings") {

                          } else if (value == "feedback") {
                            showLoadingDialog(context);
                            hideLoadingDialog(context);

                          } else if (value == "date") {

                          } else if (value == "status") {
                            showLoadingDialog(context);

                            hideLoadingDialog(context);
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
            // Tomorrow TabBar
            Column(
              children: [
                isLoading
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const NotificationCardSkeleton(),
                  ),
                ) : (tomorrowInquiryData!=null && tomorrowInquiryData!.inquiries!.isNotEmpty)
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: tomorrowInquiryData!.inquiries!.length,
                    itemBuilder: (context, index) {
                      final tomorrowInquiry = tomorrowInquiryData!.inquiries![index];
                      String courseNames = tomorrowInquiry.courses!.map((course) => course.name).join(", ");
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
                            makePhoneCall(tomorrowInquiry.contact!);
                          } else if (value == "settings") {

                          } else if (value == "feedback") {
                            showLoadingDialog(context);
                            hideLoadingDialog(context);

                          } else if (value == "date") {

                          } else if (value == "status") {
                            showLoadingDialog(context);

                            hideLoadingDialog(context);
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
                    itemBuilder: (context, index) => const NotificationCardSkeleton(),
                  ),
                ) : (daysInquiryData!=null && daysInquiryData!.inquiries!.isNotEmpty)
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: daysInquiryData!.inquiries!.length,
                    itemBuilder: (context, index) {
                      final daysInquiry = daysInquiryData!.inquiries![index];
                      String courseNames = daysInquiry.courses!.map((course) => course.name).join(", ");
                      return InquiryCard(
                        title:  "${daysInquiry.fname} ${daysInquiry.lname}",
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
                            makePhoneCall(daysInquiry.contact!);
                          } else if (value == "settings") {

                          } else if (value == "feedback") {
                            showLoadingDialog(context);
                            hideLoadingDialog(context);

                          } else if (value == "date") {

                          } else if (value == "status") {
                            showLoadingDialog(context);

                            hideLoadingDialog(context);
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
            Center(child: Text(" Follow-Ups")),
          ],
        ),
      ),
    );
  }
}



