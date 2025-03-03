import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/followUp/apiCall/upcomingInquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../main.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key});

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  String branchId = userBox.get(branchIdStr).toString();
  InquiryModel? upcomingInquiries;
  String today = "1";
  String tomorrow = "1";
  String sevenDays = "1";

  // Method to load BranchList
  Future <void> fetchUpcomingInquiry() async {
    InquiryModel? fetchedUpcomingInquiryData = await fetchUpcomingInquiryData(today, tomorrow, sevenDays, branchId, context);
    if (mounted) {
      setState(() {
        upcomingInquiries = fetchedUpcomingInquiryData;
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
              Tab( icon: Icon(Icons.calendar_month, size: 30),),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            ),
            Center(child: Text("Tomorrow Follow-Ups")),
            Center(child: Text("Within 7 Days Follow-Ups")),
            Center(child: Text("Missed Follow-Ups")),
          ],
        ),
      ),
    );
  }
}



