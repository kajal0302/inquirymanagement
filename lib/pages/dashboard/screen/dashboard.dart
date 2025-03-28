import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/Update/apicall/FetchUpdateNotification.dart';
import 'package:inquirymanagement/pages/Update/screen/UpdateNowScreen.dart';
import 'package:inquirymanagement/pages/dashboard/components/DashboardListView.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    await fetchNotificationCount(branchId,"dashboard");

    if (fetchedNotificationData != null) {
      count = fetchedNotificationData.count.toString();
    }

    if (mounted) {
      setState(() {
        userBox.put(countHiv, count);
      });
    }

    FetchUpdateInfo().then((data) async {
      if (data?.status == success) {
        final currentVersion = await getCurrentVersion();
        if (isNewVersion(currentVersion.toString(), data!.version.toString())) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateNowScreen(data: data),
            ),
          );
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error in update: $error");
      }
    });
  }

  bool isNewVersion(String currentVersion, String serverVersion) {
    List<int> parseVersion(String version) {
      return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    }

    final currentParts = parseVersion(currentVersion);
    final serverParts = parseVersion(serverVersion);

    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < serverParts[i]) {
        return true; // New version is higher
      }
      if (currentParts[i] > serverParts[i]) {
        return false; // Current version is higher
      }
    }

    return false; // Versions are equal
  }

  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}