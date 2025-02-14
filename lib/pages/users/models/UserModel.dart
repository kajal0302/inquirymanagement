class UserModel {
  String? status;
  String? message;
  List<Users>? users;

  UserModel({this.status, this.message, this.users});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? slug;
  String? name;
  String? username;
  String? pwd;
  String? userType;
  String? email;
  String? designation;
  String? dob;
  String? joiningDate;
  String? mobileNo;
  String? address;
  String? gender;
  String? file;
  int? branchId;
  String? branchName;
  String? userStatus;

  Users(
      {this.id,
        this.slug,
        this.name,
        this.username,
        this.pwd,
        this.userType,
        this.email,
        this.designation,
        this.dob,
        this.joiningDate,
        this.mobileNo,
        this.address,
        this.gender,
        this.file,
        this.branchId,
        this.branchName,
        this.userStatus});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    username = json['username'];
    pwd = json['pwd'];
    userType = json['user_type'];
    email = json['email'];
    designation = json['designation'];
    dob = json['dob'];
    joiningDate = json['joining_date'];
    mobileNo = json['mobile_no'];
    address = json['address'];
    gender = json['gender'];
    file = json['file'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    userStatus = json['user_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['username'] = this.username;
    data['pwd'] = this.pwd;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['designation'] = this.designation;
    data['dob'] = this.dob;
    data['joining_date'] = this.joiningDate;
    data['mobile_no'] = this.mobileNo;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['file'] = this.file;
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    data['user_status'] = this.userStatus;
    return data;
  }
}