class StudentBatchListModel {
  String? status;
  String? message;
  List<Batches>? batches;

  StudentBatchListModel({this.status, this.message, this.batches});

  StudentBatchListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['batches'] != null) {
      batches = <Batches>[];
      json['batches'].forEach((v) {
        batches!.add(new Batches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.batches != null) {
      data['batches'] = this.batches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Batches {
  int? id;
  String? name;
  String? alias;
  String? branch;
  String? status;

  Batches({this.id, this.name, this.alias, this.branch, this.status});

  Batches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    branch = json['branch'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['alias'] = this.alias;
    data['branch'] = this.branch;
    data['status'] = this.status;
    return data;
  }
}