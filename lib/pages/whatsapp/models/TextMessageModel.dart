class TextMessageModel {
  String? status;
  ApiRes? apiRes;
  String? message;
  MessagePayload? messagePayload;

  TextMessageModel({this.status, this.apiRes, this.message, this.messagePayload});

  TextMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    apiRes =
    json['apiRes'] != null ? new ApiRes.fromJson(json['apiRes']) : null;
    message = json['message'];
    messagePayload = json['messagePayload'] != null
        ? new MessagePayload.fromJson(json['messagePayload'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.apiRes != null) {
      data['apiRes'] = this.apiRes!.toJson();
    }
    data['message'] = this.message;
    if (this.messagePayload != null) {
      data['messagePayload'] = this.messagePayload!.toJson();
    }
    return data;
  }
}

class ApiRes {
  String? messagingProduct;
  List<Contacts>? contacts;
  List<Messages>? messages;

  ApiRes({this.messagingProduct, this.contacts, this.messages});

  ApiRes.fromJson(Map<String, dynamic> json) {
    messagingProduct = json['messaging_product'];
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messaging_product'] = this.messagingProduct;
    if (this.contacts != null) {
      data['contacts'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contacts {
  String? input;
  String? waId;

  Contacts({this.input, this.waId});

  Contacts.fromJson(Map<String, dynamic> json) {
    input = json['input'];
    waId = json['wa_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['input'] = this.input;
    data['wa_id'] = this.waId;
    return data;
  }
}

class Messages {
  String? id;

  Messages({this.id});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class MessagePayload {
  String? messagingProduct;
  String? recipientType;
  String? to;
  String? type;
  Text? text;

  MessagePayload(
      {this.messagingProduct,
        this.recipientType,
        this.to,
        this.type,
        this.text});

  MessagePayload.fromJson(Map<String, dynamic> json) {
    messagingProduct = json['messaging_product'];
    recipientType = json['recipient_type'];
    to = json['to'];
    type = json['type'];
    text = json['text'] != null ? new Text.fromJson(json['text']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messaging_product'] = this.messagingProduct;
    data['recipient_type'] = this.recipientType;
    data['to'] = this.to;
    data['type'] = this.type;
    if (this.text != null) {
      data['text'] = this.text!.toJson();
    }
    return data;
  }
}

class Text {
  String? body;

  Text({this.body});

  Text.fromJson(Map<String, dynamic> json) {
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    return data;
  }
}