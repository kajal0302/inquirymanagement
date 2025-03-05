import 'package:inquirymanagement/common/color.dart';
import 'package:flutter/material.dart';

class ContactListTile extends StatelessWidget {
  final String name;

  const ContactListTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(color: white),
              ),
            ),
            title: Text(
              name.toUpperCase(),
              style: const TextStyle(color: colorBlackAlpha, fontSize: 16.0),
            ),
            // trailing:const CircleAvatar(
            //   radius: 12,
            //   backgroundColor: colorRed,
            //   child: Text("5",style: TextStyle(color: white)),
            // )
          ),
        ),
        const Divider(
          height: 1,
          color: grey_300,
        )
      ],
    );
  }
}
