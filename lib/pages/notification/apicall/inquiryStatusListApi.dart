import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/notification/model/inquiryStatusListModel.dart';
import 'package:inquirymanagement/utils/constants.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';

Future<InquiryStatusModel?> fetchInquiryStatusList(BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  InquiryStatusModel? returnData;

  await apiService.get<InquiryStatusModel>(
    endpoint: inquiryStatusList,
    fromJson: (json) => InquiryStatusModel.fromJson(json),
    onSuccess: (data) {
      if (kDebugMode) {
        print('Data Fetched Successfully: ${data.status} ${data.message}');
      }
      returnData = data;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in Fetching Data: $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}