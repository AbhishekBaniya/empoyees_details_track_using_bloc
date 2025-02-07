import 'package:empoyees_details_track/app/widgets/app_custom_button.dart';
import 'package:empoyees_details_track/app/widgets/app_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc/employee_bloc.dart';
import '../blocs/events/employee_event.dart';
import '../blocs/state/add_employee_state.dart';
import '../blocs/state/employee_state.dart';
import '../core/res/app_assets_path.dart';
import '../models/hive/employee_model.dart';
import '../utils/enum/button_type_enum.dart';
import '../utils/enum/date_type_enum.dart';
import '../utils/enum/svg_enum.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final employeeName = TextEditingController();
  final role = TextEditingController();
  final doj = TextEditingController();
  final eoeDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Employee"),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          else if (state is EmployeeNoDataFound) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200, width: 3)
                    ),
                    child: TextField(
                      controller: employeeName,
                      decoration: InputDecoration(
                          filled: true, // <- this is required.
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Employee Name",
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppSvgWidget(svgPath: Assets.employeeName, svgType: SvgType.asset, color: Colors.blue,),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200, width: 3)
                    ),
                    child: TextField(
                      controller: role,
                      onTap: (){
                        var roles = ['Software Engineer', 'Product Manager', 'Designer', 'Data Scientist', 'Product Owner', 'Product Manager', 'QA Tester', 'Flutter Developer'];
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Select Role", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: roles.length, // Replace with your actual list
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(roles[index]),
                                        onTap: () {
                                          // Handle selection logic
                                          role.text = roles[index];
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      readOnly: true,
                      keyboardType: TextInputType.none  ,
                      decoration: InputDecoration(
                          filled: true, // <- this is required.
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Employee Name",
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppSvgWidget(svgPath: Assets.jobTitle, svgType: SvgType.asset, color: Colors.blue,),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: AppSvgWidget(svgPath: Assets.downArrow, svgType: SvgType.asset, color: Colors.blue,),
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 8,),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200, width: 3),
                          ),
                          child: TextField(
                            onTap: (){
                              _openCalendar(context, dateType: DateType.joining,);
                            },
                            readOnly: true,
                            controller: doj,
                            decoration: InputDecoration(
                                filled: true, // <- this is required.
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Select Date",
                                fillColor: Colors.white,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppSvgWidget(svgPath: Assets.dateCalendar, svgType: SvgType.asset, color: Colors.blue,),
                                )
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Icon(Icons.arrow_forward_rounded, size: 24, color: Colors.blue,),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200, width: 3),
                          ),
                          child: TextField(
                            onTap: (){
                              _openCalendar(context, dateType: DateType.ending,);
                            },
                            readOnly: true,
                            controller: eoeDate,
                            decoration: InputDecoration(
                                filled: true, // <- this is required.
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Select Date",
                                fillColor: Colors.white,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppSvgWidget(svgPath: Assets.dateCalendar, svgType: SvgType.asset, color: Colors.blue,),
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            );
          }else if (state is EmployeeLoaded) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200, width: 3)
                    ),
                    child: TextField(
                      controller: employeeName,
                      decoration: InputDecoration(
                          filled: true, // <- this is required.
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Employee Name",
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppSvgWidget(svgPath: Assets.employeeName, svgType: SvgType.asset, color: Colors.blue,),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200, width: 3)
                    ),
                    child: TextField(
                      controller: role,
                      onTap: (){
                        var roles = ['Software Engineer', 'Product Manager', 'Designer', 'Data Scientist', 'Product Owner', 'Product Manager', 'QA Tester', 'Flutter Developer'];
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Select Role", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: roles.length, // Replace with your actual list
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(roles[index]),
                                        onTap: () {
                                          // Handle selection logic
                                          role.text = roles[index];
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      readOnly: true,
                      keyboardType: TextInputType.none  ,
                      decoration: InputDecoration(
                          filled: true, // <- this is required.
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Employee Name",
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppSvgWidget(svgPath: Assets.jobTitle, svgType: SvgType.asset, color: Colors.blue,),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: AppSvgWidget(svgPath: Assets.downArrow, svgType: SvgType.asset, color: Colors.blue,),
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 8,),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200, width: 3),
                          ),
                          child: TextField(
                            onTap: (){
                              _openCalendar(context, dateType: DateType.joining,);
                            },
                            readOnly: true,
                            controller: doj,
                            decoration: InputDecoration(
                                filled: true, // <- this is required.
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Select Date",
                                fillColor: Colors.white,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppSvgWidget(svgPath: Assets.dateCalendar, svgType: SvgType.asset, color: Colors.blue,),
                                )
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Icon(Icons.arrow_forward_rounded, size: 24, color: Colors.blue,),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200, width: 3),
                          ),
                          child: TextField(
                            onTap: (){
                              _openCalendar(context, dateType: DateType.ending,);
                            },
                            readOnly: true,
                            controller: eoeDate,
                            decoration: InputDecoration(
                                filled: true, // <- this is required.
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Select Date",
                                fillColor: Colors.white,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppSvgWidget(svgPath: Assets.dateCalendar, svgType: SvgType.asset, color: Colors.blue,),
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            );
          }
          return Container();
        },
      ),


      bottomNavigationBar: SizedBox(
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(color: Colors.grey.shade200, height: 3,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(onTap: (){

                }, child: AppCustomButtonWidget(buttonType: ButtonType.opacity,)),
                GestureDetector(onTap: (){

                  if (employeeName.text.isNotEmpty && role.text.isNotEmpty) {
                    final employee = Employee(
                      name: employeeName.text.trim(),
                      title: role.text.trim(),
                      dateTo: doj.text.isNotEmpty ? DateTime.parse(doj.text) : null,
                      dateFrom: eoeDate.text.isNotEmpty ? DateTime.parse(doj.text) : null,
                    );
                    BlocProvider.of<EmployeeBloc>(context).add(AddEmployee(employee));
                    Navigator.pop(context);
                  }
                }, child: AppCustomButtonWidget(buttonType: ButtonType.filled,)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openCalendar(BuildContext context, {required Enum dateType}) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.light(primary: Colors.blue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      switch (dateType) {
        case DateType.joining:
          doj.text = selectedDate.toString().replaceAll(RegExp(r'\s00:00:00\.000'), '');
          break;
        case DateType.ending:
          eoeDate.text = selectedDate.toString().replaceAll(RegExp(r'\s00:00:00\.000'), '');
          break;
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected date: ${selectedDate.toLocal()}')),
      );*/
    }
  }

  void _addEmployeeDialog(BuildContext context) {
    final nameController = TextEditingController();
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Employee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {

            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
}
