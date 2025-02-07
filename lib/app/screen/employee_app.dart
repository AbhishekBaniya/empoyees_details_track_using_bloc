import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc/employee_bloc.dart';
import '../blocs/events/employee_event.dart';
import '../models/hive/employee_model.dart';
import 'employee_list_screen.dart';
import 'package:hive/hive.dart';

class EmployeeApp extends StatelessWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(Hive.box<Employee>('employees'))..add(LoadEmployees()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: EmployeeListScreen(),
      ),
    );
  }
}
