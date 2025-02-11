import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/pages/branch/screen/branch.dart';
import 'package:inquirymanagement/pages/inquiry/screen/addInquiry.dart';

import '../screen/dashboard.dart';


// List for dashboard Cards Icon and Title
final List<Map<String, dynamic>> dashboardItems = [
  {
    "icon": Icons.add_circle_outlined,
    "title": "Add New Inquiry",
    'page': AddInquiryPage(),
  },
  {
    "icon": FontAwesomeIcons.fileAlt,
    "title": "Inquiry Report",
    'page': DashboardPage()
  },
  {
    "icon": Icons.message_outlined,
    "title": "SMS Service",
    'page': DashboardPage()
  },
  {
    "icon": Icons.calendar_today_outlined,
    "title": "Follow Up",
    'page': DashboardPage()
  },
  {
    "icon": Icons.add_location,
    "title": "Branch",
    'page': BranchPage()
  },
  {
    "icon": Icons.person_add,
    "title": "User",
    'page': DashboardPage()
  },
];