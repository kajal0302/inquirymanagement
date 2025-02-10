import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../../common/text.dart';
import '../../../utils/apicall/method.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../model/loginUser.dart';


Future<LoginUserModel?> fetchData(String username, String password, String token, BuildContext context) async {
  bool checkInternet = await checkConnection();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.id}');
  if(!checkInternet){
    callSnackBar(noInternetStr,"def");
  }

  final ApiService apiService = ApiService();
  LoginUserModel? returnData;

  await apiService.post<LoginUserModel>(
    endpoint: loginUser,
    body: {
      'username': username,
      'password': password,
      'token' : "9c70933aff6b2a6d08c687a6cbb6b765"
    },
    fromJson: LoginUserModel.fromJson,
    onSuccess: (user) {
      if (kDebugMode) {
        print('User Logged in: ${user.status} ${user.message}');
      }
      returnData = user;
    },
    onError: (errorMessage) {
      if (kDebugMode) {
        print('Error in logging : $errorMessage');
      }
      returnData = null;
      callSnackBar(errorMessage,"danger");
    },
  );
  return returnData;
}