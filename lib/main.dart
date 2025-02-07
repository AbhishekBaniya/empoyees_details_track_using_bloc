import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'app/models/hive/employee_model.dart';
import 'app/screen/employee_app.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employees');
  runApp(const EmployeeApp());
}

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/adapters.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeveloperAdapter());
  await Hive.openBox<Developer>('developers');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Developer List',
      home: BlocProvider(
        create: (_) => DeveloperBloc()..add(LoadDevelopersEvent()),
        child: const DeveloperListPage(),
      ),
    );
  }
}

// Hive Model
@HiveType(typeId: 0)
class Developer extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime from;

  @HiveField(3)
  DateTime? to;

  Developer({
    required this.name,
    required this.title,
    required this.from,
    this.to,
  });
}

// Bloc Events
abstract class DeveloperEvent {}

class LoadDevelopersEvent extends DeveloperEvent {}

class AddDeveloperEvent extends DeveloperEvent {
  final Developer developer;
  AddDeveloperEvent(this.developer);
}

class DeleteDeveloperEvent extends DeveloperEvent {
  final Developer developer;
  DeleteDeveloperEvent(this.developer);
}

// Bloc State
abstract class DeveloperState {}

class DeveloperLoadingState extends DeveloperState {}

class DeveloperLoadedState extends DeveloperState {
  final List<Developer> current;
  final List<Developer> previous;
  DeveloperLoadedState({required this.current, required this.previous});
}

// Bloc Implementation
class DeveloperBloc extends Bloc<DeveloperEvent, DeveloperState> {
  final Box<Developer> _developerBox = Hive.box<Developer>('developers');

  DeveloperBloc() : super(DeveloperLoadingState()) {
    on<LoadDevelopersEvent>((event, emit) {
      final developers = _developerBox.values.toList();
      final current = developers.where((d) => d.to == null).toList();
      final previous = developers.where((d) => d.to != null).toList();
      emit(DeveloperLoadedState(current: current, previous: previous));
    });

    on<AddDeveloperEvent>((event, emit) async {
      await _developerBox.add(event.developer);
      add(LoadDevelopersEvent());
    });

    on<DeleteDeveloperEvent>((event, emit) async {
      await event.developer.delete();
      add(LoadDevelopersEvent());
    });
  }
}

// UI
class DeveloperListPage extends StatelessWidget {
  const DeveloperListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Developer List')),
      body: BlocBuilder<DeveloperBloc, DeveloperState>(
        builder: (context, state) {
          if (state is DeveloperLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DeveloperLoadedState) {
            return Column(
              children: [
                _buildSection('Current Employees', state.current, context),
                _buildSection('Previous Employees', state.previous, context),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDeveloperDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(String title, List<Developer> developers, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: developers.length,
              itemBuilder: (context, index) {
                final developer = developers[index];
                return Dismissible(
                  key: Key(developer.key.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (_) => context.read<DeveloperBloc>().add(DeleteDeveloperEvent(developer)),
                  child: ListTile(
                    title: Text(developer.name),
                    subtitle: Text('${developer.title}\nFrom: ${DateFormat.yMMMd().format(developer.from)} ${developer.to != null ? '\nTo: ${DateFormat.yMMMd().format(developer.to!)}' : ''}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeveloperDialog(BuildContext context, [Developer? developer]) {
    final nameController = TextEditingController(text: developer?.name);
    final titles = ['Software Engineer', 'Product Manager', 'Designer', 'Data Scientist'];
    String? selectedTitle = developer?.title;
    DateTime? fromDate = developer?.from;
    DateTime? toDate = developer?.to;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(developer == null ? 'Add Developer' : 'Edit Developer'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedTitle,
                  items: titles.map((title) => DropdownMenuItem(value: title, child: Text(title))).toList(),
                  onChanged: (value) => selectedTitle = value,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: fromDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) fromDate = picked;
                        },
                        child: Text(fromDate == null ? 'Select From Date' : 'From: ${DateFormat.yMMMd().format(fromDate!)}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: toDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) toDate = picked;
                        },
                        child: Text(toDate == null ? 'Select To Date' : 'To: ${DateFormat.yMMMd().format(toDate!)}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedTitle != null && fromDate != null) {
                  final newDeveloper = Developer(
                    name: nameController.text,
                    title: selectedTitle!,
                    from: fromDate!,
                    to: toDate,
                  );
                  context.read<DeveloperBloc>().add(AddDeveloperEvent(newDeveloper));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}*/
