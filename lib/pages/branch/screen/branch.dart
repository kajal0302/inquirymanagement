import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/branch/apicall/branchListApi.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';
import 'package:inquirymanagement/pages/branch/screen/addBranch.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/appBar.dart';
import '../../dashboard/screen/dashboard.dart';
import '../components/branchCardSkeleton.dart';

class BranchPage extends StatefulWidget {
  const BranchPage({super.key});

  @override
  State<BranchPage> createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
              (Route<dynamic> route) => false, // This removes all the previous routes
        );
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: widgetAppbarForAboutPage(context, "Branch List", DashboardPage(),trailingIcons: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.add_circle, color: preIconFillColor, size: 38),
                Icon(Icons.add, color: Colors.white, size: 27),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBranchPage()));
            },
          ),
        ]),
        body: isLoading ? ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const BranchCardSkeleton(),
      )
            : (branchList != null && branchList!.branches!.isNotEmpty)
            ? Padding(
          padding: const EdgeInsets.all(px15),
          child: ListView.builder(
            itemCount: branchList!.branches!.length,
            itemBuilder: (context, index) {
              final branch = branchList!.branches![index];
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBranchPage(
                    isEdit: true,
                    branchName: branch.name,
                    branchAddress: branch.address,
                    branchContactNo: branch.contactNo,
                    branchEmail: branch.email,
                    branchLocation: branch.mapLocation,
                    slug : branch.slug
                  )));
                },
                child: SizedBox(
                  height: 200,
                  child: Card(
                    color: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(px10),
                      side: BorderSide(color: grey_400,width: 1)
                    ),
                    elevation: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading with background color
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorGrey,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(px10)),
                          ),
                          child: Text(branch.name!,
                            style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: px18,
                            ),
                          ),
                        ),
                        CardRowWidget(content: branch.address!, iconValue: Icons.location_on_sharp),
                        CardRowWidget(content: branch.contactNo!, iconValue: Icons.phone),
                        CardRowWidget(content: branch.email!, iconValue: Icons.mail)
                      ],
                    ),
                  ),
                ),
              );

            },
          ),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: Text(
              dataNotAvailable,
              style: TextStyle(color: black),
            ),
          ),
        )

      ),
    );
  }
}

class CardRowWidget extends StatelessWidget {
  final String content;
  final IconData iconValue;
  const CardRowWidget({
    super.key,
    required this.content,
    required this.iconValue
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconValue, color: black,size: px26,),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: TextStyle(fontSize: px14,color: black),
            ),
          ),
        ],
      ),
    );
  }
}
