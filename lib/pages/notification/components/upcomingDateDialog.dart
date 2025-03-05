import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../branch/model/addBranchModel.dart';
import '../apicall/updateUpcomingDate.dart';
import 'customDialogBox.dart';


class UpcomingDateDialog extends StatefulWidget {
  final String inquiryDate;
  final String inquiryId;

  const UpcomingDateDialog({
    Key? key,
    required this.inquiryDate,
    required this.inquiryId,
  }) : super(key: key);

  @override
  _UpcomingDateDialogState createState() => _UpcomingDateDialogState();
}

class _UpcomingDateDialogState extends State<UpcomingDateDialog> {
  late DateTime selectedDate;
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  SuccessModel? addFeedback;
  @override
  void initState() {
    super.initState();
    DateFormat format = DateFormat("dd-MM-yyyy");
    selectedDate = format.parse(widget.inquiryDate);
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

  @override
  Widget build(BuildContext context) {
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
              await updateUpcomingDate(widget.inquiryId,dateValue );
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
  }
}


