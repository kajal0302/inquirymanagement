import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirymanagement/pages/branch/model/branchList.dart';
import 'package:inquirymanagement/utils/constants.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';

Future<BranchListModel?> fetchBranchListData(BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  BranchListModel? returnData;

  await apiService.get<BranchListModel>(
    endpoint: branchList,
    fromJson: (json) => BranchListModel.fromJson(json),
    onSuccess: (data) {
      if (kDebugMode) {
        print('Data Fetched Succefully: ${data.status} ${data.message}');
      }
      returnData = data;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in Fetching Data: $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}