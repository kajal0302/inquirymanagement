  import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/main.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
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
  if (type == "danger" || type == "error" || type == "fail") {
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
      margin: EdgeInsets.only(
        bottom: 5,
        left: 16,
        right: 16,
      ),
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

// Method for date format
  String? formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('dd-MM-yyyy').format(date);
  }

// Method for logout
void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogBox(
        message: "Are you sure you want to logout?",
        onPress: () async{
          await userBox.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // This removes all the previous routes
          );
        },);
    },
  );
}


// Loading Dialog

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing dialog manually
      builder: (context) {
        return const Dialog(
          backgroundColor: transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: grey_400,
              strokeWidth: 2.0,
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }


  // Widget for Showing Message If data is not available
  class DataNotAvailableWidget extends StatelessWidget {
    final String message;
    final Color textColor;
    final double fontSize;
    final FontWeight fontWeight;
    final double horizontalPadding;
    final double verticalPadding;

    const DataNotAvailableWidget({
      Key? key,
      required this.message,
      this.textColor = primaryColor,
      this.fontSize = 18.0,
      this.fontWeight = FontWeight.bold,
      this.horizontalPadding = 40.0,
      this.verticalPadding = 130.0,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      );
    }
  }




