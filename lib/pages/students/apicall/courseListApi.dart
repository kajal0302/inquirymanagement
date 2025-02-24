import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/students/models/courseListModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<StudentCourseListModel?> fetchStudentCourseListData(BuildContext context , String category_id) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  StudentCourseListModel? returnData;

  try {
    returnData = await apiService.post<StudentCourseListModel>(
        body: {"category_id": category_id},
        endpoint: courseUri,
        fromJson: (json) => StudentCourseListModel.fromJson(json));
  }on ApiException catch (e) {
    if (e.statusCode == 408) {
      callSnackBar("time out error", danger);
      returnData = null;
      // showTimeoutError();
    } else {
      callSnackBar(e.message, danger);
      returnData = null;
    }
  }
  return returnData;
}
