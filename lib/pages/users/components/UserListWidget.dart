import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/style.dart';

class UserListWidget extends StatelessWidget {
  final String image, name, designation, type;

  const UserListWidget(
      {super.key,
        required this.image,
        required this.name,
        required this.designation,
        required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bv_secondaryLightColor3,
      child: ListTile(
        leading: ClipOval(
          child: CachedNetworkImage(
            width: 50,
            height: 50,
            imageUrl: image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(name,style: primary_heading_4,),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Designation : ${designation}",style: grey_heading_5,),
            Text("User Type : ${type}",style: grey_heading_5,)
          ],
        ),
        //<i class="fa-solid fa-ellipsis-vertical"></i>
        trailing: FaIcon(FontAwesomeIcons.ellipsisVertical),
      ),
    );
  }
}
