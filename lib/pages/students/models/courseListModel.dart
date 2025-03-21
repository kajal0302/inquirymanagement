class StudentCourseListModel {
  String? status;
  String? message;
  List<Courses>? courses;

  StudentCourseListModel({this.status, this.message, this.courses});

  StudentCourseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  String? id;
  String? name;
  String? fees;
  String? duration;
  String? image;

  Courses({this.id, this.name, this.fees, this.duration, this.image});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    fees = json['fees'] != null ? json['fees'].toString() : '0';
    duration = json['duration'].toString();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['fees'] = this.fees;
    data['duration'] = this.duration;
    data['image'] = this.image;
    return data;
  }
}