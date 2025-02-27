import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/inquiry/models/inquiryModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<InquiryModel?> fetchInquiryDetailData(BuildContext context , String id) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  InquiryModel? returnData;

  try {
    returnData = await apiService.post<InquiryModel>(
        body: {"id": id},
        fromApi: false,
        endpoint: inquiryDetail,
        fromJson: (json) => InquiryModel.fromJson(json));
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
