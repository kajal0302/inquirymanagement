class LoginUserModel {
  String? status;
  String? message;
  EmployeeDetail? employeeDetail;

  LoginUserModel({this.status, this.message, this.employeeDetail});

  LoginUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    employeeDetail = json['employee_detail'] != null
        ? new EmployeeDetail.fromJson(json['employee_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.employeeDetail != null) {
      data['employee_detail'] = this.employeeDetail!.toJson();
    }
    return data;
  }
}

class EmployeeDetail {
  int? id;
  String? name;
  String? username;
  int? branchId;
  String? image;
  String? userType;
  String? status;
  List<Branch>? branch;

  EmployeeDetail(
      {
        this.id,
        this.name,
        this.username,
        this.branchId,
        this.image,
        this.userType,
        this.status,
        this.branch});

  EmployeeDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    branchId = json['branch_id'];
    image = json['image'];
    userType = json['user_type'];
    status = json['status'];
    // Fix: Initialize branch list properly
    if (json['branch'] != null) {
      branch = []; // Proper initialization
      json['branch'].forEach((v) {
        branch!.add(Branch.fromJson(v)); // Use `!` to ensure it's not null
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['branch_id'] = this.branchId;
    data['image'] = this.image;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    // Fix: Ensure `branch` is not null before mapping
    if (branch != null) {
      data['branch'] = branch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Branch {
  String? id;
  String? name;
  String? address;

  Branch({this.id, this.name, this.address});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}