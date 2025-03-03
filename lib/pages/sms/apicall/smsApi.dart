import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/branch/model/addBranchModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<SuccessModel?> SendSms(String mobile_no, String message_content) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  SuccessModel? returnData;

  try {
    returnData = await apiService.post<SuccessModel>(
        body: {
          "mobile_no": mobile_no,
          "message_content": message_content,
        },
        fromApi: false,
        endpoint: sms,
        fromJson: (json) => SuccessModel.fromJson(json));

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
