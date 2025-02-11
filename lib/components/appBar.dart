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
        onPressed: () => _showPopUpMenu(context),
        icon: Icon(
          Icons.more_vert,
          size: px22,
          color:  black,
        ),
      ),
    ],
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



void _showPopUpMenu(BuildContext context) async{
  //RenderBox: Represents a box in the render tree that has dimensions and can be positioned.
  //Overlay: Used to draw widgets on top of others in a separate visual lay
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  await showMenu<int> (
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width , // Adjust this value for horizontal positioning
        kToolbarHeight+25, // Position it below the AppBar
        0,
        0,
      ),
      color: white,
      items: <PopupMenuEntry<int>>[
        PopupMenuItem(
            value: 1,
            child: Text("Settings",style: TextStyle(fontSize: px16,fontWeight: FontWeight.normal, color: black),)
        ),
       ]
  ).then((value){
    if(value==1){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingPage()));
    }
  });
}

