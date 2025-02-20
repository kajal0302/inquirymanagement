class StudentEnrollCourses {
  String? status;
  String? message;
  List<Data>? data;

  StudentEnrollCourses({this.status, this.message, this.data});

  StudentEnrollCourses.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? subjectId;
  String? name;

  Data({this.subjectId, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['name'] = this.name;
    return data;
  }
}