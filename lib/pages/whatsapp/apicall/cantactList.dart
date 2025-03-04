import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/whatsapp/models/ContactListModel.dart';
import 'package:inquirymanagement/utils/apicall/method.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

Future<ContactListModel?> contactList(String wpId) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  ContactListModel? returnData;

  await apiService.get<ContactListModel>(
    endpoint: "$contactListApi?wp_id=$wpId&api_key=$wpApiKey",
    wp: true,
    fromJson: ContactListModel.fromJson,
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