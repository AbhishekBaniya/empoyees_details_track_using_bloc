import 'package:hive/hive.dart';
part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final DateTime? dateFrom;

  @HiveField(4)
  final DateTime? dateTo;

  Employee({
    this.id,
    required this.name,
    required this.title,
    this.dateFrom,
    this.dateTo,
  });
}
