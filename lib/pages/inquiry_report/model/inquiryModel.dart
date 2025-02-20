class InquiryModel {
  String? status;
  String? message;
  List<Inquiries>? inquiries;

  InquiryModel({this.status, this.message, this.inquiries});

  InquiryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['inquiries'] != null) {
      inquiries = <Inquiries>[];
      json['inquiries'].forEach((v) {
        inquiries!.add(new Inquiries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.inquiries != null) {
      data['inquiries'] = this.inquiries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Inquiries {
  String? id;
  String? slug;
  String? smsContent;
  String? fname;
  String? lname;
  String? contact;
  String? inquiryDate;
  String? status;
  int? branchId;
  String? branchName;
  String? notificationDay;
  String? upcomingConfirmDate;
  String? endNotificationDate;
  List<Courses>? courses;

  Inquiries(
      {this.id,
        this.slug,
        this.smsContent,
        this.fname,
        this.lname,
        this.contact,
        this.inquiryDate,
        this.status,
        this.branchId,
        this.branchName,
        this.notificationDay,
        this.upcomingConfirmDate,
        this.endNotificationDate,
        this.courses});

  Inquiries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    smsContent = json['sms_content'];
    fname = json['fname'];
    lname = json['lname'];
    contact = json['contact'];
    inquiryDate = json['inquiry_date'];
    status = json['status'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    notificationDay = json['notification_day'];
    upcomingConfirmDate = json['upcoming_confirm_date'];
    endNotificationDate = json['end_notification_date'];
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
    data['slug'] = this.slug;
    data['sms_content'] = this.smsContent;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['contact'] = this.contact;
    data['inquiry_date'] = this.inquiryDate;
    data['status'] = this.status;
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    data['notification_day'] = this.notificationDay;
    data['upcoming_confirm_date'] = this.upcomingConfirmDate;
    data['end_notification_date'] = this.endNotificationDate;
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