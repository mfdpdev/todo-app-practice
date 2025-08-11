import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_bottom_sheet.dart';
import './../models/task.dart';

class Tasks extends StatelessWidget {
  final List<Task> tasks;
  final DateTime selectedDate;
  final void Function(String) removeTask;
  final void Function(String) toogleTaskStatus;
  final void Function(Task) editTask;

  const Tasks({
    super.key,
    required this.tasks,
    required this.removeTask,
    required this.toogleTaskStatus,
    required this.selectedDate,
    required this.editTask,
  });

  @override
  Widget build(BuildContext context){

    final tasksAccordingToDate = tasks.where((task) => _isSameDate(task.scheduleAt, selectedDate)).toList();
    
    if(tasksAccordingToDate.isEmpty){
      return Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("You don't have any tasks yet", style: TextStyle(
              fontSize: 18,
            )),
            const Text("Start creating recourses by clicking on add icon", style: TextStyle(
              fontSize: 10,
            )),
          ]
        )
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      itemCount: tasksAccordingToDate.length,
      itemBuilder: (BuildContext context, int index) {
        final task = tasksAccordingToDate[index];

        return Padding(
          padding: EdgeInsets.all(6.0),
          child: Material(
            color: Colors.black,
            elevation: 1,
            child: Container(
              // height: 60,
              // color: Color(0xFFFAFAFA),
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0), // Memberikan padding agar elemen tidak terlalu rapat
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(task.task, style: TextStyle(
                      decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                    )),
                    Text(
                      DateFormat("HH:mm").format(task.scheduleAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      )
                    ),
                  ]
                ),
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (bool? value) {
                    toogleTaskStatus(task.id);
                  },
                  activeColor: Colors.black,  // Warna ketika checked
                  checkColor: Colors.white,  // Warna icon check saat checked
                  side: BorderSide(color: Colors.grey, width: 2),  // Warna border saat unchecked
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      style: IconButton.styleFrom(
                        // backgroundColor: Colors.grey[100],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))
                        )
                      ),
                      onPressed: (){
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15.0),
                            ), // Sudut melengkung
                          ),
                          context: context,
                          builder: (context) => EditBottomSheet(
                            task: task,
                            editTask: this.editTask,
                          ),
                        );
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      style: IconButton.styleFrom(
                        // backgroundColor: Colors.grey[100],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))
                        )
                      ),
                      onPressed: (){
                        removeTask(task.id);
                      }
                    ),
                  ]
                )
              ) 
            )
          )
        );
      }
    );
  }
  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
