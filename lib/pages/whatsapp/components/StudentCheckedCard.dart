import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/size.dart';
import 'package:inquirymanagement/common/style.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';

class StudentCheckedCard extends StatelessWidget {
  final String id;
  final String title;
  final String? subTitle;
  final String img;
  final bool isChecked;
  final Function(bool val) onChange;

  StudentCheckedCard({
    Key? key,
    required this.title,
    this.subTitle,
    required this.img,
    required this.isChecked,
    required this.id,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(px10),
      ),
      child: InkWell(
        onTap: () {
          onChange(!isChecked); // Toggle the checkbox value on tap
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: px5, vertical: px4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: px4),
                    child:CircleAvatar(backgroundColor: primaryColor,backgroundImage:AssetImage(userImageUri) ,)
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: scTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subTitle != null)
                          Text(
                            subTitle!,
                            style: scSubTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Checkbox(
                value: isChecked,
                onChanged: (val) {
                  onChange(val ?? false); // Directly pass the new value
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
