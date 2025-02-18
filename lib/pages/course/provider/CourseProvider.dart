import 'package:flutter/material.dart';
import 'package:inquirymanagement/pages/course/apiCall/fetchCourseListData.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';

class CourseProvider extends ChangeNotifier {
  CourseModel? _course;
  bool _isLoading = false;

  CourseModel? get course => _course;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCourse(CourseModel? course) {
    _course = course;
    notifyListeners();
  }

  Future<void> getCourse(BuildContext context) async {
    setLoading(true);

    final course = await fetchCourseListData(context);
    if(course == null){
      setLoading(false);
    }
    setCourse(await course);
    setLoading(false);
  }
}
