import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:provider/provider.dart';
import '../../../components/appBar.dart';
import '../../../components/dropDown.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../branch/apicall/branchListApi.dart';
import '../../branch/model/branchListModel.dart';
import '../../dashboard/screen/dashboard.dart';
import '../../users/provider/BranchProvider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isLoading = true;
  String userType = userBox.get(userTypeStr);
  String branchId = userBox.get(branchIdStr).toString();
  BranchListModel? branchList;
  TextEditingController selectedBranch = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BranchProvider>(context, listen: false).getBranch(context);
    });
  }

  /// Method to load BranchList
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
    final branchProvider = context.watch<BranchProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widgetAppbarForAboutPage(
        context,
        "Global IT Inquiry",
        DashboardPage(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Logout Card

            Card(
              elevation: 5,
              color: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.asset(
                  logoutImg,
                  height: 30,
                  width: 30,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                onTap: () {
                  showLogoutDialog(context);
                },
              ),
            ),

            SizedBox(height: 30),

            /// Branch Selection

            Text(
              "Select Branch",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),

            SizedBox(height: 12),
            DropDown(
              preSelectedValue: branchProvider.branch?.branches != null &&
                      branchProvider.branch!.branches!
                          .any((b) => b.id.toString() == branchId)
                  ? branchId
                  : (branchProvider.branch != null &&
                          branchProvider.branch!.branches!.isNotEmpty
                      ? branchProvider.branch!.branches!.first.id.toString()
                      : null),
              controller: selectedBranch..text = branchId,

              /// Set the initial value
              mapItems: branchProvider.branch?.branches!
                  .map((b) =>
                      {"id": b.id.toString(), "value": b.name.toString()})
                  .toSet()
                  .toList(),
              status: true,
              lbl: "Select Branch",
              onChanged: (newBranchId) {
                selectedBranch.text = newBranchId;

                /// Update the text field
                userBox.put(branchIdStr, newBranchId);

                /// Store updated branch in userBox
              },
            )
          ],
        ),
      ),
    );
  }
}
