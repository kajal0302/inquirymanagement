import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/students/models/batchListModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';


Future<StudentBatchListModel?> fetchStudentBatchListData(BuildContext context) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  StudentBatchListModel? returnData;

  try {
    returnData = await apiService.get<StudentBatchListModel>(
        fromApi: true,
        endpoint: batchUri,
        fromJson: (json) => StudentBatchListModel.fromJson(json));
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
