import 'package:equatable/equatable.dart';

import '../../models/hive/employee_model.dart';

abstract class AddEmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadRoles extends AddEmployeeState {}
class SelectEmployeeRole extends AddEmployeeState {}

