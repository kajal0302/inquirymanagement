import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/components/appBar.dart';

import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../components/sidebar.dart';
import '../../../utils/asset_paths.dart';
import '../components/lists.dart';

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
      appBar: widgetAppBar(context, "Global IT Inquiry", count),
      drawer: widgetDrawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              dashboardBackgroundImg,
              fit: BoxFit.cover,
            ),
          ),

          // Cards List

          Padding(
            padding: const EdgeInsets.all(px15),
            child: ListView.builder(
              itemCount: dashboardItems.length,
              itemBuilder: (context, index)
              {
                final item = dashboardItems[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item["page"]),
                    );
                  },
                  child: SizedBox(
                    height: 95,
                    child: Card(
                      color: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(px20),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    item["icon"],
                                    color: bv_primaryColor,
                                    size: px40,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    item["title"],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios, color: preIconFillColor, size: px18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}
