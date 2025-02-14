import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/notification/apicall/feedbackApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/notificationApi.dart';
import 'package:inquirymanagement/pages/notification/components/notificationCardSkeleton.dart';
import 'package:inquirymanagement/pages/notification/model/notificationModel.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/appBar.dart';
import '../model/feedbackModel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String branchId = userBox.get('branch_id').toString();
  List<dynamic> notifications = []; // Stores all notifications
  bool isLoading = true;
  bool isLoadingMore = false; // For pagination loading indicator
  int page = 1; // Pagination starts from page 1
  final ScrollController _scrollController = ScrollController();
  FeedbackModel? feedbackData;
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotificationData();
    _scrollController.addListener(_onScroll);
  }

  // Method to load notification data (Initial & Pagination)
  Future<void> loadNotificationData({bool isPagination = false}) async {
    if (isPagination) {
      if (isLoadingMore) return; // Prevent multiple API calls
      setState(() => isLoadingMore = true);
    } else {
      setState(() => isLoading = true);
    }

    NotificationModel? fetchedNotificationData = await fetchNotificationData(branchId, context);

    if (mounted) {
      setState(() {
        if (fetchedNotificationData != null && fetchedNotificationData.inquiries!.isNotEmpty) {
          notifications.addAll(fetchedNotificationData.inquiries!);
          page++; // Increase page number for next request
        }
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  // Detect when user scrolls to the bottom
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      loadNotificationData(isPagination: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  // Method to load feedData
  Future <void> loadFeedBackListData(String inquiryId ) async{
    FeedbackModel? fetchedFeedbackListData = await fetchFeedbackData(inquiryId ,context);
    if(mounted){
      setState(() {
        feedbackData = fetchedFeedbackListData;
      });
    }
  }

  // FeedBack Dialog Box
  void showFeedbackDialog(FeedbackModel? feedbackData,BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.6,
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Background Color
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: preIconFillColor, // Background Color
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8.0),topLeft: Radius.circular(8.0)),
                  ),
                  child: const Text(
                    "FeedBack History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: feedbackData!.feedbacks!.length,
                  itemBuilder: (context, index) {
                    var feedbackItem = feedbackData.feedbacks![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      feedbackItem.createdAt!,
                                      style: TextStyle(fontSize: px14, fontWeight: FontWeight.normal,color: primaryColor),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      feedbackItem.feedback!,
                                      style: TextStyle(fontSize: px14,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Spacer(), // Pushes the floating button at last
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      onPressed: (){
                        showAddFeedbackDialog(context);
                      },
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.add, color: white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // Add FeedBack Dialog Box
  void showAddFeedbackDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Background Color
                Container(
                  padding: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: preIconFillColor, // Background Color
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Add Feedback",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Feedback TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Type your feedback...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const Spacer(), // Pushes buttons to the bottom
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          String feedback = feedbackController.text.trim();
                          if (feedback.isNotEmpty) {
                            Navigator.pop(context); // Close dialog
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        child: const Text("Add",style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: px15),),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(px15),
                            side: BorderSide(
                              color: grey_500,
                              width: 2,
                            ),
                          )
                        ),
                        child: const Text("Cancel",style: TextStyle(color: grey_500,fontWeight: FontWeight.bold,fontSize: px15)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
              (Route<dynamic> route) => false, // Removes all previous routes
        );
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: widgetAppbarForAboutPage(context, "Notifications", DashboardPage()),
        body: Column(
          children: [
            isLoading
                ? Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => const NotificationCardSkeleton(),
              ),
            )
                : (notifications.isNotEmpty)
                ? Expanded(
              child: ListView.builder(
                controller: _scrollController, // Attach scroll controller
                itemCount: notifications.length + 1, // Add extra item for loader
                itemBuilder: (context, index) {
                  if (index == notifications.length) {
                    return isLoadingMore ? _buildLoadingIndicator() : SizedBox.shrink();
                  }
                  final notification = notifications[index];
                  final contactNumber = notification.contact;
                  // Extract course names
                  String courseNames = notification.courses!.map((course) => course.name).join(", ");
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(px18),
                    ),
                    color: bv_secondaryLightColor3,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      leading: Icon(
                        Icons.notifications,
                        color: preIconFillColor,
                      ),
                      title: Text(
                        "${notification.fname} ${notification.lname}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: black,
                        ),
                      ),
                      subtitle: Text(
                        courseNames,
                        style: TextStyle(
                          fontSize: px14,
                          fontWeight: FontWeight.bold,
                          color: colorBlackAlpha,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        color: white,
                        onSelected: (value) async{
                          if(value == "call"){
                            makePhoneCall(notification.contact);
                          }
                          else if(value == "settings"){

                          }
                          else if(value == "feedback"){
                            
                            await loadFeedBackListData(notification.id.toString());
                            showFeedbackDialog(feedbackData,context);

                          }
                          else if(value == "date"){

                          }
                          else if(value == "status"){

                          }

                          print("Selected action: $value");
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(value: 'call', child: Text('Call')),
                          PopupMenuItem<String>(value: 'settings', child: Text('Notification Settings')),
                          PopupMenuItem<String>(value: 'feedback', child: Text('Feedback History')),
                          PopupMenuItem<String>(value: 'date', child: Text('Upcoming Date')),
                          PopupMenuItem<String>(value: 'status', child: Text('Status')),
                        ],
                        icon: Icon(Icons.more_vert, color: Colors.black),
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
            ),
          ],
        ),
      ),
    );

  }

  // Loading Indicator
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
