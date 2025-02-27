class InquiryModel {
  String? status;
  String? message;
  InquiryDetail? inquiryDetail;

  InquiryModel({this.status, this.message, this.inquiryDetail});

  InquiryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    inquiryDetail = json['inquiry_detail'] != null
        ? new InquiryDetail.fromJson(json['inquiry_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.inquiryDetail != null) {
      data['inquiry_detail'] = this.inquiryDetail!.toJson();
    }
    return data;
  }
}

class InquiryDetail {
  int? id;
  String? fname;
  String? lname;
  String? partnerId;
  String? slug;
  String? mobileno;
  String? feedback;
  String? reference;
  String? status;
  int? streamId;
  String? streamName;
  int? standardId;
  String? standardName;
  int? subjectId;
  String? subjectName;
  int? smsmessageId;
  String? smsContent;
  String? messageNotification;
  String? inquiyDate;
  String? installmentDate;
  String? upcomingConfirmDate;
  String? notificationDay;
  String? endNotificationDate;
  int? branchId;
  String? branchName;
  List<Courses>? courses;

  InquiryDetail(
      {this.id,
        this.fname,
        this.lname,
        this.partnerId,
        this.slug,
        this.mobileno,
        this.feedback,
        this.reference,
        this.status,
        this.streamId,
        this.streamName,
        this.standardId,
        this.standardName,
        this.subjectId,
        this.subjectName,
        this.smsmessageId,
        this.smsContent,
        this.messageNotification,
        this.inquiyDate,
        this.installmentDate,
        this.upcomingConfirmDate,
        this.notificationDay,
        this.endNotificationDate,
        this.branchId,
        this.branchName,
        this.courses});

  InquiryDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    lname = json['lname'];
    partnerId = json['partner_id'];
    slug = json['slug'];
    mobileno = json['mobileno'];
    feedback = json['feedback'];
    reference = json['reference'];
    status = json['status'];
    streamId = json['stream_id'];
    streamName = json['stream_name'];
    standardId = json['standard_id'];
    standardName = json['standard_name'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    smsmessageId = json['smsmessage_id'];
    smsContent = json['sms_content'];
    messageNotification = json['message_notification'];
    inquiyDate = json['inquiy_date'];
    installmentDate = json['installment_date'];
    upcomingConfirmDate = json['upcoming_confirm_date'];
    notificationDay = json['notification_day'];
    endNotificationDate = json['end_notification_date'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['partner_id'] = this.partnerId;
    data['slug'] = this.slug;
    data['mobileno'] = this.mobileno;
    data['feedback'] = this.feedback;
    data['reference'] = this.reference;
    data['status'] = this.status;
    data['stream_id'] = this.streamId;
    data['stream_name'] = this.streamName;
    data['standard_id'] = this.standardId;
    data['standard_name'] = this.standardName;
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    data['smsmessage_id'] = this.smsmessageId;
    data['sms_content'] = this.smsContent;
    data['message_notification'] = this.messageNotification;
    data['inquiy_date'] = this.inquiyDate;
    data['installment_date'] = this.installmentDate;
    data['upcoming_confirm_date'] = this.upcomingConfirmDate;
    data['notification_day'] = this.notificationDay;
    data['end_notification_date'] = this.endNotificationDate;
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  int? id;
  String? name;
  String? image;

  Courses({this.id, this.name, this.image});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}