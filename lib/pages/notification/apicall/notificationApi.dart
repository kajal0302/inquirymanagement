import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/notification/model/notificationModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

Future<NotificationModel?> fetchNotificationData(String branch_id, BuildContext context, int? page, int? limit,bool isDashboard) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  NotificationModel? returnData;

  await apiService.post<NotificationModel>(
    endpoint: notification,
    body: {
      'branch_id': branch_id,
      if(page != null) 'offset' : page.toString(),
      if(limit != null) 'limit': limit.toString(),
      'status' : isDashboard ? "dashboard" : "fallup"
    },
    fromJson: NotificationModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Data fetched Successfully: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in fetching Data : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}


Future<NotificationModel?> fetchNotificationCount(String branch_id,String? status) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  NotificationModel? returnData;

  await apiService.post<NotificationModel>(
    endpoint: notificationCountUri,
    body: {
      'branch_id': branch_id,
      if(status != null && status.isNotEmpty)'status' : status
    },
    fromJson: NotificationModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Data fetched Successfully: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in fetching Data : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}