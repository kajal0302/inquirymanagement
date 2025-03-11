import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../model/inquiryModel.dart';

Future<InquiryModel?> fetchInquiryData(String branch_id, String status,String? referenceBy, BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  InquiryModel? returnData;

  await apiService.post<InquiryModel>(
    endpoint: inquiries,
    body: {
      'branch_id': branch_id,
      'status': status,
      if (referenceBy != null) "referenceBy": referenceBy,
    },
    fromJson: InquiryModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Data Fetched Successfully: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in Fetching Data : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}