import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

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

  // final List<String> data = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  final List<Task> tasks = [];
  final TextEditingController textFieldController = TextEditingController();

  // void _addTask(String task, {DateTime? scheduleAt: }){
  void addTask(DateTime scheduleAt){
    if(textFieldController.text.isNotEmpty){
      setState((){
        tasks.add(Task(task: textFieldController.text, scheduleAt: this.selectedDate));
      });
    }

    textFieldController.clear();
  }

  void removeTask(int index){
    setState((){
      tasks.removeAt(index);
    });
  }

  void toogleTaskStatus(int index){
    setState((){
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  //calender widget state
  PageController pageController = PageController(initialPage: 1000);
  int currentPage = 1000;
  DateTime selectedDate = DateTime.now();

  DateTime getWeekStart(int weekOffset) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final monday = now.subtract(Duration(days: weekday - 1));
    return monday.add(Duration(days: 7 * weekOffset));
  }

  void onDateSelected(DateTime date){
    setState((){
      selectedDate = date;
    });
  }

  List<DateTime> getWeekDates(DateTime startOfWeek) {
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  void changeCurrentPage(int index){
    setState((){
      currentPage = index;
    });
  }

  @override
  void dispose(){
    textFieldController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrapper(
        tasks: this.tasks,
        removeTask: this.removeTask,
        toogleTaskStatus: this.toogleTaskStatus,
        pageController: this.pageController,
        selectedDate: this.selectedDate,
        getWeekStart: this.getWeekStart,
        onDateSelected: this.onDateSelected,
        getWeekDates: this.getWeekDates,
        changeCurrentPage: this.changeCurrentPage,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: CircularNotchedRectangle(), // Biar ada notch (takik) buat FAB
        // color: Color(0xFFFAFAFA),
        color: Colors.black,
      ), 
      floatingActionButton: FloatingButton(
        addTask: this.addTask,
        selectedDate: this.selectedDate,
        textFieldController: textFieldController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class FloatingButton extends StatefulWidget {

  final void Function(DateTime) addTask;
  final TextEditingController textFieldController;
  final DateTime selectedDate;

  const FloatingButton({
    super.key,
    required this.addTask,
    required this.selectedDate,
    required this.textFieldController,
  });

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {

  DateTime? fromDatePicker; 
  TimeOfDay? fromTimePicker;

  DateTime? combinedDateTime;

  @override
  void initState(){
    super.initState();
  }

  DateTime _combineDateAndTime() {
    DateTime? tempDate = fromDatePicker != null ? fromDatePicker : widget.selectedDate;
    TimeOfDay? tempTime = fromTimePicker != null ? fromTimePicker : TimeOfDay.now();

    combinedDateTime = DateTime(
      tempDate!.year,
      tempDate!.month,
      tempDate!.day,
      tempTime!.hour,
      tempTime!.minute,
    );

    return combinedDateTime!;
  }

  @override
  Widget build(BuildContext context){
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            ), // Sudut melengkung
          ),
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
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
                      controller: widget.textFieldController,
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
                          child: Text(fromDatePicker != null ? DateFormat('dd/MM/yyyy').format(fromDatePicker!) : DateFormat('dd/MM/yyyy').format(DateTime.now())),
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
                              initialTime: fromTimePicker != null ? fromTimePicker! : TimeOfDay.now(),
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
                          child: Text(fromTimePicker != null ? DateFormat('HH:mm').format( DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, fromTimePicker!.hour, fromTimePicker!.minute))
                                   : DateFormat('HH:mm').format( DateTime.now().copyWith(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute)))
                        ),
                        Spacer(),
                        Material(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              final DateTime dateTime = _combineDateAndTime();
                              widget.addTask(dateTime);
                              fromDatePicker = null;
                              fromTimePicker = null;
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
        ).whenComplete((){
          fromDatePicker = null;
          fromTimePicker = null;
        });
      },
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      shape: CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}

class UpdateBottomSheet extends StatefulWidget {
  const UpdateBottomSheet({super.key});

  @override
  State<UpdateBottomSheet> createState() => _UpdateBottomSheet();
}

class _UpdateBottomSheet extends State<UpdateBottomSheet> {
  
  @override
  void initState(){
    super.initState();
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
              // controller: widget.textFieldController,
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
                      initialDate: DateTime.now(),
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

                    // setState(() {
                    //   fromDatePicker = pickedDate!;
                    // });
                  },
                  child: Text(DateFormat('dd/MM/yyyy').format(DateTime.now())),
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

                    // setState(() {
                    //   fromTimePicker = pickedTime!;
                    // });
                  },
                  child: Text(DateFormat('HH:mm').format( DateTime.now().copyWith(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute))),
                ),
                Spacer(),
                Material(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      // final DateTime dateTime = _combineDateAndTime();
                      // widget.addTask(dateTime);
                      // fromDatePicker = null;
                      // fromTimePicker = null;
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

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  late Timer _timer;

  late String dayName;
  late String hourMinute;
  late String monthShort;
  late String indonesiaTime;
  late String internationalTime;

  void initState(){
    super.initState();
    initializeTimeZones();
    _updateTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      _updateTime();
    });
  }

  void _updateTime(){
    final jakarta = tz.getLocation('Asia/Jakarta');

    final nowJakarta = tz.TZDateTime.now(jakarta);
    final nowUtc = DateTime.now().toUtc();

    setState(() {
      dayName = DateFormat('EEEE, d').format(nowJakarta);
      hourMinute = DateFormat('HH:mm').format(nowJakarta);
      monthShort = DateFormat('MMM').format(nowJakarta).toUpperCase();
      indonesiaTime = DateFormat('hh:mm a').format(nowJakarta);
      internationalTime = DateFormat('hh:mm a').format(nowUtc);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(
        left: 26.0,
        right: 26.0,
        top: 10.0,
        bottom: 0.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              // alignment: Alignment.centerLeft,
              children: <Widget>[
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 20,
                  )
                ),
                PopupMenuButton<int>(
                  icon: Icon(Icons.more_vert),
                  color: Color(0xFFFAFAFA),
                  onSelected: (int value) {

                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("GAtaw mAlezz"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("P!ingin beli trreckk"),
                    ),
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Container(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(hourMinute, 
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Text(monthShort,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ]
                  )
                ),
                Container(
                  width: 1,               // lebar garis
                  height: double.infinity,             // tinggi garis
                  color: Colors.grey,     // warna garis
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(indonesiaTime, 
                            style: TextStyle(
                              fontSize: 20,
                            )
                          ),
                          const Text('Indonesia'),
                        ]
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(internationalTime, 
                            style: TextStyle(
                              fontSize: 20,
                            )
                          ),
                          const Text('UTC Time'),
                        ]
                      ),
                    ]
                  )
                ),
              ]
            ),
          )
        ]
      )
    );
  }
}

class Wrapper extends StatelessWidget {

  final List<Task> tasks;
  final void Function(int) removeTask;
  final void Function(int) toogleTaskStatus;

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

class Task {
  String task;
  bool isDone;
  DateTime scheduleAt;

  Task({required this.task, this.isDone = false, required this.scheduleAt});
}

class Tasks extends StatelessWidget {
  final List<Task> tasks;
  final DateTime selectedDate;
  final void Function(int) removeTask;
  final void Function(int) toogleTaskStatus;

  const Tasks({
    super.key,
    required this.tasks,
    required this.removeTask,
    required this.toogleTaskStatus,
    required this.selectedDate,
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
                    Text(task.task),
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
                  value: true,
                  onChanged: (bool? newValue) {
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
                          builder: (context) => UpdateBottomSheet(),
                          ).whenComplete((){
                          // fromDatePicker = null;
                          // fromTimePicker = null;
                        });
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
                        removeTask(index);
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


class WeeklyCalendar extends StatelessWidget {

  final pageController;
  final selectedDate;
  final DateTime Function(int) getWeekStart;
  final void Function(DateTime) onDateSelected;
  final List<DateTime> Function(DateTime) getWeekDates;
  final void Function(int) changeCurrentPage;

  const WeeklyCalendar({
    super.key,
    required this.pageController,
    required this.selectedDate,
    required this.getWeekStart,
    required this.onDateSelected,
    required this.getWeekDates,
    required this.changeCurrentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            DateFormat('MMM yyyy').format(selectedDate),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 80,
          // width: double.infinity,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (int index) {
              changeCurrentPage(index);
            },
            itemBuilder: (context, index) {
              final weekStart = getWeekStart(index - 1000);
              final weekDates = getWeekDates(weekStart);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weekDates.map((date) {
                  final isToday = _isSameDate(date, DateTime.now());
                  final isSelected = _isSameDate(date, selectedDate);

                  return GestureDetector(
                    onTap: () {
                      onDateSelected(date);
                    },
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E').format(date).substring(0, 1),
                          style: TextStyle(
                            color: Colors.grey,
                          )
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: isSelected ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              )
                            )
                          )
                        )
                      ]
                    )
                  );
                }).toList(),
              );
            }
          ) 
        ),
        Container(
          height: 1,               // lebar garis
          width: double.infinity,             // tinggi garis
          color: Colors.grey,     // warna garis
          margin: EdgeInsets.symmetric(horizontal: 8),
        ),
      ]
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
