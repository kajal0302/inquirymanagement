import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/pages/branch/screen/branch.dart';
import 'package:inquirymanagement/pages/followUp/screen/followUp.dart';
import 'package:inquirymanagement/pages/inquiry/screen/AddInquiryPage.dart';
import 'package:inquirymanagement/pages/inquiry_report/screen/inquiryReport.dart';
import 'package:inquirymanagement/pages/sms/screen/sms.dart';
import 'package:inquirymanagement/pages/users/screens/UserScreen.dart';
import 'package:inquirymanagement/pages/inquiry/screen/AddInquiryPage3.dart';
import 'package:inquirymanagement/pages/whatsapp/screens/ContactList.dart';

// List for dashboard Cards Icon and Title
final List<Map<String, dynamic>> dashboardItems = [
  {
    "icon": Icons.add_circle_outlined,
    "title": "Add New Inquiry",
    'page': AddInquiryPage(),
  },
  {
    "icon": FontAwesomeIcons.fileLines,
    "title": "Inquiry Report",
    'page': InquiryReportPage()
  },
  {
    "icon": Icons.calendar_today_outlined,
    "title": "Follow Up",
    'page': FollowUpPage()
  },
  {"icon": Icons.message_outlined, "title": "SMS Service", 'page': SmsPage()},
  {
    "icon": FontAwesomeIcons.whatsapp,
    "title": "Whatsapp",
    'page': ContactList()
  },
  {"icon": Icons.add_location, "title": "Branch", 'page': BranchPage()},
  {"icon": Icons.person_add, "title": "User", 'page': UserScreen()},
];

// List of SideBar Menu Items
Map<IconData, String> sideMenu = {
  FontAwesomeIcons.house: "Home",
  FontAwesomeIcons.users: "About Us",
  FontAwesomeIcons.locationDot: "View on Map",
  FontAwesomeIcons.phone: "Contact Us",
  FontAwesomeIcons.share: "Share",
  FontAwesomeIcons.rightFromBracket: "Log Out"
};

//List for reference field in Inquiry page
const referenceBy = [
  "Select Reference",
  "Self",
  "Friend",
  "Online Advertisement",
  "Website",
  "Download Brochure",
  "Global IT Partner",
  "Free Demo Lecture"
];
const days = ["After 2 days", "After 7 days", "After 15 days", "After 1 month"];
const genderList = ["Male", "Female"];
const userRoleList = ["Employee", "Admin"];
const notInStatus = ["Student", "Not Interested","Spam"];

bool EmailValidator(String val) {
  return RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
      .hasMatch(val.trim());
}
