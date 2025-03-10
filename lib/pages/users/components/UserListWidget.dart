import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/style.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/users/apiCall/UserApi.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';

class UserListWidget extends StatefulWidget {
  final String image, name, number, designation, userStatus, type, slug;
  final Function(String status) onChangeStatus;

  const UserListWidget({super.key,
    required this.slug,
    required this.image,
    required this.name,
    required this.number,
    required this.userStatus,
    required this.designation,
    required this.type, required this.onChangeStatus});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  bool iconStatus = false;

  @override
  void initState() {
    super.initState();
    iconStatus = widget.userStatus == "1";
  }

  Future<void> changeStatus() async {
    var data = await changeUserStatus(
        context, userBox.get(idStr), widget.slug,
        widget.userStatus == "1" ? "0" : "1");
    if (data == null) {
      callSnackBar("Unknown Error Appear", danger);
      return;
    }

    if (data.status == success) {
      widget.onChangeStatus(widget.userStatus == "1" ? "0" : "1");
      setState(() {
        iconStatus = !iconStatus;
      });
      callSnackBar(data.message ?? "Unknown Error Appear", success);
      return;
    }

    callSnackBar(data.message ?? "Unknown Error Appear", danger);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bv_secondaryLightColor3,
      child: ListTile(
        leading: ClipOval(
          child: widget.image != "" ? CachedNetworkImage(
            width: 50,
            height: 50,
            imageUrl: widget.image,
            placeholder: (context, url) => CircularProgressIndicator(color: grey_400,
              strokeWidth: 2.0,),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ) : Image.asset(userImg, width: 45, height: 45),
        ),
        title: Text(widget.name, style: primary_heading_4),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Designation : ${widget.designation}",
                style: grey_heading_4_5),
            Text("User Type : ${widget.type}", style: grey_heading_4_5),
          ],
        ),
        trailing: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.call,
                  color: green,
                ),
                onPressed: () {
                  makePhoneCall(widget.number);
                },
              ),
              IconButton(
                  icon: iconStatus
                      ? Icon(Icons.update_disabled, color: red)
                      : Icon(
                    Icons.update_outlined,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    String alertDialog = widget.userStatus == "1"
                        ? "Are you sure you want to Deactivate user ?"
                        : "Are you sure you want to Activate user ?";
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            content: Text(
                              alertDialog,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  changeStatus();
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
