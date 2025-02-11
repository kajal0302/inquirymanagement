import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/pages/about/screen/about.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/login/screen/login.dart';
import '../common/color.dart';
import '../common/size.dart';
import '../utils/common.dart';


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
              backgroundImage: AssetImage('assets/images/user.png',), // Replace with your image path
              backgroundColor: transparent, // Optional: Make background transparent
            ),
            SizedBox(height: 5,),
            TextWidget(labelAlignment:  Alignment.topLeft, label: "Global IT", labelClr: white, labelFontWeight: FontWeight.bold, labelFontSize: px22)


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
            // launchUrl(Uri.parse());
            break;
          case "Contact Us":
            // makePhoneCall();
            break;
          case "Share":
            // if (ClientData().clientShare.isNotEmpty) {
            //   Share.share(ClientData().clientShare);
            // } else {
            //   print("No content to share.");
            // }
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


// Method for logout

// List of SideBar Menu Items
Map<IconData, String> sideMenu = {
  FontAwesomeIcons.house: "Home",
  FontAwesomeIcons.users:"About Us",
  FontAwesomeIcons.locationDot: "View on Map",
  FontAwesomeIcons.phone:"Contact Us",
  FontAwesomeIcons.share:"Share",
  FontAwesomeIcons.rightFromBracket :"Log Out"
};

