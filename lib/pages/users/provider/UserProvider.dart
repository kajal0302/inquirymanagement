import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/users/apiCall/UserApi.dart';
import 'package:inquirymanagement/pages/users/models/UserModel.dart';
import 'package:inquirymanagement/utils/apicall/ApiService.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> getUsers(BuildContext context, String branchId) async {
    setLoading(true);

    final user = await fetchUsers(context, branchId);
    if(user == null){
      setLoading(false);
    }
    setUser(await user);
    setLoading(false);
  }
}
