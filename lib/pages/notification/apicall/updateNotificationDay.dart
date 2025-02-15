import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/branch/model/addBranchModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

Future<SuccessModel?> UpdateNotificationDay(String id,String day,String end_notification_date,String message_content,String created_by,String branch_id, BuildContext context) async {
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
      'day': day,
      'end_notification_date': end_notification_date,
      'message_content': message_content,
      'created_by': created_by,
      'branch_id': branch_id,
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