import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/dashboard/components/DashboardListView.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../components/sidebar.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/lists.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String count = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgetAppBar(context, appName, count),
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
                return DashboardListView(item: item);
              },
            ),
          ),

        ],
      ),
    );
  }
}
