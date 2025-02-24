import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:inquirymanagement/pages/inquiry_report/apicall/inquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry_report/components/inquiryCardSkeleton.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:inquirymanagement/utils/lists.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/alertBox.dart';
import '../../../components/appBar.dart';
import '../../../components/customCalender.dart';
import '../../../components/customDialog.dart';
import '../../../components/dateField.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/urlLauncherMethods.dart';
import '../../branch/model/addBranchModel.dart';
import '../../dashboard/screen/dashboard.dart';
import '../../login/screen/login.dart';
import '../../notification/apicall/feedbackApi.dart';
import '../../notification/apicall/inquiryStatusListApi.dart';
import '../../notification/apicall/postFeedbackApi.dart';
import '../../notification/apicall/updateInquiryStatus.dart';
import '../../notification/apicall/updateNotificationDay.dart';
import '../../notification/components/customDialogBox.dart';
import '../../notification/model/feedbackModel.dart';
import '../../notification/model/inquiryStatusListModel.dart';
import '../../students/screen/StudentForm.dart';
import '../apicall/inquiryFilterApi.dart';
import '../apicall/inquirySearchFilter.dart';

class InquiryReportPage extends StatefulWidget {
  const InquiryReportPage({super.key});

  @override
  State<InquiryReportPage> createState() => _InquiryReportPageState();
}

class _InquiryReportPageState extends State<InquiryReportPage> {
  String branchId = userBox.get('branch_id').toString();
  String createdBy = userBox.get('id').toString();
  bool isLoading = true;
  InquiryModel? inquiryData;
  FeedbackModel? feedbackData;
  SuccessModel? addFeedback;
  InquiryStatusModel? inquiryList;
  InquiryModel? filteredInquiryData;
  InquiryModel? inquirySearchedData;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? startDateString;
  String? endDateString;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    loadinquiryData();
  }

// Method for Day Selection
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  // Method for range selection
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _focusedDay = focusedDay;

      startDateString = _rangeStart != null ? formatDate(_rangeStart!) : "";
      endDateString = _rangeEnd != null ? formatDate(_rangeEnd!) : "";
    });

  }


  // Method to load inquiry data
  Future <InquiryModel?> loadinquiryData( ) async{
    InquiryModel? fetchedInquiryListData = await fetchInquiryData(branchId, inquiry, context);
    if(mounted){
      setState(() {
        inquiryData = fetchedInquiryListData;
      });
    }
    isLoading=false;
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
  Future <void> loadInquiryStatusListData() async{
    InquiryStatusModel? inquiryStatusList = await fetchInquiryStatusList(context);
    if(mounted){
      setState(() {
        inquiryList = inquiryStatusList;
      });
    }

    print(inquiryList);
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
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InquiryReportPage()));
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

  // Add Status Dialog Box
  void showInquiryStatusDialog(InquiryStatusModel? inquiryList, BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      String selectedId = '';
      String selectedName = '';
      String selectedStatusId = '';

      return StatefulBuilder(
        builder: (context, setState) {
          return CustomDialog(
            title: "Status",
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
                        "FIND",
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


// Handle Menu Selection
  void handleMenuSelection(int value) async{
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


  // Updating Filtered Data
  void fetchFilteredInquiryData() async {
    setState(() {
      isLoading = true;
    });

    InquiryModel? fetchedFilteredInquiryData = await FilterInquiryData(
        null, startDateString, endDateString, branchId, null, context
    );


    setState(() {
      inquiryData = fetchedFilteredInquiryData;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForInquiryReport(
        context,
        "Inquiry Report",
        DashboardPage(),
            (menuValue) {
          handleMenuSelection(menuValue);
        },
            (searchQuery) async {
          InquiryModel? result = await inquirySearchFilter(null, searchQuery, context);
          if (result != null) {
            setState(() {
              inquiryData = result;
            });
          }
        },
      ),
      body: Column(
        children: [
          isLoading
              ? Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const InquiryCardSkeleton(),
            ),
          )
              : (inquiryData!.inquiries!.isNotEmpty && inquiryData != null)
              ? Expanded(
            child: ListView.builder(
              itemCount: inquiryData!.inquiries!.length,
              itemBuilder: (context, index) {
                final inquiry = inquiryData!.inquiries![index];
                // Extract course names
                String courseNames = inquiry.courses!.map((course) => course.name).join(", ");
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(px20),
                  ),
                  color: bv_secondaryLightColor3,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    leading: Image.asset(userImg,height: 50,width: 50,),
                    title: Text(
                      "${inquiry.fname} ${inquiry.lname}",
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
                          makePhoneCall(inquiry.contact!);
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
                          await loadFeedBackListData(inquiry.id.toString());

                          // Close the loading dialog
                          Navigator.pop(context);

                          // Show feedback dialog
                          showFeedbackDialog(feedbackData,inquiry.id.toString(),context);

                        }
                        else if(value == "settings"){
                          showNotificationSettingsDialog(inquiry.id.toString(),inquiry.notificationDay!, context);

                        }
                        else if(value == "student"){
                          Navigator.push(context, MaterialPageRoute(builder: (contex)=>StudentForm(
                            id: inquiry.id,
                            fname: inquiry.fname,
                            lname: inquiry.lname,
                          )));
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(value: 'call', child: Text(call)),
                        PopupMenuItem<String>(value: 'feedback', child: Text(feedbackHistory)),
                        PopupMenuItem<String>(value: 'settings', child: Text(notificationSettings)),
                        PopupMenuItem<String>(value: 'student', child: Text(convertStudent)),
                      ],
                      icon: Icon(Icons.more_vert, color: black),
                    ),
                  ),
                );
              },
            ),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 170),
            child: Center(
              child: Text(
                dataNotAvailable,
                style: TextStyle(color: black),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomSpeedDial(
        onCalendarTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: preIconFillColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Select Date Range',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 600,
                        height: 400,
                        child: CustomCalendar(
                          initialFormat: _calendarFormat,
                          initialFocusedDay: _focusedDay,
                          initialSelectedDay: _selectedDay,
                          initialRangeStart: _rangeStart,
                          initialRangeEnd: _rangeEnd,
                          onDaySelected: _onDaySelected,
                          onRangeSelected: _onRangeSelected,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          isLoading = true;
                        });
                        if (mounted) {
                          setState(() {
                            fetchFilteredInquiryData();
                          });
                        }
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        onFilterTap: () => print("Filter Icon Pressed"),
        backgroundColor: preIconFillColor,
        iconColor: Colors.black,
        iconSize: 25.0,
      ),
    );
  }
}
