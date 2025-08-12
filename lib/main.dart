import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app_practice/widgets/wrapper.dart';
import 'package:todo_app_practice/widgets/add_bottom_sheet.dart';
import 'package:todo_app_practice/models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  final List<Task> tasks = [];

  // Future<void> saveTasks() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String encodedData = jsonEncode(tasks);
  //   await prefs.setString('tasks', encodedData);
  // }
  //
  // Future<void> loadTasks() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? saveTasks = prefs.getString('tasks');
  //
  //   if (saveTasks != null){
  //     List<Task> decodedData = List<Task>.from(jsonDecode(saveTasks));
  //     setState((){
  //       tasks = decodedData;
  //     });
  //   }
  // }

  void addTask(String id, TextEditingController textFieldController, DateTime scheduleAt){
    if(textFieldController.text.isNotEmpty){
      setState((){
        tasks.add(Task(id: id, task: textFieldController.text, scheduleAt: scheduleAt));
      });
    }

    textFieldController.clear();
  }

  void editTask(Task updateTask){
    setState((){
      final index = tasks.indexWhere((task) => task.id == updateTask.id);
      if (index != -1) {
        tasks[index] = updateTask;
      }
    });
  }

  void removeTask(String id){
    setState((){
      tasks.removeWhere((task) => task.id == id);
    });
  }

  void toogleTaskStatus(String id){
    setState((){
      final index = tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        tasks[index].isDone = !tasks[index].isDone;
      }
    });
  }

  //calender widget state
  PageController pageController = PageController(initialPage: 1000);
  int currentPage = 1000;
  DateTime selectedDate = DateTime.now();

  void onDateSelected(DateTime date){
    setState((){
      selectedDate = date;
    });
  }

  void changeCurrentPage(int index){
    setState((){
      currentPage = index;
    });
  }

  @override
  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrapper(
        tasks: this.tasks,
        removeTask: this.removeTask,
        toogleTaskStatus: this.toogleTaskStatus,
        editTask: this.editTask,
        pageController: this.pageController,
        selectedDate: this.selectedDate,
        onDateSelected: this.onDateSelected,
        changeCurrentPage: this.changeCurrentPage,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: CircularNotchedRectangle(), // Biar ada notch (takik) buat FAB
        // color: Color(0xFFFAFAFA),
        color: Colors.black,
      ), 
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
              ), // Sudut melengkung
            ),
            context: context,
            builder: (context) => AddBottomSheet(
              addTask: this.addTask,
              selectedDate: this.selectedDate,
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
