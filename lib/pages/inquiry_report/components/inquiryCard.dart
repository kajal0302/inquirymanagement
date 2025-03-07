import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import '../../../common/size.dart';

class InquiryNotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<PopupMenuEntry<String>> menuItems;
  final Function(String) onMenuSelected;
  final VoidCallback? onTap;

  const InquiryNotificationCard({
    Key? key,
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
        leading: Icon(Icons.notifications, color: preIconFillColor, size: 30),
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


/// Card for inquiryReport Page
class InquiryCard extends StatelessWidget {
  final String status;
  final String title;
  final String subtitle;
  final List<PopupMenuEntry<String>> menuItems;
  final Function(String) onMenuSelected;
  final VoidCallback? onTap;

  const InquiryCard({
    Key? key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.menuItems,
    required this.onMenuSelected,
    this.onTap,
  }) : super(key: key);


  /// Dot color a/c to status
  Color getStatusColor() {
    switch (status) {
      case "Inquiry":
        return green;
      case "Interested":
        return blue;
      case "Hot Inquiry":
        return red;
      default:
        return grey_400;
    }
  }

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
        leading: Image.asset(userImg, width: 45, height: 45),
        title:
        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: black,
                    ),
                    overflow: TextOverflow.ellipsis, /// Shows "..." if text is too long
                    maxLines: 1,
                    softWrap: false, /// Prevents text from wrapping
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(px8),
                    border: Border.all(
                      color: getStatusColor(),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: px14,
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        subtitle:
        Text(
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
