class ContactListModel {
  int? statusCode;
  String? status;
  String? message;
  List<Contacts>? data;

  ContactListModel({this.statusCode, this.status, this.message, this.data});

  ContactListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Contacts>[];
      json['data'].forEach((v) {
        data!.add(Contacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  int? get getStatusCode => statusCode;
  String? get getStatus => status;
  String? get getMessage => message;
  List<Contacts>? get getData => data;

}
class Contacts {
  int? id;
  String? name;
  String? waId;
  String? wpId;
  String? createdAt;
  String? updatedAt;
  Object? deletedAt;

  Contacts({
    this.id,
    this.name,
    this.waId,
    this.wpId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Contacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    waId = json['wa_id'];
    wpId = json['wp_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['wa_id'] = waId;
    data['wp_id'] = wpId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }

}
