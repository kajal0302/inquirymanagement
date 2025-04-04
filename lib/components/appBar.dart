import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/notification/screen/notification.dart';
import 'package:inquirymanagement/pages/setting/screen/setting.dart';
import '../common/color.dart';
import '../common/size.dart';

/// AppBar used in dashboard and followUp Page
AppBar widgetAppBar(
    BuildContext context, String title, String count, bool? isDashboard,
    {PreferredSizeWidget? bottom}) {
  return AppBar(
    backgroundColor: bv_primaryColor,
    iconTheme: IconThemeData(color: white),
    title: Center(
      child: Text(
        title,
        style: TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
          fontSize: px21,
        ),
      ),
    ),
    actions: [
      IconButton(
        // padding: EdgeInsets.only(right: 10),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotificationPage(isDashboard: isDashboard ?? false)));
        },
        icon: count != "0"
            ? Badge(
                label: Text(count),
                child: Icon(
                  FontAwesomeIcons.solidBell,
                  size: px22,
                  color: white,
                ),
              )
            : Icon(
                FontAwesomeIcons.solidBell,
                size: px22,
                color: white,
              ),
      ),
      if (isDashboard == true && userBox.get(userTypeStr) == admin)
        IconButton(
          onPressed: () => _showPopUpMenu("Settings", (value) {
            if (value == 1) {
              navigation(context);
            }
          }, context),
          icon: Icon(
            Icons.more_vert,
            size: 22,
            color: white,
          ),
        ),
    ],
    bottom: bottom,
  );
}

/// AppBar used in almost all the Pages
AppBar customPageAppBar(
    BuildContext context, String title, Widget destinationScreen,
    {List<Widget>? trailingIcons}) {
  return AppBar(
    backgroundColor: bv_primaryColor,
    iconTheme: IconThemeData(color: white),
    title: Text(
      title,
      style: TextStyle(
          color: white, fontWeight: FontWeight.normal, fontSize: px20),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => destinationScreen));
      },
      icon: Icon(Icons.arrow_back_outlined, size: px20),
    ),
    actions: trailingIcons != null
        ? trailingIcons
            .map((icon) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: icon,
                ))
            .toList()
        : null,
  );
}

AppBar buildAppBar(BuildContext context, String title, List<Widget> list) {
  return AppBar(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    title: Text(title),
    actions: list,
  );
}

void _showPopUpMenu(
    String label, Function(int) onMenuSelected, BuildContext context) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  await showMenu<int>(
    context: context,
    position: RelativeRect.fromLTRB(
      overlay.size.width, // Adjust this value for horizontal positioning
      kToolbarHeight + 25, // Position it below the AppBar
      0,
      0,
    ),
    color: Colors.white,
    items: <PopupMenuEntry<int>>[
      PopupMenuItem(
        value: 1,
        child: Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: black),
        ),
      ),
    ],
  ).then((value) {
    if (value != null) {
      onMenuSelected(value);
    }
  });
}

void navigation(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SettingPage(),
    ),
  );
}
