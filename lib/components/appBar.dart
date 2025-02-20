import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/pages/notification/screen/notification.dart';
import 'package:inquirymanagement/pages/setting/screen/setting.dart';
import '../common/color.dart';
import '../common/size.dart';

AppBar widgetAppBar(BuildContext context, String title, String count) {
  return AppBar(
    backgroundColor: bv_primaryColor,
    iconTheme: IconThemeData(
        color:  white
    ),
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
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NotificationPage()));
        },
        icon: count != "0"
            ? Badge(
          label: Text(count),
          child:  Icon(FontAwesomeIcons.solidBell, size: px22 ,
            color: white,),
        )
            : Icon(
          FontAwesomeIcons.solidBell,
          size: px22,
          color:  white,
        ),
      ),
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
  );
}

AppBar buildAppBar(BuildContext context,String title, List<Widget> list) {
  return AppBar(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    title: Text(title),
    actions: list,
  );
}


AppBar widgetAppbarForAboutPage(BuildContext context, String title, Widget destinationScreen, {List<Widget>? trailingIcons}) {
  return AppBar(
    backgroundColor: bv_primaryColor,
    iconTheme: IconThemeData(color: white),
    title: Text(
      title,
      style: TextStyle(color: white, fontWeight: FontWeight.normal, fontSize: px20),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => destinationScreen));
      },
      icon: Icon(Icons.arrow_back_outlined, size: px20),
    ),
    actions: trailingIcons != null
        ? trailingIcons.map((icon) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: icon,
    )).toList()
        : null,
  );
}



AppBar widgetAppbarForInquiryReport(BuildContext context, String title, Widget destinationScreen, Function(int) onMenuSelected ) {
  ValueNotifier<bool> isSearching = ValueNotifier(false);
  TextEditingController searchController = TextEditingController();

  return AppBar(
    backgroundColor: bv_primaryColor,
    iconTheme: IconThemeData(color: white),
    title: ValueListenableBuilder<bool>(
      valueListenable: isSearching,
      builder: (context, searching, child) {
        return searching
            ? Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  hintText: 'Type here to Search',
                  hintStyle: TextStyle(color: white70),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: white),
              onPressed: () {
                isSearching.value = false;
                searchController.clear();
              },
            ),
          ],
        )
            : Text(
          title,
          style: TextStyle(
              color: white,
              fontWeight: FontWeight.normal,
              fontSize: 20),
        );
      },
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => destinationScreen));
      },
      icon: Icon(Icons.arrow_back_outlined, size: 20),
    ),
    actions: [
      ValueListenableBuilder<bool>(
        valueListenable: isSearching,
        builder: (context, searching, child) {
          return searching
              ? SizedBox.shrink()
              : IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              isSearching.value = true;
            },
          );
        },
      ),
      IconButton(
        onPressed: () => _showPopUpMenu("Find By Status", (value) {
          if (value == 1) {
            onMenuSelected(value);
          }
        }, context),
        icon: Icon(
          Icons.more_vert,
          size: 22,
          color: white,
        ),
      ),
    ],
  );
}




void _showPopUpMenu(String label, Function(int) onMenuSelected, BuildContext context) async {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: black),
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
  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
}


