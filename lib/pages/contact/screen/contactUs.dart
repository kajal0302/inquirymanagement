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
  BranchListModel? branchList;

  @override
  void initState() {
    super.initState();
    loadBranchListData();
  }

  /// Method to load BranchData
  Future<void> loadBranchListData() async {
    BranchListModel? fetchedBranchListData = await fetchBranchListData(context);
    if (mounted) {
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
      appBar: customPageAppBar(context, "Contact Us", DashboardPage()),
      body: SingleChildScrollView(
        child: isLoading
            ? ContactUsSkeleton()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: px20, horizontal: px8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Email Section
                    ContactCard(
                      icon: Icons.mail,
                      title: "Email",
                      content: GestureDetector(
                        onTap: () async {
                          if (email.isNotEmpty) {
                            sendEmail(email: email);
                          }
                        },
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    /// Contact Section
                    ContactCard(
                      icon: Icons.phone,
                      title: "Phone",
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contact_1,
                              style: TextStyle(
                                  fontSize: px15, color: colorBlackAlpha)),
                          Text(contact_2,
                              style: TextStyle(
                                  fontSize: px15, color: colorBlackAlpha)),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    /// Branch List Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Branch List
                        if (branchList != null &&
                            branchList!.branches!.isNotEmpty)
                          Expanded(
                            child: ContactCard(
                              icon: Icons.location_on,
                              title: "Our Branches",
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < (branchList?.branches?.length ?? 0); i++) ...[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          /// Branch Name
                                          Text(
                                            branchList!.branches![i].name?.isNotEmpty == true
                                                ? "${branchList!.branches![i].name} Branch" : "",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: black87,
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          /// Address
                                          Text(
                                            branchList!.branches![i].address?.isNotEmpty == true
                                                ? branchList!.branches![i].address! : "No Address Available",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: black54),
                                          ),

                                          /// Contact Number
                                          Text(
                                            "Contact: +91 ${branchList!.branches![i].contactNo?.isNotEmpty == true ? branchList!.branches![i].contactNo! : "N/A"}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: black54),
                                          ),
                                        ],
                                      ),

                                      /// Divider (Only if not last item)
                                      if (i != branchList!.branches!.length - 1)
                                        Divider(
                                            thickness: 1,
                                            color: grey_300),
                                    ],
                                  ],
                                ),
                              ),
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


/// Widget for contact card
class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget content;

  ContactCard({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: preIconFillColor, size: 30),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
