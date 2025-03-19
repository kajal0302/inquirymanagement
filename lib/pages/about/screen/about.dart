import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/size.dart';
import '../../../components/appBar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final String url = "https://globalitinfosolution.com";

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: white,
      appBar: customPageAppBar(context, "About Us", DashboardPage()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 8.0),
          child: Container(
            color: grey_200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Image at top
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset(
                      aboutUsLogo,
                      height: 65,
                    ),
                  ),
                ),
                /// Solid Line
                Container(
                  width: double.infinity,
                  height: 3,
                  color: bv_primaryDarkColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widgetSubHeading(label: "Description"),
                      widgetContent(label: description,),
                      widgetSubHeading(label: "Purpose"),
                      widgetContent(label: purpose,),
                      widgetSubHeading(label: "Products"),
                      widgetContent(label: products,),
                      widgetSubHeading(label: "Achievements"),
                      widgetContent(label: achievements,),
                      widgetSubHeading(label: "Founded"),
                      widgetContent(label: founded,),
                      widgetSubHeading(label: "For More Info Visit : "),
                      InkWell(
                        onTap: _launchURL,
                          child: Text("https://globalitinfosolution.com",style: TextStyle(color:blue),)),

                      Image.asset(
                        aboutUsOwnerImage,
                        width: MediaQuery.of(context).size.width*1,)
                    ],
                  ),
                ),
        
              ],
            ),
          ),
        ),
      )


    );
  }
}


/// Widget for content
class widgetContent extends StatelessWidget {
  final String label;
  const widgetContent({
    super.key,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Text(label,style: TextStyle(color: colorBlackAlpha,fontSize: px14,fontWeight: FontWeight.normal,height: 1.2,),);
  }
}

/// Widget for subHeading
class widgetSubHeading extends StatelessWidget {
  final String label;
  const widgetSubHeading({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(label,style: TextStyle(color: bv_primaryDarkColor ,fontWeight: FontWeight.bold,fontSize: px18),),
    );
  }
}

