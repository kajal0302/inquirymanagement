class FeedbackModel {
  String? status;
  String? message;
  List<Feedbacks>? feedbacks;

  FeedbackModel({this.status, this.message, this.feedbacks});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Feedbacks'] != null) {
      feedbacks = <Feedbacks>[];
      json['Feedbacks'].forEach((v) {
        feedbacks!.add(new Feedbacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.feedbacks != null) {
      data['Feedbacks'] = this.feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedbacks {
  int? id;
  String? studentId;
  int? branchId;
  String? feedback;
  String? date;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? deletedAt;
  int? inquiryId;

  Feedbacks(
      {this.id,
        this.studentId,
        this.branchId,
        this.feedback,
        this.date,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.deletedAt,
        this.inquiryId});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    branchId = json['branch_id'];
    feedback = json['feedback'];
    date = json['date'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    inquiryId = json['inquiry_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['branch_id'] = this.branchId;
    data['feedback'] = this.feedback;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['inquiry_id'] = this.inquiryId;
    return data;
  }
}