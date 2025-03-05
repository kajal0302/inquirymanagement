import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';

class InquiryCard extends StatelessWidget {
  final bool? hasNotificationPage;
  final String title;
  final String subtitle;
  final List<PopupMenuEntry<String>> menuItems;
  final Function(String) onMenuSelected;
  final VoidCallback? onTap;

  const InquiryCard({
    Key? key,
    this.hasNotificationPage=false,
    required this.title,
    required this.subtitle,
    required this.menuItems,
    required this.onMenuSelected,
    this.onTap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: bv_secondaryLightColor3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        leading: hasNotificationPage ?? false
            ? Icon(Icons.notifications, color: preIconFillColor,size: 30,)
            : Image.asset(userImg, width: 45, height: 45),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.white,
          onSelected: onMenuSelected,
          itemBuilder: (BuildContext context) => menuItems,
          icon: const Icon(Icons.more_vert, color: Colors.black),
        ),
      ),
    );
  }
}
