import 'dart:convert';
import 'dart:io';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/users/models/SuccessResponse.dart';
import 'package:inquirymanagement/utils/apicall/method.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:flutter/foundation.dart';

Future<SuccessResponse?> whatsappMessageSend(
    String whatsappTypesId,
    String url,
    String typeHeader,
    String header,
    String contacts,
    List<String> body,
    String url1,
    String url2,
    String copyCode,
    String cid,
    File? file
    ) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  SuccessResponse? returnData;

  await apiService.postMedia(
    endpoint: whatsappMessageSendApi,
    file:file,
    body: {
      'whatsapp_types_id': whatsappTypesId,
      'url':url,
      'type_header':typeHeader,
      'header':header,
      'contacts':contacts,
      'body':jsonEncode(body),
      'url1':url1,
      'url2':url2,
      'copy_code':copyCode,
      'cid': cid,
    },
    fromJson: SuccessResponse.fromJson,
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