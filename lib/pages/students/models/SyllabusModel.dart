class SyllabusModel {
  String? status;
  String? message;
  List<Data>? data;

  SyllabusModel({this.status, this.message, this.data});

  SyllabusModel.fromJson(Map<String, dynamic> json) {
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
  bool? isChecked;
  String? studentName;
  String? name;
  String? studentId;
  String? syllabusName;
  String? id;
  String? branchId;
  String? standardId;
  String? subjectId;
  String? syllabusContentId;
  String? title;
  String? contentDescription;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? isDelete;

  Data(
      {this.studentName,
        this.isChecked,
        this.name,
        this.studentId,
        this.syllabusName,
        this.id,
        this.branchId,
        this.standardId,
        this.subjectId,
        this.syllabusContentId,
        this.title,
        this.contentDescription,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isDelete});

  Data.fromJson(Map<String, dynamic> json) {
    studentName = json['student_name'];
    isChecked = json['status'] == "1" ? true : false;
    name = json['name'];
    studentId = json['studentId'];
    syllabusName = json['syllabus_name'];
    id = json['id'];
    branchId = json['branch_id'];
    standardId = json['standard_id'];
    subjectId = json['subject_id'];
    syllabusContentId = json['syllabus_content_id'];
    title = json['title'];
    contentDescription = json['content_description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['student_name'] = studentName;
    data['name'] = name;
    data['studentId'] = studentId;
    data['syllabus_name'] = syllabusName;
    data['id'] = id;
    data['branch_id'] = branchId;
    data['standard_id'] = standardId;
    data['subject_id'] = subjectId;
    data['syllabus_content_id'] = syllabusContentId;
    data['title'] = title;
    data['content_description'] = contentDescription;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_delete'] = isDelete;
    return data;
  }
}