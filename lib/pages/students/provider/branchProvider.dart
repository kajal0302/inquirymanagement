import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/students/apicall/branchListApi.dart';
import 'package:inquirymanagement/pages/students/models/branchListModel.dart';


class StudentBranchProvider extends ChangeNotifier {
  StudentBranchListModel? _branch;
  bool _isLoading = false;

  StudentBranchListModel? get branch => _branch;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setBranch(StudentBranchListModel? branch) {
    _branch = branch;
    notifyListeners();
  }

  Future<void> getBranch(BuildContext context) async {
    setLoading(true);

    final branch = await fetchStudentBranchListData(context);
    if(branch == null){
      setLoading(false);
    }
    setBranch(await branch);
    setLoading(false);
  }
}
