import 'package:flutter/material.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/about/screen/about.dart';
import 'package:inquirymanagement/pages/contact/screen/contactUs.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/login/screen/login.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/color.dart';
import '../common/size.dart';
import '../utils/common.dart';
import 'lists.dart';
import 'package:share_plus/share_plus.dart';



// Drawer Widget
Drawer widgetDrawer(BuildContext context){
  return Drawer(
    backgroundColor: white,
    child: IconTheme(
      data: IconThemeData(color:  white),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                widgetDrawerHeader(context),
                ...widgetSidebarMenu(context),
              ],

            ),
          )
        ],
      ),
    ),
  );
}

// widget for drawerHeader


var userName = userBox.get('username');
Widget widgetDrawerHeader(BuildContext context){
  return DrawerHeader(
      decoration: BoxDecoration(
          color: bv_primaryColor
      ),
      child:SizedBox(
        height: 100,
        width:100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            CircleAvatar(
              radius: 35,
              backgroundImage: userBox.get('image') != null && userBox.get('image') != ""
                  ? NetworkImage(userBox.get('image'))
                  : const AssetImage('assets/images/user.png') as ImageProvider,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 5,),
            TextWidget(labelAlignment:  Alignment.topLeft, label: userName, labelClr: white, labelFontWeight: FontWeight.bold, labelFontSize: px22)


          ],
        ),
      )
  );
}


List<Widget> widgetSidebarMenu(BuildContext context) {
  return sideMenu.entries.map((entry) {
    return InkWell(
      onTap: (){
        String value = entry.value;
        switch(value){
          case "Home":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardPage(),
              ),
            );
            break;
          case "About Us":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ),
            );
            break;
          case "View on Map":
            launchUrl(Uri.parse(shareLink));
            break;
          case "Contact Us":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactUsPage(),
              ),
            );
            break;
          case "Share":
            if (shareLink.isNotEmpty) {
              Share.share(shareLink);
            } else {
              print("No content to share.");
            }
            break;
          case "Log Out":
            showLogoutDialog(context);
            break;

          default:
            break;
        }
      },
      child: Container(
        color: white,
        child: ListTile(
          title: Text(
            entry.value,
            style: TextStyle(
                color:bv_primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: px16
            ),
          ),
          leading: Icon(
            entry.key,
            color: preIconFillColor,
            size: px25,
          ),
        ),
      ),
    );
  }).toList();
}



