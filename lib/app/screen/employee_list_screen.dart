import 'package:empoyees_details_track/app/screen/add_employee_screen.dart';
import 'package:empoyees_details_track/app/utils/enum/svg_enum.dart';
import 'package:empoyees_details_track/app/widgets/app_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc/employee_bloc.dart';
import '../blocs/events/employee_event.dart';
import '../blocs/state/employee_state.dart';
import '../core/res/app_assets_path.dart';
import '../models/hive/employee_model.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          else if (state is EmployeeNoDataFound) {
            return Center(child: AppSvgWidget(svgPath: Assets.noDataFound, height: 244.38, width: 261.79, svgType: SvgType.asset,));
          } else if (state is EmployeeLoaded) {
            return ListView(
              children: [
                _buildSection('Current Employees', state.currentEmployees, context),
                _buildSection('Previous Employees', state.previousEmployees, context, isPrevious: true),
              ],
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEmployeeScreen(context),
        child: Icon(Icons.add),
      ),
    );
  }

  /*Widget _buildSection(String title, List<Employee> employees, BuildContext context, {bool isPrevious = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...employees.map((e) => ListTile(
          title: Text(e.name),
          subtitle: Text('${e.title}\n${e.dateFrom} - ${e.dateTo ?? "Present"}'),
          trailing: isPrevious
              ? null
              : IconButton(
            icon: Icon(Icons.archive),
            onPressed: () => BlocProvider.of<EmployeeBloc>(context).add(MoveToPrevious(e)),
          ),
        )),
      ],
    );
  }*/

  Widget _buildSection(String title, List<Employee> employees, BuildContext context, {bool isPrevious = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...employees.map((e) => Dismissible(
          key: GlobalKey(), // Ensure each employee has a unique ID
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            BlocProvider.of<EmployeeBloc>(context).add(MoveToPrevious(e));
          },
          child: ListTile(
            title: Text(e.name),
            subtitle: Text('${e.title}\n${e.dateFrom} - ${e.dateTo ?? "Present"}'),
            trailing: isPrevious
                ? null
                : IconButton(
              icon: Icon(Icons.archive),
              onPressed: () => BlocProvider.of<EmployeeBloc>(context).add(MoveToPrevious(e)),
            ),
          ),
        )),
      ],
    );
  }
  
  void _addEmployeeScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),);
  }
}
