import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/contact/components/contactUsSkeleton.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../components/appBar.dart';
import '../../branch/apicall/branchListApi.dart';
import '../../branch/model/branchListModel.dart';
import '../../dashboard/screen/dashboard.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  bool isLoading = true;
  BranchListModel? branchList ;

  @override
  void initState() {
    super.initState();
    loadBranchListData();
  }

  // Method to load BranchData
  Future <void> loadBranchListData() async{
    BranchListModel? fetchedBranchListData = await fetchBranchListData(context);
    if(mounted){
      setState(() {
        branchList = fetchedBranchListData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForAboutPage(context, "Contact Us", DashboardPage()),
      body: SingleChildScrollView(
        child: isLoading ? ContactUsSkeleton() : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Email Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.mail, color: preIconFillColor,size: px30,),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (email.isNotEmpty) {
                              sendEmail(email: email);
                            } else {
                              throw 'Could not launch $email';
                            }
                          },
                          child: Text(
                            email,
                            style: TextStyle(fontSize: px16, color: colorThemeBlue,decoration: TextDecoration.underline,decorationColor: colorThemeBlue),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Divider(),
                      ],
                    ),
                  ),
                ],
              ),

              //Contact Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.phone, color: preIconFillColor,size: px30,),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact_1,
                            style: TextStyle(fontSize: px15, color: colorBlackAlpha),
                          ),
                          Text(
                            contact_2,
                            style: TextStyle(fontSize: px15, color: colorBlackAlpha),
                          ),
                          SizedBox(height: 20,),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Branch List Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Icon (only once)
                  Icon(Icons.location_on, color: preIconFillColor, size: px30),
                  SizedBox(width: 20),

                  // Branch List in Column (No Scroll)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var branch in branchList!.branches!) ...[
                          // Branch Name
                          Text(
                  "${branch.name!.isNotEmpty ? branch.name! : "N/A"} Branch",
                  style: TextStyle(fontSize: px16, fontWeight: FontWeight.bold, color: bv_primaryColor),
                          ),
                          SizedBox(height: 5),

                          // Address
                          Text(
                            branch.address!.isNotEmpty ? branch.address! : "No Address Available",
                            style: TextStyle(fontSize: px15, color: colorBlackAlpha),
                          ),

                          Text(
                            "Contact : +91 ${branch.contactNo!.isNotEmpty ? branch.contactNo! : "N/A"}",
                            style: TextStyle(fontSize: px15, color: colorBlackAlpha),
                          ),
                          SizedBox(height: 20),
                          Divider(),
                        ]
                      ],
                    ),
                  ),
                ],
              )
        
        
            ],
          ),
        ),
      ),
    );
  }
}
