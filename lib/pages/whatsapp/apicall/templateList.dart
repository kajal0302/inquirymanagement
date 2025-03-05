import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/whatsapp/models/TemplateListModel.dart';
import 'package:inquirymanagement/utils/apicall/method.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:flutter/foundation.dart';
import '../../../utils/constants.dart';

Future<TemplateListModel?> fetchTemplateList() async {
  bool checkInternet = await checkConnection();
  if (!checkInternet) {
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  TemplateListModel? returnData;

  await apiService.get(
    endpoint: "$templateList?cid=Allcm",
    fromJson: TemplateListModel.fromJson,
    qt:true,
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