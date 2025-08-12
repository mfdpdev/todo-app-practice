import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;
import './../models/task.dart';

class EditBottomSheet extends StatefulWidget {
  final Task task;
  final void Function(Task) editTask;
  const EditBottomSheet({super.key, required this.task, required this.editTask});

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {

  late TextEditingController textFieldController;
  DateTime? fromDatePicker;
  TimeOfDay? fromTimePicker;
  
  @override
  void initState(){
    textFieldController = TextEditingController(text: widget.task.task);
    super.initState();
  }

  DateTime _combineDateAndTime() {
    DateTime? tempDate = fromDatePicker ?? widget.task.scheduleAt;
    TimeOfDay? tempTime = fromTimePicker ?? TimeOfDay.fromDateTime(widget.task.scheduleAt);

    final combinedDateTime = DateTime(
      tempDate!.year,
      tempDate!.month,
      tempDate!.day,
      tempTime!.hour,
      tempTime!.minute,
    );

    return combinedDateTime!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        // Agar konten bisa geser ke atas saat keyboard muncul
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textFieldController,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: 'Enter your task here...',
                border: InputBorder.none,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[500],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                    )
                  ),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: widget.task.scheduleAt,
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2050),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData(
                            timePickerTheme: TimePickerThemeData(
                              // backgroundColor: Colors.black,
                              // hourMinuteTextColor: Colors.white,
                              // hourMinuteColor: Colors.grey[800],
                              // dayPeriodTextColor: Colors.amber,
                              // dialHandColor: Colors.amber,
                              // dialBackgroundColor: Colors.grey[900],
                              // entryModeIconColor: Colors.amber,
                            ),
                            colorScheme: ColorScheme.light(
                              primary: Colors.black,
                              // onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    setState(() {
                      fromDatePicker = pickedDate!;
                    });
                  },
                  child: Text(DateFormat('dd/MM/yyyy').format(fromDatePicker ?? widget.task.scheduleAt)),
                ),
                SizedBox(width: 4.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[500],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                    )
                  ),
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.dial,
                      initialTime: TimeOfDay.fromDateTime(widget.task.scheduleAt),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            timePickerTheme: TimePickerThemeData(
                              // backgroundColor: Colors.black,
                              // hourMinuteTextColor: Colors.white,
                              // hourMinuteColor: Colors.grey[800],
                              // dayPeriodTextColor: Colors.amber,
                              // dialHandColor: Colors.amber,
                              // dialBackgroundColor: Colors.grey[900],
                              // entryModeIconColor: Colors.amber,
                            ), colorScheme: ColorScheme.light(
                              primary: Colors.black,
                              // onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    setState(() {
                      fromTimePicker = pickedTime!;
                    });
                  },
                  child: Text( fromTimePicker != null ? DateFormat('HH:mm').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, fromTimePicker!.hour, fromTimePicker!.minute)) : DateFormat('HH:mm').format(widget.task.scheduleAt))
                ),
                Spacer(),
                Material(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      final DateTime dateTime = _combineDateAndTime();

                      widget.task.scheduleAt = dateTime;
                      if(textFieldController.text.isNotEmpty){
                        widget.task.task = textFieldController.text;
                      }

                      widget.editTask(widget.task);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.edit, color: Colors.white)
                    )
                  )
                ) 
              ]
            )
          ],
        ),
      ),
    );
  }
}
