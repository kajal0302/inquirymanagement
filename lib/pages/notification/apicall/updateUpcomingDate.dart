import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/branch/model/addBranchModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

Future<SuccessModel?> UpdateUpcomingDate(String id,String upcoming_confirm_date,String branch_id,String created_by, BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  SuccessModel? returnData;

  await apiService.post<SuccessModel>(
    endpoint: updateUpcomingDate,
    body: {
      'id': id,
      'upcoming_confirm_date': upcoming_confirm_date,
      'branch_id': branch_id,
      'created_by': created_by,
    },
    fromJson: SuccessModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Data Updated Successfully: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in Updating Data : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}