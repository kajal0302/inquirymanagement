import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/alertBox.dart';
import '../../../components/dateField.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/lists.dart';
import '../../login/screen/login.dart';
import '../apicall/updateNotificationDay.dart';
import '../screen/notification.dart';
import 'customDialogBox.dart';


class InquiryNotificationDialog extends StatefulWidget {
  final String inquiryId;
  final String notificationDay;

  const InquiryNotificationDialog({
    Key? key,
    required this.inquiryId,
    required this.notificationDay,
  }) : super(key: key);

  @override
  _InquiryNotificationDialogState createState() => _InquiryNotificationDialogState();
}

class _InquiryNotificationDialogState extends State<InquiryNotificationDialog> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();


  ///  Date Selection Method
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
              primary: preIconFillColor, /// background of the date
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


  ///  Message Dialog for Add message
  Future<void> showMessageDialog(
      String inquiryId,
      String day,
      String date,
      BuildContext context,
      ) async {
    TextEditingController messageController = TextEditingController();
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
              /// Feedback TextField
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
              /// Buttons Row
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialogBox(
                                  message: "Are you sure?",
                                  onPress: () async {
                                    await UpdateNotificationDay(
                                      inquiryId,
                                      day,
                                      date,
                                      message,
                                      createdBy,
                                      branchId,
                                      context,
                                    );
                                    callSnackBar(updationMessage, "success");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotificationPage(),
                                      ),
                                    );
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

  @override
  Widget build(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController dayController = TextEditingController();
    /// Get the index of notificationDay in days list
    int selectedOption = days.indexOf(widget.notificationDay);
    if (selectedOption == -1) {
      selectedOption = 3;
    }
    String selectedOptionValue = days[selectedOption];
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dayController.text = selectedOptionValue;;
    return StatefulBuilder(
        builder: (context,setState) {
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
                                showMessageDialog(widget.inquiryId,dayValue,dateValue,context);
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
        }
    );
  }
}


