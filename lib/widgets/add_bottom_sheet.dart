import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBottomSheet extends StatefulWidget {

  final void Function(String, TextEditingController, DateTime) addTask;
  final DateTime selectedDate;


  const AddBottomSheet({
    super.key,
    required this.selectedDate,
    required this.addTask,
  });

  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {

  final TextEditingController textFieldController = TextEditingController();
  DateTime? fromDatePicker;
  TimeOfDay? fromTimePicker;

  @override
  void initState() {
    super.initState();
  }

  DateTime _combineDateAndTime() {
    DateTime? tempDate = fromDatePicker ?? widget.selectedDate;
    TimeOfDay? tempTime = fromTimePicker ?? TimeOfDay.now();

    final combinedDateTime = DateTime(
      tempDate!.year,
      tempDate!.month,
      tempDate!.day,
      tempTime!.hour,
      tempTime!.minute,
    );

    return combinedDateTime!;
  }

  String _generateTaskId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose(){
    super.dispose();
    textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, top: 16,
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
                      initialDate: widget.selectedDate,
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
                  child: Text(DateFormat('dd/MM/yyyy').format(fromDatePicker ?? widget.selectedDate)),
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
                      initialTime: TimeOfDay.now(),
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
                  child: Text( fromTimePicker != null ? DateFormat('HH:mm').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, fromTimePicker!.hour, fromTimePicker!.minute)) : DateFormat('HH:mm').format( DateTime.now().copyWith(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute)))
                ),
                Spacer(),
                Material(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      final DateTime dateTime = _combineDateAndTime();
                      final id = _generateTaskId();

                      widget.addTask(id, textFieldController, dateTime);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add, color: Colors.white)
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
