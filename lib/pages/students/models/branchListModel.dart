class StudentBranchListModel {
  String? status;
  String? message;
  List<Branches>? branches;

  StudentBranchListModel({this.status, this.message, this.branches});

  StudentBranchListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((v) {
        branches!.add(new Branches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.branches != null) {
      data['branches'] = this.branches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Branches {
  int? id;
  String? name;
  String? address;
  String? contactNo;
  String? email;
  String? mapLocation;

  Branches(
      {this.id,
        this.name,
        this.address,
        this.contactNo,
        this.email,
        this.mapLocation});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    contactNo = json['contact_no'];
    email = json['email'];
    mapLocation = json['map_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['contact_no'] = this.contactNo;
    data['email'] = this.email;
    data['map_location'] = this.mapLocation;
    return data;
  }
}