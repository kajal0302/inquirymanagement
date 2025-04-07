class NotificationModel {
  String? status;
  String? message;
  List<Inquiries>? inquiries;
  int? count;

  NotificationModel({this.status, this.message, this.inquiries});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['inquiries'] != null) {
      inquiries = <Inquiries>[];
      json['inquiries'].forEach((v) {
        inquiries!.add(new Inquiries.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.inquiries != null) {
      data['inquiries'] = this.inquiries!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Inquiries {
  int? id;
  String? slug;
  String? smsDate;
  String? smsContent;
  String? fname;
  String? lname;
  String? contact;
  String? inquiryDate;
  String? status;
  String? notificationDay;
  String? upcomingConfirmDate;
  int? branchId;
  String? branchName;
  List<Courses>? courses;

  Inquiries(
      {this.id,
        this.slug,
        this.smsDate,
        this.smsContent,
        this.fname,
        this.lname,
        this.contact,
        this.inquiryDate,
        this.status,
        this.notificationDay,
        this.upcomingConfirmDate,
        this.branchId,
        this.branchName,
        this.courses});

  Inquiries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    smsDate = json['sms_date'];
    smsContent = json['sms_content'];
    fname = json['fname'];
    lname = json['lname'];
    contact = json['contact'];
    inquiryDate = json['inquiry_date'];
    status = json['status'];
    notificationDay = json['notification_day'];
    upcomingConfirmDate = json['upcoming_confirm_date'];
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
    data['slug'] = this.slug;
    data['sms_date'] = this.smsDate;
    data['sms_content'] = this.smsContent;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['contact'] = this.contact;
    data['inquiry_date'] = this.inquiryDate;
    data['status'] = this.status;
    data['notification_day'] = this.notificationDay;
    data['upcoming_confirm_date'] = this.upcomingConfirmDate;
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