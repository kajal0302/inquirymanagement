import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/whatsapp/models/MessageModel.dart';
import 'package:inquirymanagement/utils/apicall/method.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<MessagesModel?> fetchContactMessage(
    String contactId,
    String phoneId,
    String phoneNumber
    ) async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  MessagesModel? returnData;

  await apiService.post(
    endpoint: messagesApi,
    body: {
      'contactId': contactId,
      'phoneId': phoneId,
      'phoneNumber':phoneNumber
    },
    wp: true,
    fromJson: MessagesModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Logged in User: ${user.message}');
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