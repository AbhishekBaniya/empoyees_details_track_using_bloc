import 'package:equatable/equatable.dart';

import '../../models/hive/employee_model.dart';

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class MoveToPrevious extends EmployeeEvent {
  final Employee employee;

  MoveToPrevious(this.employee);

  @override
  List<Object?> get props => [employee];
}
