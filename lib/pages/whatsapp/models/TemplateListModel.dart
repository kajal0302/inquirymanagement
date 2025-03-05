class TemplateListModel {
  String? status;
  String? message;
  List<Data>? data;

  TemplateListModel({this.status, this.message, this.data});

  TemplateListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
}

class Data {
  int? id;
  int? clientId;
  int? bodyCount;
  int? headerCount;
  int? messageId;
  String? name;
  String? pic;
  int? text;
  int? image;
  int? video;
  int? document;
  int? reply;
  int? phone;
  int? url1;
  int? url2;
  int? copyCode;
  Null templateComponents;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  List<String>? bodyParam;
  String? string;

  Data(
      {this.id,
        this.clientId,
        this.bodyCount,
        this.headerCount,
        this.messageId,
        this.name,
        this.pic,
        this.text,
        this.image,
        this.video,
        this.document,
        this.reply,
        this.phone,
        this.url1,
        this.url2,
        this.copyCode,
        this.templateComponents,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.bodyParam,
        this.string});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    bodyCount = json['body_count'];
    headerCount = json['header_count'];
    messageId = json['messageId'];
    name = json['name'];
    pic = json['pic'];
    text = json['text'];
    image = json['image'];
    video = json['video'];
    document = json['document'];
    reply = json['reply'];
    phone = json['phone'];
    url1 = json['url1'];
    url2 = json['url2'];
    copyCode = json['copy_code'];
    templateComponents = json['template_components'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bodyParam = json['body_param'].cast<String>();
    string = json['string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['body_count'] = bodyCount;
    data['header_count'] = headerCount;
    data['messageId'] = messageId;
    data['name'] = name;
    data['pic'] = pic;
    data['text'] = text;
    data['image'] = image;
    data['video'] = video;
    data['document'] = document;
    data['reply'] = reply;
    data['phone'] = phone;
    data['url1'] = url1;
    data['url2'] = url2;
    data['copy_code'] = copyCode;
    data['template_components'] = templateComponents;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['body_param'] = bodyParam;
    data['string'] = string;
    return data;
  }
}