class UpdateModel {
  String? status;
  String? message;
  String? version;
  int? isRequired;

  UpdateModel({this.status, this.message, this.version,this.isRequired});

  UpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    version = json['version'];
    isRequired = json['isRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['version'] = version;
    data['isRequired'] = isRequired;
    return data;
  }
}