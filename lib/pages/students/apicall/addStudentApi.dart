import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/branch/model/addBranchModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<SuccessModel?> createStudentData(
    BuildContext context,
    String login_id,
    String fname,
    String lname,
    String mobileno,
    String wamobileno,
    String email,
    String dob,
    String gender,
    String branch_id,
    String username,
    String password,
    String parentname,
    String parentmobileno,
    String address,
    String batch_id,
    String standard_id,
    String subject_id,
    String discount,
    String joining_date,
    String reference,
    String partner_id
    ) async {
    bool checkInternet = await checkConnection();
    if (!checkInternet) {
      callSnackBar(noInternetStr, "def");
      return null;
    }

    final ApiService apiService = ApiService();
    SuccessModel? returnData;

  try {
    returnData = await apiService.post<SuccessModel>(
        body: {
          "login_id":login_id,
          "fname": fname,
          "lname": lname,
          "mobileno": mobileno,
          "wamobileno": wamobileno,
          "email": email,
          "dob": dob,
          "gender": gender,
          "branch_id": branch_id,
          "username": username,
          "password": password,
          "parentname": parentname,
          "parentmobileno": parentmobileno,
          "address": address,
          "batch_id": batch_id,
          "standard_id": standard_id,
          "subject_id": subject_id,
          "discount": discount,
          "joining_date": joining_date,
          "reference": reference,
          "partner_id": partner_id,

        },
        fromApi: true,
        endpoint: addStudentUri,
        fromJson: (json) => SuccessModel.fromJson(json));

  }on ApiException catch (e) {
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
