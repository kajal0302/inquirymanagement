import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/users/models/SuccessResponse.dart';
import 'package:inquirymanagement/pages/users/models/UserModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<UserModel?> fetchUsers(BuildContext context, String branchId) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  UserModel? returnData;

  try {
    returnData = await apiService.post<UserModel>(
        body: {"branch_id": branchId},
        endpoint: userUri,
        fromJson: (json) => UserModel.fromJson(json));
  } on ApiException catch (e) {
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

// postUser
Future<SuccessResponse?> postUsers(
    BuildContext context,
    String name,
    String address,
    String mobile_no,
    String email,
    String designation,
    String dob,
    String gender,
    String username,
    String pwd,
    String branch_id,
    String joining_date,
    String user_type,
    String created_by,
    String slug,
    File? file) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr, "def");
    return null;
  }

  final ApiService apiService = ApiService();
  SuccessResponse? returnData;

  try {
    returnData = await apiService.postMedia<SuccessResponse>(
        file: file,
        body: {
          "name": name,
          "address":address,
          "mobile_no":mobile_no,
          "email":email,
          "designation":designation,
          "dob":dob,
          "gender":gender,
          "username":username,
          "pwd":pwd,
          "branch_id":branch_id,
          "joining_date":joining_date,
          "user_type":user_type,
          "created_by":created_by,
          if(slug != "") "slug":slug,
        },
        endpoint: postUserUri,
        fromJson: (json) => SuccessResponse.fromJson(json));
  } on ApiException catch (e) {
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
