import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './../models/task.dart';
import 'header.dart';
import 'weekly_calender.dart';
import 'tasks.dart';

class Wrapper extends StatelessWidget {

  final List<Task> tasks;
  final void Function(String) removeTask;
  final void Function(String) toogleTaskStatus;
  final void Function(Task) editTask;

  final pageController;
  final selectedDate;
  final DateTime Function(int) getWeekStart;
  final void Function(DateTime) onDateSelected;
  final List<DateTime> Function(DateTime) getWeekDates;
  final void Function(int) changeCurrentPage;

  const Wrapper({
    super.key,
    required this.tasks,
    required this.removeTask,
    required this.toogleTaskStatus,
    required this.editTask,
    required this.pageController,
    required this.selectedDate,
    required this.getWeekStart,
    required this.onDateSelected,
    required this.getWeekDates,
    required this.changeCurrentPage,
  });
  
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Header(),
              Container(
                height: 140,
                child: WeeklyCalendar(
                  pageController: this.pageController,
                  selectedDate: this.selectedDate,
                  getWeekStart: this.getWeekStart,
                  onDateSelected: this.onDateSelected,
                  getWeekDates: this.getWeekDates,
                  changeCurrentPage: this.changeCurrentPage,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Tasks(
                    tasks: this.tasks,
                    removeTask: this.removeTask,
                    toogleTaskStatus: this.toogleTaskStatus,
                    selectedDate: this.selectedDate,
                    editTask: this.editTask,
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}
