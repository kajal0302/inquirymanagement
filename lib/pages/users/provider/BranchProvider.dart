import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/branch/apicall/branchListApi.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';

class BranchProvider extends ChangeNotifier {
  BranchListModel? _branch;
  bool _isLoading = false;

  BranchListModel? get branch => _branch;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setBranch(BranchListModel? branch) {
    _branch = branch;
    notifyListeners();
  }

  Future<void> getBranch(BuildContext context) async {
    setLoading(true);

    final branch = await fetchBranchListData(context);
    if(branch == null){
      setLoading(false);
    }
    setBranch(await branch);
    setLoading(false);
  }
}
