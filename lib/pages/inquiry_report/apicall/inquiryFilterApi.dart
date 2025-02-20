import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

Future<InquiryModel?> FilterInquiryData(String? courses_id, String? start_date,String? end_date, String? branch_id, String? status, BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  InquiryModel? returnData;

  await apiService.post<InquiryModel>(
    endpoint: filterInquiry,
    body: {
      if (courses_id != null && courses_id.isNotEmpty) 'courses_id': courses_id,
      if (start_date != null && start_date.isNotEmpty) 'start_date': start_date,
      if (end_date != null && end_date.isNotEmpty) 'end_date': end_date,
      if (branch_id != null && branch_id.isNotEmpty) 'branch_id': branch_id,
      if (status != null && status.isNotEmpty) 'status': status,
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