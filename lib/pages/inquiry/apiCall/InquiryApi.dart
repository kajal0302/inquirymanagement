import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';
import 'package:inquirymanagement/pages/users/models/SuccessResponse.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<SuccessResponse?> postInquiries(
    BuildContext context,
    String fName,
    String lName,
    String branch_id,
    String feedback,
    String reference,
    String mobileNo,
    String partner_id,
    String course_id,
    String standard_id,
    String subject_id,
    String date,
    String upcoming_confirm_date,
    String smsMessageId,
    String created_by) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  SuccessResponse? returnData;

  try {
    returnData = await apiService.post<SuccessResponse>(
       body: {
         "fname":fName,
         "lname":lName,
         "branch_id":branch_id,
         "feedback":feedback,
         "reference":reference,
         "mobileno":mobileNo,
         "partner_id":partner_id,
         "course_id":course_id,
         "standard_id":standard_id,
         "subject_id":subject_id,
         "date":date,
         "upcoming_confirm_date":upcoming_confirm_date,
         "smsmessage_id":smsMessageId,
         "created_by":created_by,
       },
        endpoint: postInquiriesUri,
        fromJson: (json) => SuccessResponse.fromJson(json));
  } on ApiException catch (e) {
    if (e.statusCode == 408) {
      callSnackBar("time out error", danger);
      returnData = null;
    } else {
      callSnackBar(e.message, danger);
      returnData = null;
    }
  }
  return returnData;
}
