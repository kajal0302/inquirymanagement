import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/branch/model/addBranchModel.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';

Future<SuccessModel?> studentFormSubmit(
    String? id,
    String standardId,
    String subjectId,
    String parentName,
    String gender,
    String batchId,
    String discount,
    String mobileNo,
    String courseStatus,
    String reference,
    String? password,
    String lName,
    String installmentDate,
    String branchId,
    String waMobileNo,
    String email,
    String loginId,
    String fName,
    String joiningDate,
    String address,
    String installmentType,
    String parentMobileNo,
    String dob,
    String cPassword,
    String? username,
    String cid,
    File? file
    ) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  SuccessModel? returnData;

  await apiService.post(
    endpoint: "",
    body: {
      if (username != null && username != "") 'username': username,
      if (password != null && password != "") 'password': password,
      if (id != null && id != "") 'id': id,
      'dob': dob,
      'cid': cid,
      'standard_id':standardId,
      'subject_id':subjectId,
      'parentname':parentName,
      'gender':gender,
      'batch_id':batchId,
      'discount':discount,
      'mobileno':mobileNo,
      'course_status':courseStatus,
      'reference':reference,
      'lname':lName,
      'installment_date':installmentDate,
      'branch_id':branchId,
      'wamobileno':waMobileNo,
      'email':email,
      'login_id':loginId,
      'fname':fName,
      'joining_date':joiningDate,
      'address':address,
      'installment_type':installmentType,
      'parentmobileno':parentMobileNo,
      'cpassword':cPassword,
    },
    // file: file,
    fromJson: SuccessModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Logged in User: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error logging in: $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}

Future<SuccessModel?> installmentFormSubmit(
    String id,
    String loginId,
    String joiningDate,
    String branchId,
    String installmentParams,
    String installmentAmount,
    String installmentType,
    String cid,
    ) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  SuccessModel? returnData;

  await apiService.post(
    endpoint: "",
    body: {
      "id":id,
      "joining_date":joiningDate,
      "branch_id":branchId,
      "login_id":loginId,
      "installment_amount":installmentAmount,
      "installMentParams":installmentParams,
      "installment_type":installmentType,
      "cid":cid
    },
    fromJson: SuccessModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Logged in User: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error logging in: $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}
