import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../boxes.dart';
import '../common/color.dart';
import '../common/size.dart';
import '../components/alertBox.dart';
import '../pages/login/screen/login.dart';

void debugLog(String message) {
  if (kDebugMode) {
    print(message);
  }
}

// Manage a ScaffoldMessenger globally
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

// Method for showing messages
void callSnackBar(String text, String type) {
  Color color = sfDefaultColor;
  IconData icon = Icons.notifications_none_outlined;
  if (type == "success") {
    color = sfSucColor;
    icon = Icons.check_circle;
  }
  if (type == "info") {
    color = sfInfoColor;
    icon = Icons.info;
  }
  if (type == "danger") {
    color = sfDangColor;
    icon = Icons.warning;
  }
  if (type == "warning") {
    color = sfWarColor;
    icon = Icons.dangerous;
  }

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Row(
        children: [
          Icon(
            icon,
            color: white,
          ),
          const SizedBox(
            width: px10,
          ),
          Expanded(child:
          Text(
            text,
            style:  TextStyle(color: white),
          ),
          )
        ],
      ),
    ),
  );
}



// Method for checking internet Connectivity
Future <bool> checkConnection() async{
  bool result = await InternetConnection().hasInternetAccess;
  return result;

}

// Method for logout
void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogBox(
        message: "Are you sure you want to logout?",
        onPress: () async{
          await boxperson.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // This removes all the previous routes
          );
        },);
    },
  );
}


