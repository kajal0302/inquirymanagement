import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

Future<InquiryModel?> inquirySearchFilter(String? courses_id, String? search, BuildContext context, String branch_id) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  InquiryModel? returnData;

  await apiService.post<InquiryModel>(
    endpoint: filterInquiry,
    body: {
      'branch_id': branch_id,
      if (courses_id != null && courses_id.isNotEmpty) 'courses_id': courses_id,
      if (search != null && search.isNotEmpty) 'search': search,
    },
    fromJson: InquiryModel.fromJson,
    onSuccess: (data) {
      if (kDebugMode) {
        print('Data Fetched Successfully: ${data.status} ${data.message}');
      }
      returnData = data;
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