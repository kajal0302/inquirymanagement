class PartnerModel {
  String? status;
  String? message;
  List<Partners>? partners;

  PartnerModel({this.status, this.message, this.partners});

  PartnerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['partners'] != null) {
      partners = <Partners>[];
      json['partners'].forEach((v) {
        partners!.add(new Partners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.partners != null) {
      data['partners'] = this.partners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Partners {
  String? id;
  String? partnerName;

  Partners({this.id, this.partnerName});

  Partners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partnerName = json['partner_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['partner_name'] = this.partnerName;
    return data;
  }
}