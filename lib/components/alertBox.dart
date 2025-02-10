import 'package:flutter/material.dart';

import '../common/color.dart';
import '../common/size.dart';
class AlertDialogBox extends StatelessWidget {
  final Function() onPress;
  final String message;

  const AlertDialogBox({
    super.key,
    required this.onPress,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message,style: TextStyle(fontSize: px15),),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child:  Text("CANCEL",style: TextStyle(color: primaryColor),),
        ),
        TextButton(
          onPressed: onPress,
          child:  Text("YES",style: TextStyle(color: primaryColor),),
        ),
      ],
    );
  }
}
