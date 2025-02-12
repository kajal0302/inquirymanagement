import 'package:hive/hive.dart';

part 'branch.g.dart'; // This will be generated automatically

@HiveType(typeId: 0)
class Branch {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String address;

  Branch({required this.id, required this.name, required this.address});
}
