import 'package:flutter/cupertino.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/ApiService.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';


Future<InquiryModel?> fetchUpcomingInquiryData(String? today, String? tomorrow, String? sevenDays,String branch_id, BuildContext context)async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  InquiryModel? returnData;

  try {
    returnData = await apiService.post<InquiryModel>(
        body: {
          "today":today,
          "tomorrow": tomorrow,
          "7days": sevenDays,
          "branch_id": branch_id,
        },
        fromApi: false,
        endpoint: updateUpcomingDate,
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

