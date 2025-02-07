import 'package:equatable/equatable.dart';

import '../../models/hive/employee_model.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeNoDataFound extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> currentEmployees;
  final List<Employee> previousEmployees;

  EmployeeLoaded({
    required this.currentEmployees,
    required this.previousEmployees,
  });

  @override
  List<Object?> get props => [currentEmployees, previousEmployees];
}

