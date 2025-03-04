import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/users/models/SuccessResponse.dart';
import 'package:inquirymanagement/utils/apicall/method.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:flutter/foundation.dart';

Future<SuccessResponse?> whatsappTextMessageSend(
    String body,
    String number,
    String cid,
    ) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  SuccessResponse? returnData;

  await apiService.post(
    temp: true,
    endpoint: whatsappTextMessageSendApi,
    body: {
      'text':body,
      'contact':number,
      'cid': "Allcm",
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