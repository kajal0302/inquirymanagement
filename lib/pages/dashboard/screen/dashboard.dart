import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/dashboard/components/DashboardListView.dart';
import '../../../common/size.dart';
import '../../../components/sidebar.dart';
import '../../../main.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/lists.dart';
import '../../notification/apicall/notificationApi.dart';
import '../../notification/model/notificationModel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userType = userBox.get(userTypeStr);
  String branchId = userBox.get(branchIdStr).toString();
  NotificationModel? notification;
  String count = userBox.get(countHiv) ?? "0";

  @override
  void initState() {
    super.initState();
    loadNotificationData();
  }

  // Method to load notification data
  Future<void> loadNotificationData() async {
    NotificationModel? fetchedNotificationData =
    await fetchNotificationCount(branchId,null);

    if (fetchedNotificationData != null) {
      count = fetchedNotificationData.count.toString();
    }

    if (mounted) {
      setState(() {
        userBox.put(countHiv, count);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgetAppBar(context, appName, count,true),
      drawer: widgetDrawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              dashboardBackgroundImg,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(px15),
            child: ListView.builder(
              itemCount: dashboardItems.length,
              itemBuilder: (context, index) {
                final item = dashboardItems[index];

                if(userType == "Employee"){
                  if(item['title'] != "Branch" && item['title'] != "User"){
                    return DashboardListView(item: item);
                  }
                }else{
                  return DashboardListView(item: item);
                }
                return null;

              },
            ),
          ),
        ],
      ),
    );
  }
}