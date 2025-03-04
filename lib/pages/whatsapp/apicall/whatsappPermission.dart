import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/utils/apicall/method.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//
// Future<SmsPermissionList?> fetchWhatsappPermissionList(String cid) async {
//   bool checkInternet = await checkConnection();
//   if(!checkInternet){
//     callSnackBar(noInternetStr,"def");
//   }
//
//   final ApiService apiService = ApiService();
//   SmsPermissionList? returnData;
//
//   await apiService.get<SmsPermissionList>(
//     endpoint: "$wpPermissionEnableList?cid=$cid",
//     fromJson: SmsPermissionList.fromJson,
//     onSuccess: (user) {
//       if (kDebugMode) {
//         print('Logged in User: ${user.status} ${user.message}');
//       }
//       returnData = user;
//     },
//     onError: (errorMessage) {
//       if (kDebugMode) {
//         print('Error logging in: $errorMessage');
//       }
//       returnData = null;
//       callSnackBar(errorMessage,"danger");
//     },
//   );
//   return returnData;
// }
//
// Future<SuccessResponse?> enableWpPermission(String cid,String id,String status) async {
//   bool checkInternet = await checkConnection();
//   if(!checkInternet){
//     callSnackBar(noInternetStr,"def");
//   }
//
//   final ApiService apiService = ApiService();
//   SuccessResponse? returnData;
//
//   await apiService.post<SuccessResponse>(
//     endpoint: wpPermissionEnable,
//     fromJson: SuccessResponse.fromJson,
//     body: {
//       "permission":status,
//       "id":id,
//       "cid":cid
//     },
//     onSuccess: (user) {
//       if (kDebugMode) {
//         print('Logged in User: ${user.status} ${user.message}');
//       }
//       returnData = user;
//     },
//     onError: (errorMessage) {
//       if (kDebugMode) {
//         print('Error logging in: $errorMessage');
//       }
//       returnData = null;
//       callSnackBar(errorMessage,"danger");
//     },
//   );
//   return returnData;
// }
