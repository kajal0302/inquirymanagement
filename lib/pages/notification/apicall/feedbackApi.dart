import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../model/feedbackModel.dart';

Future<FeedbackModel?> fetchFeedbackData(String inquiry_id, BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  FeedbackModel? returnData;

  await apiService.post<FeedbackModel>(
    endpoint: feedbackList,
    body: {
      'inquiry_id': inquiry_id,

    },
      fromJson: (json) => FeedbackModel.fromJson(json),
    onSuccess: (user) {
      if (kDebugMode) {
        print('Data fetched Successfully: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in fetching Data : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}