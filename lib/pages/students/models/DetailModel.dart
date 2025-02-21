class DetailModel {
  String? status;
  String? message;
  Null? sql;
  StudentDetail? studentDetail;

  DetailModel({this.status, this.message, this.sql, this.studentDetail});

  DetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    sql = json['sql'];
    studentDetail = json['student_detail'] != null
        ? StudentDetail.fromJson(json['student_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['sql'] = sql;
    if (studentDetail != null) {
      data['student_detail'] = studentDetail!.toJson();
    }
    return data;
  }
}

class StudentDetail {
  String? id;
  int? branchId;
  String? fname;
  String? username;
  String? lname;
  String? joiningDate;
  String? batches;
  String? discount;
  String? amount;
  String? totalAmount;
  String? unpaidAmount;
  int? paidAmount;
  String? installmentType;
  List<Installments>? installments;

  StudentDetail(
      {
        this.id,
        this.branchId,
        this.fname,
        this.username,
        this.lname,
        this.joiningDate,
        this.batches,
        this.discount,
        this.amount,
        this.totalAmount,
        this.unpaidAmount,
        this.paidAmount,
        this.installmentType,
        this.installments});

  StudentDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    fname = json['fname'];
    username = json['username'];
    lname = json['lname'];
    joiningDate = json['joining_date'];
    batches = json['batches'];
    discount = json['discount'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    unpaidAmount = json['unpaid_amount'];
    paidAmount = json['paid_amount'];
    installmentType = json['installment_type'];
    if (json['installments'] != null) {
      installments = <Installments>[];
      json['installments'].forEach((v) {
        installments!.add(new Installments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['fname'] = this.fname;
    data['username'] = this.username;
    data['lname'] = this.lname;
    data['joining_date'] = this.joiningDate;
    data['batches'] = this.batches;
    data['discount'] = this.discount;
    data['amount'] = this.amount;
    data['total_amount'] = this.totalAmount;
    data['unpaid_amount'] = this.unpaidAmount;
    data['paid_amount'] = this.paidAmount;
    data['installment_type'] = this.installmentType;
    if (this.installments != null) {
      data['installments'] = this.installments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Installments {
  String? id;
  String? status;
  String? insAmount;
  String? insDate;

  Installments({this.id, this.status, this.insAmount, this.insDate});

  Installments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    insAmount = json['insAmount'];
    insDate = json['insDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['insAmount'] = this.insAmount;
    data['insDate'] = this.insDate;
    return data;
  }
}