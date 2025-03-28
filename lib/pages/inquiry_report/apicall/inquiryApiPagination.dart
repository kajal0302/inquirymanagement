import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<InquiryModel?> fetchInquiryDataPagination(String branch_id, String? status, List<String>? notInStatus, BuildContext context, int page , int limit) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  InquiryModel? returnData;

  Map<String, dynamic> body = {
    'branch_id': branch_id,
    if (status != null && status.isNotEmpty) 'status': status,
    if (notInStatus != null && notInStatus.isNotEmpty)
    'notInStatus': jsonEncode(notInStatus),
    "limit": limit.toString(),
    "offset": page.toString(),
  };

  try {
    returnData = await apiService.post<InquiryModel>(
        body:body,
        fromApi: false,
        endpoint: inquiries,
        fromJson: (json) => InquiryModel.fromJson(json));

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
