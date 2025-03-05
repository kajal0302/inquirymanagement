class StudentFileter {
  String? status;
  String? message;
  List<StudentsListFilter>? studentsListFilter;

  StudentFileter({this.status, this.message, this.studentsListFilter});

  StudentFileter.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['students'] != null) {
      studentsListFilter = <StudentsListFilter>[];
      json['students'].forEach((v) {
        studentsListFilter!.add(StudentsListFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (studentsListFilter != null) {
      data['students'] = studentsListFilter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentsListFilter {
  String? id;
  bool? isChecked;
  String? unpaidAmount;
  String? whatsappnumber;
  String? fname;
  String? lname;
  String? contact;
  String? branchName;
  String? image;
  String? parentname;
  String? parentmobileno;
  String? address;
  String? email;
  String? reference;
  String? joiningDate;
  String? dob;
  List<Null>? courses;
  String? inOutStatus;
  String? courseStatus;
  String? batchName;

  StudentsListFilter(
      {this.id,
        this.isChecked = false,
        this.unpaidAmount,
        this.whatsappnumber,
        this.fname,
        this.lname,
        this.contact,
        this.branchName,
        this.image,
        this.parentname,
        this.parentmobileno,
        this.address,
        this.email,
        this.reference,
        this.joiningDate,
        this.dob,
        this.courses,
        this.inOutStatus,
        this.courseStatus,
        this.batchName});

  StudentsListFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    unpaidAmount = json['unpaid_amount'];
    whatsappnumber = json['whatsappnumber'];
    fname = json['fname'];
    lname = json['lname'];
    contact = json['contact'];
    branchName = json['branch_name'];
    image = json['image'];
    parentname = json['parentname'];
    parentmobileno = json['parentmobileno'];
    address = json['address'];
    email = json['email'];
    reference = json['reference'];
    joiningDate = json['joining_date'];
    dob = json['dob'];
    inOutStatus = json['in_out_status'];
    courseStatus = json['course_status'];
    batchName = json['batch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unpaid_amount'] = unpaidAmount;
    data['whatsappnumber'] = whatsappnumber;
    data['fname'] = fname;
    data['lname'] = lname;
    data['contact'] = contact;
    data['branch_name'] = branchName;
    data['image'] = image;
    data['parentname'] = parentname;
    data['parentmobileno'] = parentmobileno;
    data['address'] = address;
    data['email'] = email;
    data['reference'] = reference;
    data['joining_date'] = joiningDate;
    data['dob'] = dob;
    data['in_out_status'] = inOutStatus;
    data['course_status'] = courseStatus;
    data['batch_name'] = batchName;
    return data;
  }
}