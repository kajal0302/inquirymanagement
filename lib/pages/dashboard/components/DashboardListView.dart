import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/size.dart';

class DashboardListView extends StatelessWidget {
  const DashboardListView({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item["page"]),
        );
      },
      child: Card(
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(px20),
        ),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding:const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      item["icon"],
                      color: bv_primaryColor,
                      size: px40,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item["title"],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: preIconFillColor, size: px18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
