class BranchDetailModel {
  String? status;
  String? message;
  List<Branches>? branches;

  BranchDetailModel({this.status, this.message, this.branches});

  BranchDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? slug;
  String? address;
  String? email;
  String? contactNo;
  String? mapLocation;
  String? createdAt;

  Branches(
      {this.id,
        this.name,
        this.slug,
        this.address,
        this.email,
        this.contactNo,
        this.mapLocation,
        this.createdAt});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    address = json['address'];
    email = json['email'];
    contactNo = json['contact_no'];
    mapLocation = json['map_location'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['address'] = this.address;
    data['email'] = this.email;
    data['contact_no'] = this.contactNo;
    data['map_location'] = this.mapLocation;
    data['created_at'] = this.createdAt;
    return data;
  }
}