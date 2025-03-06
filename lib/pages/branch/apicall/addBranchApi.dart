import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../model/addBranchModel.dart';


Future<SuccessModel?> createBranchData(String name, String address, String contact_no, String email, String map_location, String created_by, String? slug, BuildContext context) async {
  bool checkInternet = await checkConnection();
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  SuccessModel? returnData;

  await apiService.post<SuccessModel>(
    endpoint: addBranch,
    body: {
      'name': name,
      'address': address,
      'contact_no': contact_no,
      'email': email,
      'map_location': map_location,
      'created_by': created_by,
      if(slug != null && slug != "") 'slug':slug,

    },
    fromJson: SuccessModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('Data Created Successfully: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in Creating Data : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}