class StudentModel {
  String? status;
  String? message;
  List<Students>? students;

  StudentModel({this.status, this.message, this.students});

  StudentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  int? id;
  String? loginId;
  String? uniqueId;
  int? branchId;
  String? batchId;
  String? partnerId;
  String? standardId;
  String? course;
  String? slug;
  String? fcmToken;
  String? fname;
  String? lname;
  String? image;
  String? qrcode;
  String? parentname;
  String? mobileno;
  String? whatsappno;
  String? parentmobileno;
  String? dob;
  String? address;
  String? joiningDate;
  String? installmentDate;
  String? email;
  String? paymentMode;
  int? paidAmount;
  String? unpaidAmount;
  String? totalAmount;
  String? paybleAmount;
  String? discount;
  String? installmentType;
  String? gender;
  String? username;
  String? password;
  String? pwd;
  String? feedback;
  String? reference;
  String? coursesStatus;
  String? status;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? lastUpdatedBy;
  String? prevUpdatedBy;
  String? deletedAt;
  String? isDelete;
  String? batchName;
  Installment? installment;
  String? inOutStatus;
  String? amount;
  String? courseStatus;
  List<Null>? courses;
  String? wamobileno;
  List<Subjects>? subjects;

  Students(
      {this.id,
        this.loginId,
        this.uniqueId,
        this.branchId,
        this.batchId,
        this.partnerId,
        this.standardId,
        this.course,
        this.slug,
        this.fcmToken,
        this.fname,
        this.lname,
        this.image,
        this.qrcode,
        this.parentname,
        this.mobileno,
        this.whatsappno,
        this.parentmobileno,
        this.dob,
        this.address,
        this.joiningDate,
        this.installmentDate,
        this.email,
        this.paymentMode,
        this.paidAmount,
        this.unpaidAmount,
        this.totalAmount,
        this.paybleAmount,
        this.discount,
        this.installmentType,
        this.gender,
        this.username,
        this.password,
        this.pwd,
        this.feedback,
        this.reference,
        this.coursesStatus,
        this.status,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.lastUpdatedBy,
        this.prevUpdatedBy,
        this.deletedAt,
        this.isDelete,
        this.batchName,
        this.installment,
        this.inOutStatus,
        this.amount,
        this.courseStatus,
        this.courses,
        this.wamobileno,
        this.subjects});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loginId = json['login_id'];
    uniqueId = json['unique_id'];
    branchId = json['branch_id'];
    batchId = json['batch_id'];
    partnerId = json['partner_id'];
    standardId = json['standard_id'];
    course = json['course'];
    slug = json['slug'];
    fcmToken = json['fcm_token'];
    fname = json['fname'];
    lname = json['lname'];
    image = json['image'];
    qrcode = json['qrcode'];
    parentname = json['parentname'];
    mobileno = json['mobileno'];
    whatsappno = json['whatsappno'];
    parentmobileno = json['parentmobileno'];
    dob = json['dob'];
    address = json['address'];
    joiningDate = json['joining_date'];
    installmentDate = json['installment_date'];
    email = json['email'];
    paymentMode = json['payment_mode'];
    paidAmount = json['paid_amount'];
    unpaidAmount = json['unpaid_amount'];
    totalAmount = json['total_amount'];
    paybleAmount = json['payble_amount'];
    discount = json['discount'];
    installmentType = json['installment_type'];
    gender = json['gender'];
    username = json['username'];
    password = json['password'];
    pwd = json['pwd'];
    feedback = json['feedback'];
    reference = json['reference'];
    coursesStatus = json['courses_status'];
    status = json['status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    lastUpdatedBy = json['last_updated_by'];
    prevUpdatedBy = json['prev_updated_by'];
    deletedAt = json['deleted_at'];
    isDelete = json['is_delete'];
    batchName = json['batch_name'];
    installment = json['installment'] != null
        ? new Installment.fromJson(json['installment'])
        : null;
    inOutStatus = json['in_out_status'];
    amount = json['amount'];
    courseStatus = json['course_status'];
    wamobileno = json['wamobileno'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login_id'] = this.loginId;
    data['unique_id'] = this.uniqueId;
    data['branch_id'] = this.branchId;
    data['batch_id'] = this.batchId;
    data['partner_id'] = this.partnerId;
    data['standard_id'] = this.standardId;
    data['course'] = this.course;
    data['slug'] = this.slug;
    data['fcm_token'] = this.fcmToken;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['image'] = this.image;
    data['qrcode'] = this.qrcode;
    data['parentname'] = this.parentname;
    data['mobileno'] = this.mobileno;
    data['whatsappno'] = this.whatsappno;
    data['parentmobileno'] = this.parentmobileno;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['joining_date'] = this.joiningDate;
    data['installment_date'] = this.installmentDate;
    data['email'] = this.email;
    data['payment_mode'] = this.paymentMode;
    data['paid_amount'] = this.paidAmount;
    data['unpaid_amount'] = this.unpaidAmount;
    data['total_amount'] = this.totalAmount;
    data['payble_amount'] = this.paybleAmount;
    data['discount'] = this.discount;
    data['installment_type'] = this.installmentType;
    data['gender'] = this.gender;
    data['username'] = this.username;
    data['password'] = this.password;
    data['pwd'] = this.pwd;
    data['feedback'] = this.feedback;
    data['reference'] = this.reference;
    data['courses_status'] = this.coursesStatus;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['last_updated_by'] = this.lastUpdatedBy;
    data['prev_updated_by'] = this.prevUpdatedBy;
    data['deleted_at'] = this.deletedAt;
    data['is_delete'] = this.isDelete;
    data['batch_name'] = this.batchName;
    if (this.installment != null) {
      data['installment'] = this.installment!.toJson();
    }
    data['in_out_status'] = this.inOutStatus;
    data['amount'] = this.amount;
    data['course_status'] = this.courseStatus;

    data['wamobileno'] = this.wamobileno;
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Installment {
  String? id;
  String? loginId;
  String? studentId;
  String? paymentId;
  String? date;
  String? payment;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? isDelete;

  Installment(
      {this.id,
        this.loginId,
        this.studentId,
        this.paymentId,
        this.date,
        this.payment,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isDelete});

  Installment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loginId = json['login_id'];
    studentId = json['student_id'];
    paymentId = json['payment_id'];
    date = json['date'];
    payment = json['payment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login_id'] = this.loginId;
    data['student_id'] = this.studentId;
    data['payment_id'] = this.paymentId;
    data['date'] = this.date;
    data['payment'] = this.payment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}

class Subjects {
  String? id;
  String? name;
  String? categoryId;
  String? fees;
  String? duration;

  Subjects({this.id, this.name, this.categoryId, this.fees, this.duration});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    categoryId = json['category_id'].toString();
    fees = json['fees'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['fees'] = this.fees;
    data['duration'] = this.duration;
    return data;
  }
}