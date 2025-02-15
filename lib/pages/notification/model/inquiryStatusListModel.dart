class InquiryStatusModel {
  String? status;
  String? message;
  List<InquiryStatusList>? inquiryStatusList;

  InquiryStatusModel({this.status, this.message, this.inquiryStatusList});

  InquiryStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['inquiry_status_list'] != null) {
      inquiryStatusList = <InquiryStatusList>[];
      json['inquiry_status_list'].forEach((v) {
        inquiryStatusList!.add(new InquiryStatusList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.inquiryStatusList != null) {
      data['inquiry_status_list'] =
          this.inquiryStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InquiryStatusList {
  String? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  InquiryStatusList(
      {this.id, this.name, this.status, this.createdAt, this.updatedAt});

  InquiryStatusList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}