import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';

import '../../../components/appBar.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
              (Route<dynamic> route) => false, // This removes all the previous routes
        );
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: widgetAppbarForAboutPage(context, "Notifications", DashboardPage()),

      ),
    );
  }
}
