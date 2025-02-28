import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/alertBox.dart';
import 'package:inquirymanagement/components/dateField.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/branch/model/addBranchModel.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/login/screen/login.dart';
import 'package:inquirymanagement/pages/notification/apicall/feedbackApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/inquiryStatusListApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/notificationApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/updateInquiryStatus.dart';
import 'package:inquirymanagement/pages/notification/apicall/updateNotificationDay.dart';
import 'package:inquirymanagement/pages/notification/components/notificationCardSkeleton.dart';
import 'package:inquirymanagement/pages/notification/model/inquiryStatusListModel.dart';
import 'package:inquirymanagement/pages/notification/model/notificationModel.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/urlLauncherMethods.dart';
import 'package:intl/intl.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/appBar.dart';
import '../../../utils/lists.dart';
import '../apicall/postFeedbackApi.dart';
import '../apicall/updateUpcomingDate.dart';
import '../components/customDialogBox.dart';
import '../model/feedbackModel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String branchId = userBox.get('branch_id').toString();
  String createdBy = userBox.get('id').toString();
  List<dynamic> notifications = []; // Stores all notifications
  bool isLoading = true;
  bool isLoadingMore = false; // For pagination loading indicator
  int page = 1; // Pagination starts from page 1
  final ScrollController _scrollController = ScrollController();
  FeedbackModel? feedbackData;
  SuccessModel? addFeedback;
  InquiryStatusModel? inquiryList;
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


  // Method to load feedback data
  Future <FeedbackModel?> loadFeedBackListData(String inquiryId ) async{
    FeedbackModel? fetchedFeedbackListData = await fetchFeedbackData(inquiryId ,context);
    if(mounted){
      setState(() {
        feedbackData = fetchedFeedbackListData;
      });
    }
    return fetchedFeedbackListData;
  }


  // Method to add feedback data
  Future <void> addFeedbackData(String inquiryId,String feedBack ) async{
    SuccessModel? addFeedbackData = await createFeedbackData(inquiryId, feedBack,branchId,context);
    if(mounted){
      setState(() {
        addFeedback = addFeedbackData;
      });
    }
  }

  // Method to update upcoming date
  Future <void> updateUpcomingDate(String inquiryId,String date ) async{
    SuccessModel? updatedDateData = await UpdateUpcomingDate(inquiryId, date,branchId,createdBy,context);
    if(mounted){
      setState(() {
        addFeedback = updatedDateData;
      });
    }
  }


  // Method to update upcoming date
  Future <void> loadInquiryStatusListData() async{
    InquiryStatusModel? inquiryStatusList = await fetchInquiryStatusList(context);
    if(mounted){
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }
  }


  // FeedBack Dialog Box
  void showFeedbackDialog(FeedbackModel? feedbackData, String inquiryId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: feedbackHistory,
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  // Scrollable Feedback List
                  Expanded(
                    child: feedbackData == null || feedbackData!.feedbacks == null || feedbackData!.feedbacks!.isEmpty
                        ? const Center(child: Text(noFeedback))
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: feedbackData!.feedbacks!.length,
                      itemBuilder: (context, index) {
                        var feedbackItem = feedbackData!.feedbacks![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: grey_100,
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
                                    style: TextStyle(
                                      fontSize: px14,
                                      fontWeight: FontWeight.normal,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    feedbackItem.feedback!,
                                    style: TextStyle(
                                      fontSize: px14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Floating Button for Adding Feedback
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () async {
                          // Show add feedback dialog
                          bool isAdded = await showAddFeedbackDialog(inquiryId, context);
                          if (isAdded) {
                            // Refresh feedback list after adding
                            FeedbackModel? updatedData = await loadFeedBackListData(inquiryId);
                            setState(() {
                              feedbackData = updatedData;
                            });
                          }
                        },
                        backgroundColor: primaryColor,
                        child: const Icon(Icons.add, color: white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  // Add Feedback Dialog Box
  Future<bool> showAddFeedbackDialog(String inquiryId, BuildContext context) async {
    TextEditingController feedbackController = TextEditingController();
    bool isFeedbackAdded = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: addFeedbackHeader,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Feedback TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: grey_100,
                    hintText: "Type your feedback...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Buttons Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          String feedback = feedbackController.text.trim();
                          if (feedback.isEmpty) {
                            callSnackBar("Please Enter feedback", "danger");

                          }
                          await addFeedbackData(inquiryId, feedback);
                          isFeedbackAdded = true;
                          Navigator.pop(context, isFeedbackAdded);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bv_primaryDarkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(px15),
                          ),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: px15),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(px15),
                            side: BorderSide(
                              color: grey_500,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: grey_500, fontWeight: FontWeight.bold, fontSize: px15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    return isFeedbackAdded;
  }



  //  Date Selection Method
  void _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100, 1, 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: preIconFillColor, // background of the date
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: preIconFillColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      controller.text = formatter.format(pickedDate);
    }
  }


  // Add Notification Dialog Box
  void showNotificationSettingsDialog(String inquiryId, String notificationDay,BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController dayController = TextEditingController();
    // Get the index of notificationDay in days list
    int selectedOption = days.indexOf(notificationDay);
    if (selectedOption == -1) {
      selectedOption = 3; // Default selection if notificationDay is not found
    }
    String selectedOptionValue = days[selectedOption];

    //  assign values
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dayController.text = selectedOptionValue;;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: notificationSettings,
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: List.generate(days.length, (index) {
                          return ListTile(
                            title: TextWidget(
                              labelAlignment: Alignment.topLeft,
                              label: days[index],
                              labelClr: black,
                              labelFontWeight: FontWeight.normal,
                              labelFontSize: px16,
                            ),
                            trailing: Radio<int>(
                              value: index,
                              groupValue: selectedOption,
                              activeColor: preIconFillColor,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedOption = value!;
                                  selectedOptionValue = days[selectedOption];
                                  dayController.text=selectedOptionValue;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: grey_100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: grey_500, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              labelAlignment: Alignment.topLeft,
                              label: "Select Notification End Date",
                              labelClr: black,
                              labelFontWeight: FontWeight.bold,
                              labelFontSize: px18,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: DateField(
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100, 1, 1),
                                    label: "dd-MM-yyyy",
                                    controller: dateController,
                                    showBottomBorder: true,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.calendar_today, color: preIconFillColor),
                                  onPressed: () => _selectDate(context, dateController), // Also trigger date picker
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 108,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () async {
                                  String dayValue= dayController.text;
                                  String dateValue = dateController.text;
                                  Navigator.pop(context);
                                  showMessageDialog(inquiryId,dayValue,dateValue,context);
                  
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: bv_primaryDarkColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(px15),
                                  ),
                                ),
                                child: const Text(
                                  "APPLY",
                                  style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: px15),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 108,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(px15),
                                    side: BorderSide(
                                      color: grey_500,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "CANCEL",
                                  style: TextStyle(color: grey_500, fontWeight: FontWeight.bold, fontSize: px15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Add Message Dialog Box
  Future<void> showMessageDialog(String inquiryId, String day,String date,BuildContext context) async {
    TextEditingController messageController = TextEditingController();
    bool isMessageAdded = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: smsService,
          height: 360,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              // Feedback TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: messageController,
                  maxLines: 5,
                  maxLength: 119,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: grey_100,
                    hintText: "Type your message here... (Maximum 119 characters allowed)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),
              // Buttons Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          String message = messageController.text.trim();
                          if (message.isEmpty) {
                            callSnackBar("Please Enter message..", "danger");
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialogBox(
                                  message: "Are you sure?",
                                  onPress: () async {
                                      await UpdateNotificationDay(inquiryId, day, date, message, createdBy, branchId, context);
                                      isMessageAdded = true;
                                      callSnackBar(updationMessage, "success");
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NotificationPage()));


                                  },
                                );
                              },
                            );
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bv_primaryDarkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(px15),
                          ),
                        ),
                        child: const Text(
                          "SEND SMS",
                          style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: px13),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
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
                          ),
                        ),

                        child: const Text(
                          "CANCEL",
                          style: TextStyle(color: grey_500, fontWeight: FontWeight.bold, fontSize: px13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  // Add Upcoming Date Dialog Box
  void showUpcomingDateDialog(String inquiryDate,String inquiryId,BuildContext context) {

    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime date = format.parse(inquiryDate);  // String to DateTime

    DateTime selectedDate = date  ?? DateTime.now(); // Initialize with current date
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: upcomingDateHeader,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  // Date Selection
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:DateTime.now(),
                        firstDate:DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: preIconFillColor, // background of the date
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              dialogBackgroundColor: Colors.white,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: preIconFillColor,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today, color: preIconFillColor),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd-MM-yyyy').format(selectedDate), // Formatted Date
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: ()  async{
                      String  dateValue =  "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                      await updateUpcomingDate(inquiryId,dateValue );
                      Navigator.pop(context);
                      callSnackBar(updationMessage, "success");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bv_primaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(px30),
                      ),
                    ),
                    child: const Text(
                      "UPDATE",
                      style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: px15),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  // Add Status Dialog Box
  void showInquiryStatusDialog(InquiryStatusModel? inquiryList, BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
        String selectedId = '';
        String selectedName = '';
        String selectedStatusId = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: "Select Inquiry Status",
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: inquiryList!.inquiryStatusList!.length,
                        itemBuilder: (context, index) {
                          var status = inquiryList.inquiryStatusList![index];
                          bool isSelected = selectedId == status.id; // Check if selected

                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedId = status.id!;
                                  selectedName = status.name!;
                                  selectedStatusId = status.status!;
                                });
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: isSelected ? preIconFillColor : grey_500,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      status.name!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected ? preIconFillColor : black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedId.isEmpty) {
                            callSnackBar("Please select a status", "danger");
                            return;
                          }
                          await updateInquiryStatusData(
                              selectedId, selectedStatusId, selectedName, branchId, createdBy, context);

                          Navigator.pop(context);
                          callSnackBar(updationMessage, "success");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bv_primaryDarkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "UPDATE",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
                  // Extract course names
                  String courseNames = notification.courses!.map((course) => course.name).join(", ");
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(px20),
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
                            showNotificationSettingsDialog(notification.id.toString(),notification.notificationDay, context);

                          }
                          else if(value == "feedback"){

                            // Show loading indicator before fetching data
                            showDialog(
                              context: context,
                              barrierDismissible: false, // Prevent closing dialog manually
                              builder: (context) {
                                return const Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: grey_400,
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                );
                              },
                            );
                            // Load feedback data
                            await loadFeedBackListData(notification.id.toString());

                            // Close the loading dialog
                            Navigator.pop(context);

                            // Show feedback dialog
                            showFeedbackDialog(feedbackData,notification.id.toString(),context);

                          }
                          else if(value == "date"){
                            showUpcomingDateDialog(notification.inquiryDate,notification.id.toString(),context);

                          }
                          else if(value == "status"){

                            // Show loading indicator before fetching data
                            showDialog(
                              context: context,
                              barrierDismissible: false, // Prevent closing dialog manually
                              builder: (context) {
                                return const Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: grey_400,
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                );
                              },
                            );
                            // load status list
                            await loadInquiryStatusListData();

                            // Close the loading dialog
                            Navigator.pop(context);
                            showInquiryStatusDialog(inquiryList,context);

                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(value: 'call', child: Text(call)),
                          PopupMenuItem<String>(value: 'settings', child: Text(notificationSettings)),
                          PopupMenuItem<String>(value: 'feedback', child: Text(feedbackHistory)),
                          PopupMenuItem<String>(value: 'date', child: Text(upcomingDate)),
                          PopupMenuItem<String>(value: 'status', child: Text(status)),
                        ],
                        icon: Icon(Icons.more_vert, color: black),
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
