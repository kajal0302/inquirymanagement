import 'package:flutter/material.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/button.dart';
import '../../../components/customCalender.dart';
import '../../../components/customDialog.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../notification/apicall/updateInquiryStatus.dart';
import '../../notification/components/customDialogBox.dart';
import '../../notification/model/inquiryStatusListModel.dart';

class SmsPage extends StatefulWidget {
  const SmsPage({super.key});

  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  String branchId = userBox.get('branch_id').toString();
  String createdBy = userBox.get('id').toString();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? startDateString;
  String? endDateString;
  bool isLoading = true;


  TextEditingController messageController = TextEditingController();


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

  // Add Status Dialog Box
  void showStatusDialog(InquiryStatusModel? inquiryList, BuildContext context) {
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
                        bool isSelected = selectedId == status.id;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForAboutPage(context, "SMS", DashboardPage()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
            child: TextField(
              controller: messageController,
              maxLines: 5,
              maxLength: 119,
              decoration: InputDecoration(
                filled: true,
                fillColor: grey_100,
                hintText: "Type your message here... (Maximum 119 characters allowed)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                btnWidget(
                  btnBgColor: primaryColor,
                  btnBrdRadius: BorderRadius.circular(px35),
                  btnLabel: "SELECT STUDENT",
                  btnLabelColor: white,
                  btnLabelFontSize: px16,
                  btnLabelFontWeight: FontWeight.bold,
                  onClick: (){},
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15),
                    backgroundColor: primaryColor,
                  ),
                  child: Icon(
                    Icons.send,
                    color: white,
                    size: px28,
                  ),
                ),
              ],
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
