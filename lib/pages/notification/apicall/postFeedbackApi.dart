import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/branch/model/addBranchModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

Future<SuccessModel?> createFeedbackData(String inquiry_id,String feedback,String branch_id, BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  SuccessModel? returnData;

  await apiService.post<SuccessModel>(
    endpoint: addFeedback,
    body: {
      'inquiry_id': inquiry_id,
      'feedback': feedback,
      'branch_id': branch_id,

    },
    fromJson: SuccessModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Data Created Successfully: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in Creating Data : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}