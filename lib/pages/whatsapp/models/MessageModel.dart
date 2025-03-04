class MessagesModel {
  String? message;
  List<MessageData>? data;

  MessagesModel({this.message, this.data});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MessageData>[];
      json['data'].forEach((v) {
        data!.add(MessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String? get getMessage => message;
  List<MessageData>? get getData => data;
}

class MessageData {
  int? id;
  String? message;
  int? status;
  String? createdAt;
  bool? sent;
  String? time;
  String? headerLink;
  String? updatedAt;

  MessageData({
    this.id,
    this.message,
    this.status,
    this.createdAt,
    this.sent,
    this.time,
    this.headerLink,
    this.updatedAt,
  });

  MessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
    sent = json['sent'];
    time = json['time'];
    headerLink = json['header_link'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['sent'] = sent;
    data['time'] = time;
    data['header_link'] = headerLink;
    data['updated_at'] = updatedAt;
    return data;
  }
}
