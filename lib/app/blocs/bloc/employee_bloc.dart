import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import '../../models/hive/employee_model.dart';
import '../events/employee_event.dart';
import '../state/employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final Box<Employee> employeeBox;

  EmployeeBloc(this.employeeBox) : super(EmployeeLoading()) {

    on<LoadEmployees>((event, emit) {
      final allEmployees = employeeBox.values.toList();
      if(allEmployees.isEmpty){
        emit(EmployeeNoDataFound());
        print('====================${allEmployees.length}');
      }else{
        final currentEmployees = allEmployees.where((e) => e.dateTo == null).toList();
        final previousEmployees = allEmployees.where((e) => e.dateTo != null).toList();

        emit(EmployeeLoaded(
          currentEmployees: currentEmployees,
          previousEmployees: previousEmployees,
        ));
      }


    });

    on<AddEmployee>((event, emit) async {
      await employeeBox.add(event.employee);
      add(LoadEmployees());
    });

    on<MoveToPrevious>((event, emit) async {
      final index = employeeBox.values.toList().indexOf(event.employee);
      final updatedEmployee = Employee(
        name: event.employee.name,
        title: event.employee.title,
        dateFrom: event.employee.dateFrom,
        dateTo: DateTime.now(),
      );
      await employeeBox.putAt(index, updatedEmployee);
      add(LoadEmployees());
    });

  }
}
