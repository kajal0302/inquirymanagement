import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/students/apicall/categoryListApi.dart';
import 'package:inquirymanagement/pages/students/models/categoryListModel.dart';

class CategoryProvider extends ChangeNotifier {
  StudentCategoryListModel? _category;
  bool _isLoading = false;

  StudentCategoryListModel? get category => _category;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCategory(StudentCategoryListModel? category) {
    _category = category;
    notifyListeners();
  }

  Future<void> getCategory(BuildContext context) async {
    setLoading(true);

    final category = await fetchStudentCategoryListData(context);
    if(category == null){
      setLoading(false);
    }
    setCategory(await category);
    setLoading(false);
  }
}
